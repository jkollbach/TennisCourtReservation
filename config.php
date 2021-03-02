<?php
	$iEarliest = 8;
	$iLatest = 20;
	$iMaxDays = 7;
	$iMaxBookingsPerDay = 1;
	$iMaxBookingsPerWeek = 3;
	$iInAdvanceRequired = 6;
	$iCheckInMinutes = 45;

	$objLimited = new stdClass();
	$objLimited->enabled = false;
	$objLimited->belowAge = 16;
	$objLimited->maxTime = 18;

	$smtpServer = "your.smtp.server";
	$intSmtpPort = 587;
	$eMailUser = "your@sender-email.com";
	$eMailPw = "PasswordForSMTPAuth";
	$clubName = "Your Club Name";
	$strBaseUrl = "Your home page w/o https://";

	$bCheckInMethod = true;

	$srvHostname = "hostname this tool is running on";

	$dbUser = "DBUser";
	$dbPwd = "DBpassword";
	$database = "tclCourtReserve";

	$fbSerialNumner = "C80E144097E3!";
	$fbLocalUrl = "http://192.168.10.1/jason_boxinfo.xml";
?>
