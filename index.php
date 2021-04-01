<?xml version="1.0" encoding="iso-8859-1"?>
<?php
	ob_start();
	session_start();
	ini_set("session.cookie_httponly", 1);

	include_once("./inc/config.php");
	include_once("./inc/functions.php");
	include_once("./inc/account.php");

	$NewPwHint = "&nbsp;";
	$iMaxBookingsDuration = 1;

	$bLocalConnected = checkLocal();
	if ($bLocalConnected)
	{
		$iInAdvanceRequired = 0;
	}

	$iDefaultScreen = 0;

	$lang = ((isset($_GET['lang'])) ? ($_GET['lang']) : 1);

	$lgConf = db_ReadLanguage($lang);
	setlocale (LC_ALL, $lgConf["label"]);
	$strClockTime = db_ReadTextObject($lang,"strTime");
	$strLocation =  html_entity_decode(db_ReadTextObject($lang,"strLocation"));
	$strSummary =  html_entity_decode(db_ReadTextObject($lang,"strSummary"));
	$eMailName =  html_entity_decode(db_ReadTextObject($lang,"eMailName"));

	$user = new Account;
	$bLoggedIn = $user->hasSession();

	$jsData = json_decode($_POST['tabjsonData']);
	if ($jsData->loggedIn)
	{
		if ($jsData->step == 1)
		{
			$username = db_GetUserNameById($jsData->userid);
			$bLimitReached = false;
			foreach ($jsData->aMembers as $otherPlayer)
			{
				$playerUsage = db_GetReservationUsage(intval($otherPlayer),$jsData->rDate);
				if (($playerUsage['perDay'] >= $iMaxBookingsPerDay) || ($playerUsage['perWeek'] >= $iMaxBookingsPerWeek))
				{
					$bLimitReached = true;
					$iDefaultScreen = 1;
					break;
				}
			}
			if (!$bLimitReached)
			{
				$strGuid = create_GUID();
				$bResult = db_ReserveCourt($jsData,$bCheckInMethod,$strGuid);
				$bResult = send_Invitation($jsData,$lang,$strGuid);
			}
		}
	} elseif (isset($_POST["username"]))
	{
		$username = $_POST["username"];
	} else
	{
		$username = $user->user;
	}

	$rDate = ((isset($_GET['rDate'])) ? ($_GET['rDate']) : (null));
	$rHour = ((isset($_GET['rHour'])) ? ($_GET['rHour']) : (null));
	$rCourt = ((isset($_GET['rCourt'])) ? ($_GET['rCourt']) : (null));
	$rMethod = ((isset($_GET['rMethod'])) ? ($_GET['rMethod']) : (null));;

	if ($bLoggedIn)
	{
		$user->loadData($username);
		if (isset($_GET['logout']))
		{
			session_destroy();
			$bLoggedIn = false;
			header("Location: ./");
		}
		if (!$user->isLoggedIn())
		{
			session_destroy();
			$bLoggedIn = false;
		}
	} else if (isset($_POST['username']))
	{
		$user->loadData($_POST['username']);
		if (isset($user->user))
		{
			if (isset($_POST["resetPW"]))
			{
				$bResult = createNewPassword($user,$lang);
				if ($bResult)
				{
					$iDefaultScreen = 3;
					$NewPwHint = db_ReadTextObject($lang,"PWCreated");
				}
			} elseif (isset($_POST['password']))
			{
				if ($user->auth($_POST['password']))
				{
					$user->startSession();
					$bLoggedIn = true;
					$user->doLogin();
				} else
				{
					$iDefaultScreen = 3;
					$NewPwHint = db_ReadTextObject($lang,"UnknownUser");
				}
			} 
		} else
		{
			$iDefaultScreen = 3;
			$NewPwHint = db_ReadTextObject($lang,"UnknownUser");
		}
	}

	$aMembers = array();
	$aCourts = db_ReadCourts($lang);
	$iCourts = count($aCourts);

	if ($iCourts > 0)
	{
		$strinitial = str_replace(" ","", $aCourts[0]["displayName"]);
	}
	$now = date("d.m.Y");
	$currentHour = intval(date("G"));
	$id = $_GET['id'];
	if (!$id)
		$id = 1;

	if ($bLoggedIn)
	{
		$allUsers = db_ReadAllowedUsers();
		$jsUsers = json_encode($allUsers, JSON_HEX_TAG | JSON_HEX_AMP);

		if ((isset($_POST["npw1"])) && (isset($_POST["npw2"])))
		{
			if (strcmp($_POST["npw1"],$_POST["npw2"]) == 0)
			{
				$bDBresult = db_UpdateUserPw($user->data['pkid'],$_POST["npw1"]);
			} else
			{
				$NewPwHint = db_ReadTextObject($lang,"NotMatch");
				$iDefaultScreen = 2;
			}
		}

		if ((isset($_POST["reservationid"])) && (isset($_POST["manageMethodid"])))
		{
			$iMethod = $_POST["manageMethodid"];
			$bDBresult = db_UpdateBooking($_POST["manageMethodid"],$_POST["reservationid"]);
			if ($_POST["manageMethodid"] == "0")
			{
				// Send Cancel event
				$bookData = db_GetReservationInfo($_POST["reservationid"],$lang);
				$bResult = send_Cancelation($bookData,$lang);
			}
		}
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
	<head>
	<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
	<meta name="author" content="Jens Kollbach" />
	<meta name="publisher" content="Tennisclube L&ouml;rzweiler" />
	<meta name="copyright" content="Tennisclub L&ouml;rzweiler" />
	<meta name="description" content="Tennisclub Platzreservierung" />
	<meta name="keywords" content="Tennisclub Platzreservierung" />
	<meta name="page-topic" content="Sport" />
	<meta name="page-type" content="Sport Tool" />
	<meta name="audience" content="Alle" />
	<meta name="robots" content="index, follow" />
	<meta name="DC.Creator" content="Jens Kollbach" />
	<meta name="DC.Publisher" content="Tennisclub L&ouml;rzweilerr" />
	<meta name="DC.Rights" content="Tennisclub L&ouml;rzweiler" />
	<meta name="DC.Description" content="Tennisclub Platzreservierung" />
	<meta name="DC.Language" content="de" />
	<link rel="apple-touch-icon" sizes="57x57" href="./icons/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="./icons/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="./icons/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="./icons/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="./icons/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="./icons/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="./icons/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="./icons/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="./icons/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192" href="./icons/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="./icons/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="./icons/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="./icons/favicon-16x16.png">
	<link rel="manifest" href="./icons/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="./icon/ms-icon-144x144.png">
	<meta name="theme-color" content="#ffffff">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<script src="./js/functions.js" type="text/javascript"></script>
	<link href="./css/select2.min.css" rel="stylesheet" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="./js/select2.min.js"></script>
	<link rel="stylesheet" href="./css/style_screen.css" />
	<title>Tennisclub L&ouml;rzweiler Platzreservierung</title>
	</head>
	<body onload="updateClock(); setInterval('updateClock()', 1000);openTab(event, '<?php print $strinitial; ?>');showScreen(<?php print strval($iDefaultScreen); ?>)">
	<div class="pageContainer">
		<div class="img-header"></div>
		<div class="wappen">
			<ul>
				<li>
					<img src="./img/TCLlogo120x120.png" alt="" title="" />
				</li>
			</ul>
		</div>
		<div class="menuHoriz">
			<ul>
				<li>
<?php
if ($bLoggedIn)
{
	print "\t\t\t\t<li>\n";
	print "\t\t\t\t\t<button onclick=\"userLogout();\">" . db_ReadTextObject($lang,"logout") . "</button>\n";
	print "\t\t\t\t</li>\n";
	print "\t\t\t\t<li>";
	print "\t\t\t\t\t<button onclick=\"openPWTab();\">" . db_ReadTextObject($lang,"ChangePW") . "</button>\n";
	print "\t\t\t\t</li>\n";
} else
{
	print "\t\t\t\t<li>\n";
	print "\t\t\t\t\t<button onclick=\"document.getElementById('idLgnForm').style.display='block'\">" . db_ReadTextObject($lang,"login") . "</button>\n";
	print "\t\t\t\t</li>\n";
}
?>
					<span class="loggedInUser">
<?php 
if ($bLoggedIn)
{
	print $user->data["displayName"] . "\n";
} else
{
	print "&nbsp;";
}
?>
					</span>
				</li>
				<li class="cClock">
					<span id="clock">&nbsp;</span>
					<span>
					<?php
						if ($lang != 2)
						{
							print strftime('%A').', '.date('d.m.Y').'  ';
						} else
						{
							print strftime('%A').', '.date('m/d/Y').'  ';
						}
					?>
					</span>
				</li>
			</ul>
		</div>
		<div class="buffer"></div>
		<div id="idLgnForm" class="classLogon">
			<form action="./" method="post" class="loginForm">
				<div class="imgcontainer">
					<span onclick="document.getElementById('idLgnForm').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
					<img src="./img/player.png" alt="Player">
				</div>
				<div class="container">
					<label for="uname"><b><?php print db_ReadTextObject($lang,"email"); ?></b></label>
					<input type="text" placeholder="<?php print db_ReadTextObject($lang,"AskForEmail"); ?>" name="username" required>
					<label for="psw"><b><?php print db_ReadTextObject($lang,"password"); ?></b></label>
					<input type="password" placeholder="<?php print db_ReadTextObject($lang,"AskForPassword"); ?>" name="password" id="idPassword" required>
					<br /><br />
					<table style="width: 100%">
						<tr>
							<td style="width: 50%">
								<span><?php print $NewPwHint; ?></span>
							</td>
							<td style="width: 50%; text-align: right">
								<label for="resetPW"><?php print db_ReadTextObject($lang,"ResetPW"); ?></label>
								<input type="checkbox" id="resetPW" name="resetPW" onchange="changePWField()">
							</td>
						</tr>
					</table>
					<br /><br />
					<button class="lgnButton" type="submit"><?php print db_ReadTextObject($lang,"login"); ?></button>
				</div>
			</form>
		</div>
		<div id="changePw" class="classLogon">
			<form action="./" method="post" class="loginForm" id="pwChangeForm">
				<div class="imgcontainer">
					<span onclick="document.getElementById('changePw').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
					<img src="./img/player.png" alt="Player">
				</div>
				<div class="container">
					<label for="npw1"><b><?php print db_ReadTextObject($lang,"NewPW"); ?></b></label>
					<input type="password" name="npw1" id="npw1" required>
					<label for="npw2"><b><?php print db_ReadTextObject($lang,"ConfPW"); ?></b></label>
					<input type="password" name="npw2" id="npw2" required>
					<label for="strength"><b><?php print db_ReadTextObject($lang,"PWStrength"); ?></b></label>
					<progress id="strength" name="strength" value="0" max="5"></progress><br /><br />
					<span><?php print $NewPwHint; ?></span><br /><br />
					<input type="hidden" name="username" value="<?php print $user->user;?>" />
					<button class="lgnButton" type="submit"><?php print db_ReadTextObject($lang,"Continue"); ?></button>
					<script>
						let pwInput = document.getElementById("npw1");
						pwInput.addEventListener('keyup', function()
						{
							document.getElementById("strength").value = passwordStrength(pwInput.value);
						})
					</script>
				</div>
			</form>
		</div>
		<div id="idWarningForm" class="classPlayers">
			<div class="imgcontainer">
				<span onclick="document.getElementById('idWarningForm').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
			</div>
			<div class="container">
				<span class="warnHead">
					<?php print db_ReadTextObject($lang,"Attention") . "!"; ?>
				</span>
				<br /><br />
				<span class="warnMessage">
					<?php print db_ReadTextObject($lang,"NoBookMessage"); ?>
					<br /><br /><br />
					<table>
						<tr>
							<td>
								<?php print db_ReadTextObject($lang,"perDay"); ?>
							</td>
							<td>&nbsp;&#8594;&nbsp;</td>
							<td>
								<?php print strval($iMaxBookingsPerDay); ?>
							</td>
						</tr>
						<tr>
							<td>
								<?php print db_ReadTextObject($lang,"perWeek"); ?>:
							</td>
							<td>&nbsp;&#8594;&nbsp;</td>
							<td>
								<?php print strval($iMaxBookingsPerWeek); ?>
							</td>
						</tr>
					</table>
				</span>
			</div>
		</div>
		<div id="idNotActiveForm" class="classPlayers">
			<div class="imgcontainer">
				<span onclick="document.getElementById('idNotActiveForm').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
			</div>
			<div class="container">
				<span class="warnHead">
					<?php print db_ReadTextObject($lang,"Attention") . "!"; ?>
				</span>
				<br /><br />
				<span class="warnMessage">
					<?php print db_ReadTextObject($lang,"NotActiveCourt"); ?>
					<br /><br /><br />
				</span>
			</div>
		</div>
		<div id="idPlayerManage" class="classPlayers">
			<form action="./" method="post" class="playerForm" id="idManageForm">
				<div class="imgcontainer">
					<span onclick="document.getElementById('idPlayerManage').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
				</div>
				<div class="container">
					<span class="schedInfo" id="TMyCourt">&nbsp;</span>
					<span class="schedInfo" id="TMySchedule">&nbsp;</span>
					<span class="schedInfo" id="TMyTime">&nbsp;</span>
					<br />
					<span class="schedInfo" id="TMyPlayers">&nbsp;</span>
					<br />
					<span class="manButtons">
						<button class="btManageBookingConfirm" id="idConfirmBooking" onclick="manageCourt(1)"><?php print db_ReadTextObject($lang,"ConfBook"); ?></button>
						<button class="btManageBookingCancel" id="idCancelBooking" onclick="manageCourt(0)"><?php print db_ReadTextObject($lang,"CancBook"); ?></button>
					</span>
					<input type="hidden" name="reservationid" id="reservationid" value="" />
					<input type="hidden" name="manageMethodid" id="manageMethodid" value="" />
				</div>
			</form>
		</div>
		<div id="idPlayerForm" class="classPlayers">
			<form action="./" method="post" class="playerForm" id="idPlayerForm">
				<div class="imgcontainer">
					<span onclick="document.getElementById('idPlayerForm').style.display='none'" class="close" title="<?php print db_ReadTextObject($lang,"Close"); ?>">&times;</span>
				</div>
				<div class="container">
					<table class="playerTab">
							<tr>
								<td class="playerTabLeft">
									<label for="player2"><b><?php print db_ReadTextObject($lang,"Player"); ?> 1</b></label>
								</td>
								<td class="playerTabRight">
<?php
									print "\t\t\t\t<select name='player2' id='selPlayer2' size='1' class='playerSelect' onchange='updateSelPlayer3(" . $jsUsers . ",\"" . db_ReadTextObject($lang,"AskSelect") . "\"," . strval($user->data['pkid']) . ")' required>\n";
?>

										<option value=""><?php print db_ReadTextObject($lang,"AskSelect"); ?></option>
<?php
	foreach($allUsers as $user1)
	{
		if ($user1["pkid"] != $user->data['pkid'])
		{
			print "\t\t\t\t\t\t\t\t\t<option value=\"" . strval($user1["pkid"]) . "\">" . $user1["lastName"] .", " . $user1["firstName"]. "</option>\n";
		}
	}
?>
    							</select>
									</div>
    						</td>
    					</tr>
    <!-- if weiterer Spieler -->
<?php 
							if (!$bDenyDoubles)
							{
?>
							<tr>
								<td class="playerTabLeft">
									<label for="player3"><b><?php print db_ReadTextObject($lang,"Player"); ?> 2</b></label>
								</td>
								<td class="playerTabRight">
<?php
									print "\t\t\t\t<select name='player3' id='selPlayer3' size='1' class='playerSelect' onchange='updateSelPlayer4(" . $jsUsers . ",\"" . db_ReadTextObject($lang,"AskSelect") . "\"," . strval($user->data['pkid']) . ")'>\n";
?>
										<option value="0"><?php print db_ReadTextObject($lang,"AskSelect"); ?></option>
    							</select>
    						</td>
    					</tr>
    <!-- if weiterer Spieler -->
							<tr>
								<td class="playerTabLeft">
									<label for="player43"><b><?php print db_ReadTextObject($lang,"Player"); ?> 3</b></label>
								</td>
								<td class="playerTabRight">
									<select name="player4" size="1" id='selPlayer4' class="playerSelect">
										<option value="0"><?php print db_ReadTextObject($lang,"AskSelect"); ?></option>
    							</select>
    						</td>
    					</tr>
<?php
					}
?>
    					<tr>
    						<td colspan="2">
									<button class="lgnButton" onclick="bookCourt()"><?php print db_ReadTextObject($lang,"Continue"); ?></button>
								</td>
							</tr>
						</table>
						<input type="hidden" name="tabjsonData" id="tabjsonData" value="" />
					</div>
				</form>
		</div>
		<div class="mainContent">
				<div class="tCourts">
<?php
							for ($iCrt = 0; $iCrt < $iCourts; $iCrt++)
							{
								$name = str_replace(" ","", $aCourts[$iCrt]["displayName"]);
								if ((int)$aCourts[$iCrt]["bActive"] == 1)
								{
									print "\t\t\t\t\t\t\t<button class=\"tablinks cuseable\" onclick=\"openTab(event, '" . $name ."');\">" . $aCourts[$iCrt]["displayName"] . "</button>\n";
								} else
								{
									print "\t\t\t\t\t\t\t<button class=\"tablinks\" onclick=\"openTab(event, '" . $name ."');\">" . $aCourts[$iCrt]["displayName"] . "</button>\n";
								}
							}
?>
				</div>
<?php
							$bFirst = true;
							for ($iCrt = 0; $iCrt < $iCourts; $iCrt++)
							{
								$name = str_replace(" ","", $aCourts[$iCrt]["displayName"]);
								print "\t\t\t\t\t\t<div id=\"" . $name . "\" class=\"tabcontent\">\n";
								print "\t\t\t\t\t\t\t<h3>" . db_ReadTextObject($lang,"Overview") . " " . $aCourts[$iCrt]["displayName"] . "</h3><br>\n";
								print "\t\t\t\t\t\t\t<table class=\"timeTable\">\n";
								print "\t\t\t\t\t\t\t\t<tr><th class=\"timeTableHighlightedTimes\">" . db_ReadTextObject($lang,"Time") . "</th>\n";

								for ($wd = 0;$wd < $iMaxDays;$wd++)
								{
									if ($wd > 0)
									{
										if ($lang != 2)
										{
											$newDate = date('d.m.Y', strtotime($newDate . " + 1 day"));
										} else
										{
											$newDate = date('m/d/Y', strtotime($newDate . " + 1 day"));
										}
									} else
									{
										if ($lang != 2)
										{
											$newDate = date('d.m.Y');
										} else
										{
											$newDate = date('m/d/Y');
										}
									}
									// $dayOfWeek = date("l", strtotime($newDate));
									$dayOfWeek = strftime("%A", strtotime($newDate));
									print "\t\t\t\t\t\t\t\t\t<th class=\"timeTableHighlighted\">" . $dayOfWeek . "<br />" . $newDate . "</th>\n";
								}
								print "\t\t\t\t\t\t\t\t</tr>\n";
								for ($h = $iEarliest;$h < $iLatest;$h++)
								{
									$tstart = str_pad($h,2,"0",STR_PAD_LEFT) . ":00";
									$tend = str_pad($h+1,2,"0",STR_PAD_LEFT) . ":00";
									print "\t\t\t\t\t\t\t\t<tr><th class=\"timeTableHighlighted\">" . $tstart . " - " . $tend ."</th>\n";
									for ($wd = 0;$wd < $iMaxDays;$wd++)
									{
										$searchDate = new DateTime('NOW');
										$addStr = "P" . strval($wd) . "D";
										$searchDate->add(new DateInterval($addStr));
										$txDate = DateTime::createFromFormat('Y-m-d H:i:s', $searchDate->format('Y-m-d') . ' '.strval($h).":00:00");
										$myUsage = db_GetReservationUsage($user->data['pkid'],$searchDate->format('Y-m-d'));
										if ($wd > 0)
										{
											$ckdate = date('Y-m-d', strtotime($ckdate . " + 1 day"));
										} else
										{
											$ckdate = date('Y-m-d');
										}
										if ($h <= ($currentHour + $iInAdvanceRequired) && $wd == 0)
										{
											print "\t\t\t\t\t\t\t\t\t<td class=\"timeTableOld\"></td>\n";
										} else
										{
											$rObj = db_CheckReservation($ckdate,$h, $aCourts[$iCrt]["pkid"],$user->data["pkid"]);
											$jsdata = array(
												'lang' => $lang
												,'strTime' => $strClockTime
												,'loggedIn' => $bLoggedIn
												,'userid' => $user->data["pkid"]
												,'unixts' => $txDate->format('U')
												,'rDate' => $searchDate->format('Y-m-d')
												,'rHour' => $h
												,'rCourt' => (int)$aCourts[$iCrt]["pkid"]
												,'aMembers' => $aMembers
												,'perDay' => $myUsage['perDay']
												,'perWeek' => $myUsage['perWeek']
												,'maxDay' => 	$iMaxBookingsPerDay
												,'maxWeek' => $iMaxBookingsPerWeek
												,'duration' => $iMaxBookingsDuration
												,'localConnected' => $bLocalConnected
												,'CheckInMinutes' => $iCheckInMinutes
												,'CheckInMethod' => $bCheckInMethod
												,'Players' => $rObj["strPlayers"]
												,'Requester' => $rObj["userid"]
												,'strCourt' => $aCourts[$iCrt]["displayName"]
											);
											if ($rObj == null)
											{
												print "\t\t\t\t\t\t\t\t\t<td class=\"timeTableNormal\">\n";
												if ((int)$aCourts[$iCrt]["bActive"] == 1)
												{
													print "\t\t\t\t\t\t\t<button class='buttonBook' onclick='resBooking(" . json_encode($jsdata, JSON_HEX_TAG | JSON_HEX_AMP) . ")'></button>\n";
												} else
												{
													print "\t\t\t\t\t\t\t<button class='buttonBook' onclick='showScreen(10)'></button>\n";
												}
												print "\t\t\t\t\t\t\t\t\t</td>\n";
											} else
											{
												if (($bLoggedIn) && ($rObj["myBooking"] == 1) && $rObj["status"] == 5)
												{	// gelb - noch nicht eingescheckt
													print "\t\t\t\t\t\t\t\t\t<td class=\"timeTableReserved\">\n";
													print "\t\t\t\t\t\t\t<button class='buttonCancel' onclick='resManage(" . strval($rObj["userid"]) . "," . strval($rObj["pkid"]) . "," . strval($rObj["status"]). "," . json_encode($jsdata, JSON_HEX_TAG | JSON_HEX_AMP) . ")'></button>\n";
													print "\t\t\t\t\t\t\t\t\t</td>\n";
												} elseif (($bLoggedIn) && ($user->data["pkid"] == $rObj["userid"]) && $rObj["status"] == 10)
												{   // rot - reserviert oder nicht mir
													print "\t\t\t\t\t\t\t\t\t<td class=\"timeTableBooked\">\n";
													print "\t\t\t\t\t\t\t<button class='buttonCancel' onclick='resManage(" . strval($rObj["userid"]) . "," . strval($rObj["pkid"]) . "," . strval($rObj["status"]). "," . json_encode($jsdata, JSON_HEX_TAG | JSON_HEX_AMP) . ")'></button>\n";
													print "\t\t\t\t\t\t\t\t\t</td>\n";
												} else
												{
													print "\t\t\t\t\t\t\t\t\t<td class=\"timeTableOld\"></td>\n";
												}
											}
										}
									}

									print "\t\t\t\t\t\t\t\t</tr>\n";
								}
								print "\t\t\t\t\t\t\t</table>\n";
								print "\t\t\t\t\t\t</div>\n";
							}
							$bFirst = false;
?>
			</div>


	</div>
	<script>
	document.getElementById("idPassword").required = true;
	$(document).ready(function()
	{
  	$("#selPlayer2").select2();
  	$("#selPlayer3").select2();
  	$("#selPlayer4").select2();
	});
	</script>
	</body>
</html>
