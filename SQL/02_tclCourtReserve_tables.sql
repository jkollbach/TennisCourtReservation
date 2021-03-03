-- TABLES

-- LANGUAGES
CREATE TABLE IF NOT EXISTS `tLanguages` (
  `pkid` smallint(6) NOT NULL AUTO_INCREMENT,
  `label` varchar(25) NOT NULL,
  `imageUrl` varchar(300) NOT NULL,
  PRIMARY KEY (`pkid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

INSERT INTO `tLanguages` (`pkid`, `label`, `imageUrl`) VALUES
(1, 'de_DE', './img/flag_germany.png'),
(2, 'en_GB', './img/flag_uk.png'),
(3, 'fr_FR', './img/flag_france.png');

-- TEXTOBJECTS
CREATE TABLE IF NOT EXISTS `tTextObjects` (
  `fk_lang` smallint(6) NOT NULL,
  `label` varchar(50) NOT NULL,
  `text` varchar(400) NOT NULL,
  KEY `fk_text_pkid_lang` (`fk_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `tTextObjects`
  ADD CONSTRAINT `fk_text_pkid_lang` FOREIGN KEY (`fk_lang`) REFERENCES `tLanguages` (`pkid`) ON UPDATE NO ACTION;

INSERT INTO `tTextObjects` (`fk_lang`, `label`, `text`) VALUES
(1, 'Overview', 'Übersicht'),
(2, 'Overview', 'Overview'),
(1, 'AskForEmail', 'Ihre eMail Adresse'),
(2, 'AskForEmail', 'Your email address'),
(1, 'Time', 'Uhrzeit'),
(2, 'Time', 'Schedule'),
(3, 'Time', 'l\'heure'),
(1, 'Close', 'schließen'),
(2, 'Close', 'close'),
(3, 'Close', 'fermer'),
(1, 'Player', 'Mitspieler'),
(2, 'Player', 'Player'),
(3, 'Player', 'le coéquipier'),
(1, 'email', 'eMail Adresse'),
(2, 'email', 'email address'),
(1, 'AskForPassword', 'Ihr Kennwort'),
(2, 'AskForPassword', 'Your password'),
(1, 'password', 'Kennwort'),
(2, 'password', 'Password'),
(2, 'login', 'Login'),
(1, 'login', 'Anmelden'),
(1, 'logout', 'Abmelden'),
(2, 'logout', 'Logout'),
(1, 'AskSelect', 'bitte wählen'),
(2, 'AskSelect', 'please select'),
(1, 'Continue', 'weiter'),
(2, 'Continue', 'continue'),
(1, 'Attention', 'Achtung'),
(2, 'Attention', 'Attention'),
(1, 'NoBookMessage', 'Sie oder eine*r Ihrer Mitspieler*innen haben für diesen Tag bzw. für diese Woche das Kontingent erschöpft.<br>Bitte reservieren Sie für einen anderen Tag, für die nächste Woche oder fragen Sie eine*n andere*n Partner*in.<br><br>Bei freien Plätzen können Sie natürlich ohne Reservierung spielen. Mitgliedern mit Reservierung ist aber Vorzug zu gewähren.'),
(2, 'NoBookMessage', 'You have already reached the reservation quota for that day or week. Please select another day or week.'),
(1, 'perDay', 'Stunde(n) pro Tag'),
(2, 'perDay', 'Hour(s) per day'),
(1, 'perWeek', 'Stunden pro Woche (Sonntag - Montag)'),
(2, 'perWeek', 'Hours per Week (Sunday - Monday)'),
(1, 'NewPW', 'Neues Kennwort'),
(2, 'NewPW', 'New password'),
(1, 'ConfPW', 'Kennwort bestätigen'),
(2, 'ConfPW', 'Confirm password'),
(1, 'NotMatch', 'Kennwörter stimmen nicht überein!'),
(2, 'NotMatch', 'Passwords do not match'),
(1, 'ChangePW', 'Kennwort ändern'),
(2, 'ChangePW', 'Change password'),
(1, 'UnknownUser', 'Benutzer oder Kennwort unbekannt.'),
(2, 'UnknownUser', 'Unknown user or password.'),
(1, 'PWStrength', 'Kennwort Qualität'),
(2, 'PWStrength', 'Password quality'),
(1, 'CancBook', 'Stornieren'),
(2, 'CancBook', 'Cancel Booking'),
(1, 'ConfBook', 'Check-In '),
(2, 'ConfBook', 'Check-In'),
(1, 'ResetPW', 'Kennwort erstellen/zurücksetzen'),
(2, 'ResetPW', 'Reset/create password'),
(1, 'PWCreated', 'Neues Kennwort wurde versendet'),
(2, 'PWCreated', 'New password has been sent'),
(1, 'NotActiveCourt', 'Dieser Platz ist für die digitale Reservierung nicht vorgesehen.'),
(1, 'YourPassword', 'Ihr neues Kennwort'),
(2, 'YourPassword', 'Your new password'),
(1, 'PWChangeSubject', 'Neues Kennwort'),
(2, 'PWChangeSubject', 'New Password'),
(1, 'strLocation', 'Tennisclub Lörzweiler'),
(1, 'strSummary', 'Tennis spielen in Lörzweiler'),
(1, 'eMailName', 'TCL Platz-Reservierung'),
(2, 'eMailName', 'TCL Court Reservation'),
(2, 'NotActiveCourt', 'This court is not intended for digital reservation.'),
(2, 'strLocation', 'Tennisclub Loerzweiler'),
(2, 'strSummary', 'Play Tennis in Loerzweiler'),
(1, 'Cancelled', 'Abgesagt'),
(2, 'Cancelled', 'Cancelled'),
(1, 'strTime', 'Uhr'),
(2, 'strTime', 'o\'clock');

-- COURTS
CREATE TABLE IF NOT EXISTS `tCourts` (
  `pkid` tinyint(4) NOT NULL,
  `bActive` tinyint(1) NOT NULL DEFAULT 0,
  `bDisplay` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tCourts` (`pkid`, `bActive`, `bDisplay`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 0, 1);

-- COURT Language specific
CREATE TABLE IF NOT EXISTS `tCourts_L` (
  `fk_court` tinyint(4) NOT NULL,
  `fk_lang` smallint(6) NOT NULL,
  `text` varchar(25) NOT NULL,
  KEY `fk_court_pkid` (`fk_court`),
  KEY `fk_lang_pkid` (`fk_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `tCourts_L`
  ADD CONSTRAINT `fk_court_pkid` FOREIGN KEY (`fk_court`) REFERENCES `tCourts` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_lang_pkid` FOREIGN KEY (`fk_lang`) REFERENCES `tLanguages` (`pkid`) ON UPDATE NO ACTION;

INSERT INTO `tCourts_L` (`fk_court`, `fk_lang`, `text`) VALUES
(1, 2, 'Court 1'),
(1, 3, 'court 1'),
(2, 2, 'Court 2'),
(3, 2, 'Court 3'),
(4, 2, 'Court 4'),
(2, 3, 'court 2'),
(3, 3, 'court 3'),
(4, 3, 'court 4'),
(1, 1, 'Platz 1'),
(2, 1, 'Platz 2'),
(3, 1, 'Platz 3'),
(4, 1, 'Platz 4');

-- USER TYPES
CREATE TABLE IF NOT EXISTS `tUserTypes` (
  `pkid` tinyint(4) NOT NULL,
  `label` varchar(20) NOT NULL,
  PRIMARY KEY (`pkid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tUserTypes` (`pkid`, `label`) VALUES
(1, 'Service Account'),
(2, 'Normal Users'),
(3, 'Guest Account');

-- USERS (just active ones, as passive users won't be allowed to book a court)

CREATE TABLE IF NOT EXISTS `tActiveUsers` (
  `pkid` int(11) NOT NULL,
  `fk_utype` tinyint(4) NOT NULL DEFAULT 2,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `displayName` varchar(50) NOT NULL,
  `emailAddress` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `pwhash` varchar(100) NOT NULL DEFAULT 'leer',
  PRIMARY KEY (`pkid`),
  UNIQUE KEY `emailAddress` (`emailAddress`),
  KEY `fk_utype_tUserType` (`fk_utype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User aus Azure';

ALTER TABLE `tActiveUsers`
  ADD CONSTRAINT `fk_utype_tUserType` FOREIGN KEY (`fk_utype`) REFERENCES `tUserTypes` (`pkid`) ON UPDATE NO ACTION;

INSERT INTO `tActiveUsers` (`pkid`, `fk_utype`, `timestamp`, `lastName`, `firstName`, `displayName`, `emailAddress`, `birthdate`, `pwhash`) VALUES
(0, 1, '2021-03-01 12:00:00', 'System', 'Reservation', 'Reservation System', 'system@email.address', '1970-01-01', 'none'),
(1, 2, '2021-03-01 12:00:00', 'Tester', 'Ted', 'Ted Tester', 'my@email.address', '1970-01-01', 'none');;

-- RESERVATIONS
CREATE TABLE IF NOT EXISTS `tReservations` (
  `pkid` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(50) NOT NULL,
  `dtrequested` timestamp NOT NULL DEFAULT current_timestamp(),
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `fk_court` tinyint(4) NOT NULL,
  `fk_requester` int(11) NOT NULL,
  `schedule` date NOT NULL,
  `hour` smallint(6) NOT NULL,
  `duration` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `fk_player2` int(11) NOT NULL,
  `fk_player3` int(11) DEFAULT NULL,
  `fk_player4` int(11) DEFAULT NULL,
  PRIMARY KEY (`pkid`),
  KEY `tReservations_Player2` (`fk_player2`),
  KEY `tReservations_Player3` (`fk_player3`),
  KEY `tReservations_Player4` (`fk_player4`),
  KEY `tReservations_Requester` (`fk_requester`),
  KEY `tReservations_ibfk_1` (`fk_court`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COMMENT='Reservierungen';

ALTER TABLE `tReservations`
  ADD CONSTRAINT `tReservations_Player2` FOREIGN KEY (`fk_player2`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Player3` FOREIGN KEY (`fk_player3`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Player4` FOREIGN KEY (`fk_player4`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Requester` FOREIGN KEY (`fk_requester`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_ibfk_1` FOREIGN KEY (`fk_court`) REFERENCES `tCourts` (`pkid`) ON UPDATE NO ACTION;
