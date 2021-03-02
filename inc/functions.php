<?php

require_once("./inc/Exception.php");
require_once("./inc/PHPMailer.php");
require_once("./inc/SMTP.php");

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

function checkLocal()
{
	$result = false;
	// add a function to check, wether local connected

	// e.g. when installed locally
	//global $fbLocalUrl,$fbSerialNumner;
	//$result = checkLocalUsingFritzBox($fbLocalUrl,$fbSerialNumner);

	// e.g. when there is a dyn dns for the local router...
	global $srvHostname;
	$result = checkLocalByHostname($srvHostname);
$result = true;
	return $result;
}

function checkLocalByHostname($strHostname)
{
	$result = false;
	$srvIp = gethostbyname($strHostname);
	$locIp = $_SERVER['REMOTE_ADDR'];
	if (strcmp($locIp,$srvIp) == 0)
	{
		$result = true;
	}
	return $result;
}

function checkLocalUsingFritzBox ($fbUrl,$fbSerial)
{
	$result = false;
	$j = "http://jason.avm.de/updatecheck/";
	$dom = new DOMDocument();
	$dom->load($fbUrl);
	$i = 0;
	$boxSerial = "";
	foreach ($dom->getElementsByTagNameNS($j, "Serial") as $node)
	{
		$boxSerial = $node->textContent;
		$i++;
	}

	if (strcasecmp($boxSerial,$fbSerial) == 0)
	{
		$result = true;
	}
	return $result;
}

