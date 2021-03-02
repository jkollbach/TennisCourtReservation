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

	$smtpServer = "smtp.office365.com";
	$intSmtpPort = 587;
	$eMailUser = "reservierung@tcloerzweiler.de";
	$eMailPw = "3vV0\"ybc`%=N0i'px*t{";
	$clubName = "Tennisclub Lörzweiler";
	$strBaseUrl = "tennisclub-loerzweiler.de";

	$bCheckInMethod = true;

	$srvHostname = "kollbach.dynv6.net";

	$dbUser = "svcTCourt";
	$dbPwd = ".yPc:3/v0vGOu=~fN@pF";
	$database = "tclCourtReserve";

	$fbSerialNumner = "C80E144097E3!";
	$fbLocalUrl = "http://192.168.10.1/jason_boxinfo.xml";
?>
