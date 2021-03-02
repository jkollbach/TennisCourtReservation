-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 01. Mrz 2021 um 14:24
-- Server-Version: 10.3.27-MariaDB-0+deb10u1
-- PHP-Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `tclCourtReserve`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tActiveUsers`
--

CREATE TABLE `tActiveUsers` (
  `pkid` int(11) NOT NULL,
  `fk_utype` tinyint(4) NOT NULL DEFAULT 2,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `displayName` varchar(50) NOT NULL,
  `emailAddress` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `pwhash` varchar(100) NOT NULL DEFAULT 'leer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User aus Azure';

--
-- Daten für Tabelle `tActiveUsers`
--

INSERT INTO `tActiveUsers` (`pkid`, `fk_utype`, `timestamp`, `lastName`, `firstName`, `displayName`, `emailAddress`, `birthdate`, `pwhash`) VALUES
(0, 1, '2021-03-01 12:14:18', 'System', 'Reservation', 'Reservation System', 'your@sender-email.com', '1970-01-01', 'leer');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tCourts`
--

CREATE TABLE `tCourts` (
  `pkid` tinyint(4) NOT NULL,
  `bActive` tinyint(1) NOT NULL DEFAULT 0,
  `bDisplay` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tCourts`
--

INSERT INTO `tCourts` (`pkid`, `bActive`, `bDisplay`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 0, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tCourts_L`
--

CREATE TABLE `tCourts_L` (
  `fk_court` tinyint(4) NOT NULL,
  `fk_lang` smallint(6) NOT NULL,
  `text` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tCourts_L`
--

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

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tLanguages`
--

CREATE TABLE `tLanguages` (
  `pkid` smallint(6) NOT NULL,
  `label` varchar(25) NOT NULL,
  `imageUrl` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tLanguages`
--

INSERT INTO `tLanguages` (`pkid`, `label`, `imageUrl`) VALUES
(1, 'de_DE', './img/flag_germany.png'),
(2, 'en_GB', './img/flag_uk.png'),
(3, 'fr_FR', './img/flag_france.png');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tReservations`
--

CREATE TABLE `tReservations` (
  `pkid` int(11) NOT NULL,
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
  `fk_player4` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Reservierungen';

--
-- Daten für Tabelle `tReservations`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tTextObjects`
--

CREATE TABLE `tTextObjects` (
  `fk_lang` smallint(6) NOT NULL,
  `label` varchar(50) NOT NULL,
  `text` varchar(400) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tTextObjects`
--

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

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tUserTypes`
--

CREATE TABLE `tUserTypes` (
  `pkid` tinyint(4) NOT NULL,
  `label` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tUserTypes`
--

INSERT INTO `tUserTypes` (`pkid`, `label`) VALUES
(1, 'Service Account'),
(2, 'Normal Users'),
(3, 'Guest Account');

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `vw_Courts`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `vw_Courts` (
`pkid` tinyint(4)
,`bActive` tinyint(1)
,`bDisplay` tinyint(1)
,`displayName` varchar(25)
,`fk_lang` smallint(6)
);

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `vw_Reservations`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `vw_Reservations` (
`schedule` date
,`Time` varchar(5)
,`court` tinyint(4)
,`Player1` varchar(102)
,`Player2` varchar(102)
,`Player3` varchar(102)
,`Player4` varchar(102)
,`Status` tinyint(4)
);

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `vw_Users`
-- (Siehe unten für die tatsächliche Ansicht)
--
CREATE TABLE `vw_Users` (
`pkid` int(11)
,`fk_utype` tinyint(4)
,`displayName` varchar(50)
,`lastName` varchar(50)
,`firstName` varchar(50)
,`emailAddress` varchar(50)
,`pwhash` varchar(100)
,`birthdate` date
,`age` int(6)
);

-- --------------------------------------------------------

--
-- Struktur des Views `vw_Courts`
--
DROP TABLE IF EXISTS `vw_Courts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Courts`  AS SELECT `t1`.`pkid` AS `pkid`, `t1`.`bActive` AS `bActive`, `t1`.`bDisplay` AS `bDisplay`, `t2`.`text` AS `displayName`, `t2`.`fk_lang` AS `fk_lang` FROM (`tCourts` `t1` left join `tCourts_L` `t2` on(`t1`.`pkid` = `t2`.`fk_court`)) ;

-- --------------------------------------------------------

--
-- Struktur des Views `vw_Reservations`
--
DROP TABLE IF EXISTS `vw_Reservations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Reservations`  AS SELECT `t1`.`schedule` AS `schedule`, concat(lpad(cast(`t1`.`hour` as char charset utf8mb4),2,0),':00') AS `Time`, `t1`.`fk_court` AS `court`, concat(`p1`.`lastName`,', ',`p1`.`firstName`) AS `Player1`, concat(`p2`.`lastName`,', ',`p2`.`firstName`) AS `Player2`, concat(`p3`.`lastName`,', ',`p3`.`firstName`) AS `Player3`, concat(`p4`.`lastName`,', ',`p4`.`firstName`) AS `Player4`, `t1`.`status` AS `Status` FROM (((((`tReservations` `t1` left join `tActiveUsers` `p1` on(`t1`.`fk_requester` = `p1`.`pkid`)) left join `tActiveUsers` `p2` on(`t1`.`fk_player2` = `p2`.`pkid`)) left join `tActiveUsers` `p3` on(`t1`.`fk_player3` = `p3`.`pkid`)) left join `tActiveUsers` `p4` on(`t1`.`fk_player4` = `p4`.`pkid`)) left join `tCourts` `c` on(`t1`.`fk_court` = `c`.`pkid`)) ORDER BY `t1`.`schedule` ASC, `t1`.`hour` ASC, `t1`.`fk_court` ASC ;

-- --------------------------------------------------------

--
-- Struktur des Views `vw_Users`
--
DROP TABLE IF EXISTS `vw_Users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Users`  AS SELECT `tActiveUsers`.`pkid` AS `pkid`, `tActiveUsers`.`fk_utype` AS `fk_utype`, `tActiveUsers`.`displayName` AS `displayName`, `tActiveUsers`.`lastName` AS `lastName`, `tActiveUsers`.`firstName` AS `firstName`, `tActiveUsers`.`emailAddress` AS `emailAddress`, `tActiveUsers`.`pwhash` AS `pwhash`, `tActiveUsers`.`birthdate` AS `birthdate`, year(curdate()) - year(`tActiveUsers`.`birthdate`) - (date_format(curdate(),'%m%d') < date_format(`tActiveUsers`.`birthdate`,'%m%d')) AS `age` FROM `tActiveUsers` ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `tActiveUsers`
--
ALTER TABLE `tActiveUsers`
  ADD PRIMARY KEY (`pkid`),
  ADD KEY `fk_utype_tUserType` (`fk_utype`);

--
-- Indizes für die Tabelle `tCourts`
--
ALTER TABLE `tCourts`
  ADD PRIMARY KEY (`pkid`);

--
-- Indizes für die Tabelle `tCourts_L`
--
ALTER TABLE `tCourts_L`
  ADD KEY `fk_court_pkid` (`fk_court`),
  ADD KEY `fk_lang_pkid` (`fk_lang`);

--
-- Indizes für die Tabelle `tLanguages`
--
ALTER TABLE `tLanguages`
  ADD PRIMARY KEY (`pkid`);

--
-- Indizes für die Tabelle `tReservations`
--
ALTER TABLE `tReservations`
  ADD PRIMARY KEY (`pkid`),
  ADD KEY `tReservations_Player2` (`fk_player2`),
  ADD KEY `tReservations_Player3` (`fk_player3`),
  ADD KEY `tReservations_Player4` (`fk_player4`),
  ADD KEY `tReservations_Requester` (`fk_requester`),
  ADD KEY `tReservations_ibfk_1` (`fk_court`);

--
-- Indizes für die Tabelle `tTextObjects`
--
ALTER TABLE `tTextObjects`
  ADD KEY `fk_text_pkid_lang` (`fk_lang`);

--
-- Indizes für die Tabelle `tUserTypes`
--
ALTER TABLE `tUserTypes`
  ADD PRIMARY KEY (`pkid`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `tLanguages`
--
ALTER TABLE `tLanguages`
  MODIFY `pkid` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT für Tabelle `tReservations`
--
ALTER TABLE `tReservations`
  MODIFY `pkid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `tActiveUsers`
--
ALTER TABLE `tActiveUsers`
  ADD CONSTRAINT `fk_utype_tUserType` FOREIGN KEY (`fk_utype`) REFERENCES `tUserTypes` (`pkid`) ON UPDATE NO ACTION;

--
-- Constraints der Tabelle `tCourts_L`
--
ALTER TABLE `tCourts_L`
  ADD CONSTRAINT `fk_court_pkid` FOREIGN KEY (`fk_court`) REFERENCES `tCourts` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_lang_pkid` FOREIGN KEY (`fk_lang`) REFERENCES `tLanguages` (`pkid`) ON UPDATE NO ACTION;

--
-- Constraints der Tabelle `tReservations`
--
ALTER TABLE `tReservations`
  ADD CONSTRAINT `tReservations_Player2` FOREIGN KEY (`fk_player2`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Player3` FOREIGN KEY (`fk_player3`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Player4` FOREIGN KEY (`fk_player4`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_Requester` FOREIGN KEY (`fk_requester`) REFERENCES `tActiveUsers` (`pkid`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `tReservations_ibfk_1` FOREIGN KEY (`fk_court`) REFERENCES `tCourts` (`pkid`) ON UPDATE NO ACTION;

--
-- Constraints der Tabelle `tTextObjects`
--
ALTER TABLE `tTextObjects`
  ADD CONSTRAINT `fk_text_pkid_lang` FOREIGN KEY (`fk_lang`) REFERENCES `tLanguages` (`pkid`) ON UPDATE NO ACTION;

DELIMITER $$
--
-- Ereignisse
--
CREATE DEFINER=`jkollbach`@`localhost` EVENT `CancelBooking` ON SCHEDULE EVERY 1 HOUR STARTS '2021-02-20 17:55:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE tReservations SET status = -1, timestamp = current_timestamp() WHERE status = 5 And (now() + INTERVAL 5 Minute) >= DATE_ADD(CONVERT(schedule, datetime), INTERVAL hour HOUR)$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