// Create UUID as an unique key for invitations/cancelations
function create_GUID()
{
	return sprintf('%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}

// Connect to MariaDB database system
function db_connect()
{
	global $database, $dbUser, $dbPwd;
	try
	{
		$conn = new PDO("mysql:host=localhost;dbname=".$database, $dbUser, $dbPwd);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	}
	catch(PDOException $err)
	{
		print "ERROR: Unable to connect: " . $err->getMessage();
		$conn = null;
	}
	return $conn;
}

//Disconnect from database system
function db_disconnect($conn)
{
	$conn = null;
}

// Read language specific locales from DB
function db_ReadLanguage($lang)
{
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT * FROM tLanguages WHERE pkid = :lang ;";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":lang", $lang, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return[0];
}

// Get UserName (the eMail Address) from DB by primary key
function db_GetUserNameById($pkid)
{
	$dType = gettype($pkid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($pkid);
	} else
	{
		$iPkid = $pkid;
	}
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT emailAddress FROM vw_Users WHERE pkid = :pkid ;";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return[0]["emailAddress"];
}

// Read language specific text element by language pkid and element label
function db_ReadTextObject($lang,$label)
{
	$connection = db_connect();
	$label = strtolower($label);
	if ($connection != null)
	{
		$sql = "SELECT text FROM tTextObjects WHERE fk_lang = :lang AND LOWER(label) = :label;";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":lang", $lang, PDO::PARAM_INT);
			$result->bindParam(":label", $label, PDO::PARAM_STR);
			$result->execute();
		}
		catch(PDOException $err)
		{
   		print "ERROR: Unable to read data: " . $err->getMessage();
   		$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return[0]["text"];
}

// Read Court information by language pkid
function db_ReadCourts($lang)
{
	$connection = db_connect();
	$show = true;
	if ($connection != null)
	{
		$sql = "SELECT pkid,displayName,bActive FROM vw_Courts WHERE bDisplay = :show AND fk_lang = :lang ORDER BY pkid;";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":show", $show, PDO::PARAM_BOOL);
			$result->bindParam(":lang", $lang, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
   		print "ERROR: Unable to read data: " . $err->getMessage();
   		$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return;
}

function db_ReadAllowedUsers()
{
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT * FROM vw_Users WHERE fk_utype > 1 ORDER BY lastName,firstName;";
		try
		{
			$result = $connection->prepare($sql);
			$result->execute();
		}
		catch(PDOException $err)
		{
   		print "ERROR: Unable to read data: " . $err->getMessage();
   		$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return;
}

function db_GetReservationInfo($pkid,$lang)
{
	$retVal = null;
	$dType = gettype($pkid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($pkid);
	} else
	{
		$iPkid = $pkid;
	}

	$dType = gettype($lang);
	if (strtolower($dType) != "integer")
	{
		$iLang = intval($lang);
	} else
	{
		$iLang = $lang;
	}
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT
					t1.uuid
					,t1.fk_court
					,t1.schedule
					,t1.hour
					,t1.duration
					,c1L.text as court
					,CONCAT(p1.emailAddress, ',', p2.emailAddress, ',', IFNULL(p3.emailAddress,''), ',', IFNULL(p4.emailAddress,'')) AS emailAddresses
					,CONCAT(p1.displayName, ',', p2.displayName, ',', IFNULL(p3.displayName,''), ',', IFNULL(p4.displayName,'')) AS displayNames
				FROM
					tReservations t1
					LEFT JOIN tActiveUsers p1 ON t1.fk_requester = p1.pkid
					LEFT JOIN tActiveUsers p2 ON t1.fk_player2 = p2.pkid
					LEFT JOIN tActiveUsers p3 ON t1.fk_player3 = p3.pkid
					LEFT JOIN tActiveUsers p4 ON t1.fk_player4 = p4.pkid
					LEFT JOIN tCourts c1 ON t1.fk_court = c1.pkid
					LEFT JOIN tCourts_L c1L ON t1.fk_court = c1L.fk_court
				WHERE
					t1.pkid = :pkid
					AND c1L.fk_lang = :lang;";

		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":lang", $iLang, PDO::PARAM_INT);
			$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
		$retVal = $return[0];
	}
	return $retVal;
}

function db_ReadReservations()
{
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT pkid,fk_court,fk_requester,schedule,hour,duration,fk_player2,fk_player3,fk_player4 FROM `tReservations  WHERE status > 0 AND schedule >= CURDATE() ORDER BY schedule,hour;";
		try
		{
			$result = $connection->prepare($sql);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	return $return;
}

function db_CheckReservation($schedule,$hour,$court,$userid)
{
	if (isset($userid))
	{
		$dType = gettype($userid);
		if (strtolower($dType) != "integer")
		{
			$iPkid = intval($userid);
		} else
		{
			$iPkid = $userid;
		}
	} else
	{
		$iPkid = 0;
	}
	$retVal = null;
	$connection = db_connect();
	if ($connection != null)
	{
		$sqlOld = "
					SELECT
						pkid
						,fk_requester AS userid
						,status
						,CASE WHEN (fk_requester = :param4 OR fk_player2 = :param4 OR fk_player3 = :param4 OR fk_player4 = :param4) THEN 1 ELSE 0 END AS myBooking
					FROM
						tReservations
					WHERE
						status > 0 AND schedule = :param1 AND hour = :param2 AND fk_court = :param3;
			";
		$sql = "
				SELECT
					t1.pkid
					,t1.fk_requester AS userid
					,t1.status
					,CASE WHEN (t1.fk_requester = :param4 OR t1.fk_player2 = :param4 OR t1.fk_player3 = :param4 OR t1.fk_player4 = :param4) THEN 1 ELSE 0 END AS myBooking
					,CONCAT(p1.displayName,IFNULL(CONCAT(';',p2.displayName),''),IFNULL(CONCAT(';',p3.displayName),''),IFNULL(CONCAT(';',p4.displayName),'')) AS strPlayers
				FROM
					tReservations t1
					LEFT JOIN tActiveUsers p1 ON t1.fk_requester = p1.pkid
					LEFT JOIN tActiveUsers p2 ON t1.fk_player2 = p2.pkid
					LEFT JOIN tActiveUsers p3 ON t1.fk_player3 = p3.pkid
					LEFT JOIN tActiveUsers p4 ON t1.fk_player4 = p4.pkid
				WHERE
					t1.status > 0 AND t1.schedule = :param1 AND t1.hour = :param2 AND t1.fk_court = :param3;
			";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":param1", $schedule, PDO::PARAM_STR,10);
			$result->bindParam(":param2", $hour, PDO::PARAM_INT);
			$result->bindParam(":param3", $court, PDO::PARAM_INT);
			$result->bindParam(":param4", $iPkid, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = 0;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
		$retVal = $return[0];
	} else
	{
		$retVal = 0;
	}
	return $retVal;
}

function db_GetUserData($username)
{
	$connection = db_connect();
	$param1 = strtoupper($username);
	if ($connection != null)
	{
		$sql = "SELECT * FROM vw_Users WHERE UPPER(emailAddress) = :param1;";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":param1", $param1, PDO::PARAM_STR,50);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	$cnt = count($return);
	if ($cnt == 1)
	{
		return $return[0];
	} else
	{
		return null;
	}
}

function db_GetUserInfo($pkid)
{
	$dType = gettype($pkid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($pkid);
	} else
	{
		$iPkid = $pkid;
	}
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "	SELECT displayName, emailAddress FROM vw_Users WHERE pkid = :pkid;";

		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	$cnt = count($return);
	if ($cnt == 1)
	{
		return $return[0];
	} else
	{
		return null;
	}
}

function db_GetReservationDetails($pkid)
{
	$dType = gettype($pkid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($pkid);
	} else
	{
		$iPkid = $pkid;
	}
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT * FROM tReservations t1 WHERE t1.pkid = :pkid;";

		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	$cnt = count($return);
	if ($cnt == 1)
	{
		return $return[0];
	} else
	{
		return null;
	}
}

function db_GetCourtInfo($pkid,$lang)
{
	$dType = gettype($pkid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($pkid);
	} else
	{
		$iPkid = $pkid;
	}

	$dType = gettype($lang);
	if (strtolower($dType) != "integer")
	{
		$iLang = intval($lang);
	} else
	{
		$iLang = $lang;
	}

	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "SELECT displayName FROM vw_Courts WHERE pkid = :pkid and fk_lang = :lang;";

		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
			$result->bindParam(":lang", $iLang, PDO::PARAM_INT);
			$result->execute();
		}
		catch(PDOException $err)
		{
			print "ERROR: Unable to read data: " . $err->getMessage();
			$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	$cnt = count($return);
	if ($cnt == 1)
	{
		return $return[0]["displayName"];
	} else
	{
		return null;
	}
}

function db_GetReservationUsage($pkid,$bDate)
{
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "
						SELECT
						(
							SELECT
								COUNT(*)
							FROM
								tReservations
							WHERE
							(
								fk_requester = :param1
								OR fk_player2 = :param1
								OR fk_player3 = :param1
								OR fk_player4 = :param1
							)
							AND WEEK(schedule,1) = WEEK(:param2,1)
							AND status > 0
						) AS perWeek
						,(
							SELECT
								COUNT(*)
							FROM
								tReservations
							WHERE
							(
								fk_requester = :param1
								OR fk_player2 = :param1
								OR fk_player3 = :param1
								OR fk_player4 = :param1
							)
							AND WEEK(schedule,1) = WEEK(:param2,1)
							AND DAYOFWEEK(schedule) = DAYOFWEEK(:param2)
							AND status > 0
						) AS perDay";
		try
		{
			$result = $connection->prepare($sql);
			$result->bindParam(":param1", $pkid, PDO::PARAM_INT);
			$result->bindParam(":param2", $bDate, PDO::PARAM_STR,10);
			$result->execute();
		}
		catch(PDOException $err)
		{
   		print "ERROR: Unable to read data: " . $err->getMessage();
   		$return = null;
		}
		$return = $result->fetchAll(\PDO::FETCH_ASSOC);
		db_disconnect($connection);
	} else
	{
		$return = null;
	}
	$cnt = count($return);
	if ($cnt == 1)
	{
		return $return[0];
	} else
	{
		return null;
	}
}

function db_ReserveCourt($jsData,$bCheckInMethod,$GUID)
{
	$retVal = false;
	$connection = db_connect();
	if ($connection != null)
	{
		$iMaxSec = $jsData->CheckInMinutes * 60;
		$iNow = (new DateTime('NOW'))->format('U');
		$iDiffSec = ($jsData->unixts - $iNow);
		$sql = "
			INSERT INTO tReservations (uuid,fk_court,fk_requester,schedule,hour,duration,status,fk_player2,fk_player3,fk_player4)
		 	VALUES (:uuid, :court, :requester, :schedule, :hour, :duration, :status, :player2, :player3, :player4);
		 ";
		$result = $connection->prepare($sql);

		if (!$bCheckInMethod)
		{
			$status = 10;
		} else
		{
			if (($jsData->localConnected) && ($iDiffSec <= $iMaxSec))
			{
				$status = 10;
			} else
			{
				$status = 5;
			}
		}
		$dbnull = 0;
		$result->bindParam(":uuid", $GUID, PDO::PARAM_STR, 50);
		$iCourtNr = intval($jsData->rCourt);
		$result->bindParam(":court", $iCourtNr, PDO::PARAM_INT);
		$iRequester = intval($jsData->userid);
		$result->bindParam(":requester", $iRequester, PDO::PARAM_INT);
		$strDate = $jsData->rDate;
		$result->bindParam(":schedule", $strDate, PDO::PARAM_STR, 10);
		$iHour = intval($jsData->rHour);
		$result->bindParam(":hour", $iHour, PDO::PARAM_INT);
		$iDuration = intval($jsData->duration);
		$result->bindParam(":duration", $iDuration, PDO::PARAM_INT);
		$result->bindParam(":status", $status, PDO::PARAM_INT);
		$iPlayer2 = intval($jsData->aMembers[0]);
		$result->bindParam(":player2", $iPlayer2, PDO::PARAM_INT);
		if (count($jsData->aMembers) > 1)
		{
			$iPlayer3 = intval($jsData->aMembers[1]);
			$result->bindParam(":player3", $iPlayer3, PDO::PARAM_INT);
		} else
		{
			$result->bindParam(":player3", $dbnull, PDO::PARAM_NULL);
		}
		if (count($jsData->aMembers) > 2)
		{
			$iPlayer4 = intval($jsData->aMembers[2]);
			$result->bindParam(":player4", $iPlayer4, PDO::PARAM_INT);
		} else
		{
			$result->bindParam(":player4", $dbnull, PDO::PARAM_NULL);
		}

		$result->execute();
		$retVal = true;
	}
	return $retVal;
}

function db_UpdateUserPw($userid,$pword)
{
	$dType = gettype($userid);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($userid);
	} else
	{
		$iPkid = $userid;
	}

	$retVal = false;
	$pwd_hashed = password_hash($pword, PASSWORD_DEFAULT);
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "UPDATE tActiveUsers SET timestamp = current_timestamp(), pwhash = :pword WHERE pkid = :pkid";

		$result = $connection->prepare($sql);
		$result->bindParam(":pword", $pwd_hashed, PDO::PARAM_STR,100);
		$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
		$result->execute();
		$retVal = true;
	}
	return $retVal;
}

function db_UpdateBooking($iMethod,$iReservationID)
{
	$dType = gettype($iReservationID);
	if (strtolower($dType) != "integer")
	{
		$iPkid = intval($iReservationID);
	} else
	{
		$iPkid = $iReservationID;
	}

	$dType = gettype($iMethod);
	if (strtolower($dType) != "integer")
	{
		$iDBMethod = intval($iMethod);
	} else
	{
		$iDBMethod = $iMethod;
	}
	if ($iDBMethod == 0)
	{
		$status = 0;
	} else
	{
		$status = 10;
	}

	$retVal = false;
	$connection = db_connect();
	if ($connection != null)
	{
		$sql = "UPDATE tReservations SET timestamp = current_timestamp(), status = :status WHERE pkid = :pkid";

		$result = $connection->prepare($sql);
		$result->bindParam(":status", $status, PDO::PARAM_INT);
		$result->bindParam(":pkid", $iPkid, PDO::PARAM_INT);
		$result->execute();
		$retVal = true;
	}
	return $retVal;
}

function send_Invitation($jsData,$lang,$GUID)
{
	global $smtpServer;
	global $eMailName;
	global $eMailUser;
	global $eMailPw;
	global $strLocation;
	global $strSummary;
	global $intSmtpPort;
	global $strBaseUrl;

	$retVal = false;
	$location = $strLocation;
	$description = $strSummary;
	$summary = $strSummary;

	$aPlayers = array();
	$objPlayer = new stdClass();
	$objPlayer->pkid = intval($jsData->userid);
	$result = db_GetUserInfo($objPlayer->pkid);
	$objPlayer->email = $result["emailAddress"];
	$objPlayer->displayname = $result["displayName"];
	array_push($aPlayers, $objPlayer);

	$strDomain = substr($eMailUser,strpos($eMailUser,"@"));

	$schHourEnd = intval($jsData->rHour) + intval($jsData->duration);
	$reservedCourt = intval($jsData->rCourt);

	$location .= " " . db_GetCourtInfo($reservedCourt,$lang);
	foreach ($jsData->aMembers as $player)
	{
		$objPlayer = new stdClass();
		$objPlayer->pkid = intval($player);
		$result = db_GetUserInfo($objPlayer->pkid);
		$objPlayer->email = $result["emailAddress"];
		$objPlayer->displayname = $result["displayName"];
		array_push($aPlayers, $objPlayer);
	}
	$startDate = DateTime::createFromFormat("Y-m-d H:i:s", $jsData->rDate. " " . $jsData->rHour . ":00:00");
	$strSchedule = $startDate->format("d.m.Y H:i") . " Uhr";
	$summary .= " (" . $strSchedule . ")";
	$endDate = DateTime::createFromFormat("Y-m-d H:i:s", $jsData->rDate. " " . strval($schHourEnd) . ":00:00");
	$emailDate = new DateTime('NOW');

	$gmStartDate = gmdate("Ymd\THis\Z",$startDate->format('U'));
	$gmEndDate = gmdate("Ymd\THis\Z",$endDate->format('U'));
	$gmEMailDate = gmdate("Ymd\THis\Z",$emailDate->format('U'));

	$idx = 0;
	$description .= " (" . $location . ")";
	foreach ($aPlayers as $playerObj)
	{
		if ($idx > 0)
		{
			$description .= ", " . $playerObj->displayname;
		} else
		{
			$description .= ": " . $playerObj->displayname;
		}
		$idx++;
	}

	$ical_content = ('BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//' . $strBaseUrl . '
METHOD:PUBLISH
BEGIN:VEVENT
UID:' . $GUID . $strDomain . '
SEQUENCE:0
DTSTAMP:' . $gmEMailDate . '
DTSTART:' . $gmStartDate . '
DTEND:' . $gmEndDate . '
SUMMARY:' . $summary . '
LOCATION;CHARSET=UTF-8:' . $location . '
DESCRIPTION;CHARSET=UTF-8:' . $description . '
ORGANIZER;CN="' . $eMailName .'":mailto:' . $eMailUser . '
END:VEVENT
END:VCALENDAR');

	foreach ($aPlayers as $currPlayer)
	{
		$mail = new PHPMailer(true);
		try
		{
			//Server settings
			$mail->isSMTP();
			$mail->Host		= $smtpServer;
			$mail->SMTPAuth		= true;
			$mail->Username		= $eMailUser;
			$mail->Password		= $eMailPw;
			$mail->SMTPSecure	= PHPMailer::ENCRYPTION_STARTTLS;
			$mail->Port		= $intSmtpPort;

			$mail->setFrom($mail->Username, $eMailName);
			$mail->addAddress($currPlayer->email, $currPlayer->displayname);

			$mail->isHTML(true);
			$mail->Subject = utf8_decode($summary);
			$mail->Body    = utf8_decode($description);
			$mail->AltBody = utf8_decode($description);

			if(!empty($ical_content))
			{
				$mail->addStringAttachment($ical_content,"reservierung.ics","base64","text/calendar");
			}

			$mail->send();
			$retVal = true;
		} catch (Exception $e)
		{
			$retVal = false;
		}
	}
	return $retVal;
}

function send_Cancelation($bData,$lang)
{
	global $smtpServer;
	global $eMailName;
	global $eMailUser;
	global $eMailPw;
	global $strLocation;
	global $strSummary;
	global $intSmtpPort;
	global $strBaseUrl;

	$retVal = false;
	$location = $strLocation;
	$description = $strSummary;
	$summary = db_ReadTextObject($lang,"Cancelled") . ": " . $strSummary;


	$schHourEnd = intval($bData["hour"]) + intval($bData["duration"]);

	$location .= " " . $bData["court"];

	$eMails = explode (",",$bData["emailAddresses"]);
	$names = explode (",",$bData["displayNames"]);

	$idx = 0;
	$description .= " (" . $location . ")";
	foreach ($names as $player)
	{
		if (strlen($player) > 1)
		{
			if ($idx > 0)
			{
				$description .= ", " . $player;
			} else
			{
				$description .= ": " . $player;
			}
		}
		$idx++;
	}

	$strDomain = substr($eMailUser,strpos($eMailUser,"@"));

	$startDate = DateTime::createFromFormat("Y-m-d H:i:s", $bData["schedule"]. " " . $bData["hour"] . ":00:00");
	$strSchedule = $startDate->format("d.m.Y H:i") . " Uhr";
	$summary .= " (" . $strSchedule . ")";

	$endDate = DateTime::createFromFormat("Y-m-d H:i:s", $bData["schedule"] . " " . strval($schHourEnd) . ":00:00");
	$emailDate = new DateTime('NOW');

	$gmStartDate = gmdate("Ymd\THis\Z",$startDate->format('U'));
	$gmEndDate = gmdate("Ymd\THis\Z",$endDate->format('U'));
	$gmEMailDate = gmdate("Ymd\THis\Z",$emailDate->format('U'));

	$ical_content = ('BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//' . $strBaseUrl . '
METHOD:CANCEL
BEGIN:VEVENT
STATUS:CANCELLED
UID:' . $bData["uuid"] . $strDomain . '
SEQUENCE:1
DTSTAMP:' . $gmEMailDate . '
DTSTART:' . $gmStartDate . '
DTEND:' . $gmEndDate . '
SUMMARY:' . $summary . '
LOCATION;CHARSET=UTF-8:' . $location . '
DESCRIPTION;CHARSET=UTF-8:' . $description . '
ORGANIZER;CN="' . $eMailName . '":mailto:' . $eMailUser . '
END:VEVENT
END:VCALENDAR');

	$idx = 0;
	foreach ($eMails as $emailAddress)
	{
		$mail = new PHPMailer(true);
		try
		{
			//Server settings
			$mail->isSMTP();
			$mail->Host		= $smtpServer;
			$mail->SMTPAuth		= true;
			$mail->Username		= $eMailUser;
			$mail->Password		= $eMailPw;
			$mail->SMTPSecure	= PHPMailer::ENCRYPTION_STARTTLS;
			$mail->Port		= $intSmtpPort;

			$mail->setFrom($mail->Username, $eMailName);
			$mail->addAddress($emailAddress, $names[$idx]);

			$mail->isHTML(true);
			$mail->Subject = utf8_decode($summary);
			$mail->Body    = utf8_decode($description);
			$mail->AltBody = utf8_decode($description);

			if(!empty($ical_content))
			{
				$mail->addStringAttachment($ical_content,"stornierung.ics","base64","text/calendar");
			}

			$mail->send();
			$retVal = true;
		} catch (Exception $e)
		{
			$retVal = false;
		}
		$idx++;
	}
	return $retVal;
}

function randomPassword()
{
    $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890#$%&!?';
    $pass = array();
    $alphaLength = strlen($alphabet) - 1;
    for ($i = 0; $i < 12; $i++)
    {
        $n = rand(0, $alphaLength);
        $pass[] = $alphabet[$n];
    }
    return implode($pass);
}

function createNewPassword($user,$lang)
{
	global $smtpServer;
	global $eMailName;
	global $eMailUser;
	global $eMailPw;
	global $clubName;

	$strKennwort = randomPassword();
	$bSuccess = db_UpdateUserPw($user->data['pkid'],$strKennwort);
	if ($bSuccess)
	{
		$bSuccess  = false;
		$mail = new PHPMailer(true);
		try
		{
			//Server settings
			$mail->isSMTP();
			$mail->Host			= $smtpServer;
			$mail->SMTPAuth		= true;
			$mail->Username		= $eMailUser;
			$mail->Password		= $eMailPw;
			$mail->SMTPSecure	= PHPMailer::ENCRYPTION_STARTTLS;
			$mail->Port			= 587;

			$mail->setFrom($mail->Username, $eMailName);
			$mail->addAddress($user->user, $user->data["displayName"]);
			$mail->isHTML(true);
			$mail->Subject = $clubName . " " .  db_ReadTextObject($lang,"PWChangeSubject"); 

			$mail->Body    = db_ReadTextObject($lang,"YourPassword") . ": " . $strKennwort;
			$mail->AltBody    = db_ReadTextObject($lang,"YourPassword") . ": " . $strKennwort;

			$mail->send();
			$bSuccess  = true;
		} catch (Exception $e)
		{
			$bSuccess  = false;
		}
	}
	return $bSuccess;
}

?>
