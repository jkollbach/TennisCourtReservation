<?php
	$iEarliest = 8; 			// first slot - start of timetable
	$iLatest = 20;  			// latest end of slot - end of timetable
	$iMaxDays = 7;  			// days presented on timetable - no future bookings possible
	$iMaxBookingsPerDay = 1; 	// one player is allowed to have one booking per day
	$iMaxBookingsPerWeek = 3; 	// one player is allowed to have max 3 bookings per day
	$iInAdvanceRequired = 6; 	// 6 hours before event, cannot be booked remotely - so 6 hours in advance
	$iCheckInMinutes = 45;		// 45 mins before event it is allowed to check in
	$bCheckInMethod = true;		// if false, no check-in is required / bookings directly have the state of checked-in

	$smtpServer = "your.smtp.server";
	$intSmtpPort = 587;
	$eMailUser = "your@sender-email.com";
	$eMailPw = "PasswordForSMTPAuth";
	$clubName = "Your Club Name";
	$strBaseUrl = "Your home page w/o https://";	// e.g. my-club.co.uk


	$srvHostname = "dyndns hostname of local router";

	$dbUser = "DBUser";
	$dbPwd = "DBpassword";
	$database = "tclCourtReserve";

	$fbSerialNumner = "C80E144097E3!";
	$fbLocalUrl = "http://192.168.10.1/jason_boxinfo.xml";
?>
