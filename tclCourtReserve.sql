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
(0, 1, '2021-03-01 12:14:18', 'System', 'Reservation', 'Reservation System', 'reservierung@tcloerzweiler.de', '1970-01-01', 'leer'),
(1, 2, '2021-02-25 14:14:55', 'Natzi', 'Christoph', 'Christoph Natzi', 'christoph@natzi.de', '1976-09-09', '$2y$10$VCxlbdKMRZW6q3l8Lz0U1.sfYuQDkHeRp9PREY4vzpGinHBwDshTi'),
(2, 2, '2021-02-19 06:25:14', 'Stickdorn', 'Claudia', 'Claudia Stickdorn', 'c-stickdorn@t-online.de', '1967-03-04', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(3, 2, '2021-02-19 06:25:14', 'Lohmüller', 'Frank', 'Frank Lohmüller', 'socke1969@googlemail.com', '1970-09-19', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(4, 2, '2021-02-26 10:34:55', 'Ghiena', 'Jean-Philippe', 'Jean-Philippe Ghiena', 'tcl.jugend@gmail.com', '1968-07-03', '$2y$10$36jDsYValgBg9B8D4Xx/0ekUwTnIIqRBOPZPwEBeQaV/jy.uuI2ca'),
(5, 2, '2021-02-19 06:25:14', 'Bisch', 'Brigitte', 'Brigitte Bisch', 'Bisch.B@medi-cine.de', '1965-03-12', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(6, 2, '2021-02-19 06:25:14', 'Rossa', 'Sven', 'Sven Rossa', 's.rossa@web.de', '1973-04-10', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(7, 2, '2021-02-19 06:25:14', 'Klingler', 'Tanja', 'Tanja Klingler', 'tanja.klingler.loerzweiler@gmail.com', '1975-05-13', '$2y$10$r6vq2Gl/BPlpn22l2R.djeXNJikU9qvFuSYlAGX3ZVPLDh6rMtZoC'),
(8, 2, '2021-02-19 06:25:14', 'Tester', 'Toni', 'Toni Tester', 'jkollbach@gmx.de', '2009-10-10', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(9, 2, '2021-02-19 06:25:14', 'Keller', 'Walter', 'Walter Keller', 'w.keller@viscomkeller.de', '1956-12-11', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(10, 2, '2021-02-19 06:25:14', 'Böttger', 'Wolfgang', 'Wolfgang Böttger', 'wboettger@tcloerzweiler.de', '1941-12-31', '$2y$10$LrQtYTOPBucLhkHspofBp.wEcnt.uYoLUCfZw4vzadz0G56GIfatu'),
(11, 2, '2021-02-19 06:25:14', 'Kollbach', 'Jens', 'Jens Kollbach', 'jkollbach@tcloerzweiler.de', '1975-10-02', '$2y$10$xfmx/tTMmVHkuy/g1F7QLupsww2mCCYJUzB/nQViSxuZoueI6D4y.'),
(12, 2, '2021-02-25 13:31:47', 'Mustermann', 'Max', 'Max Mustermann', 'jkollbach@gmail.com', '1977-10-10', '$2y$10$76P634gPnoX5yvpFkAMPI.8wZXtRXAIm9yATntUlA2/yn0JjUtBCO');

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

INSERT INTO `tReservations` (`pkid`, `uuid`, `dtrequested`, `timestamp`, `fk_court`, `fk_requester`, `schedule`, `hour`, `duration`, `status`, `fk_player2`, `fk_player3`, `fk_player4`) VALUES
(33, 'EFFA185B-DDDE-4494-98CC-45AE4D853B96', '2021-02-22 14:19:23', '2021-02-22 14:19:23', 1, 11, '2021-02-26', 18, 1, 5, 6, 1, NULL),
(34, 'A0F42665-0BCD-4EFD-B843-94EA26DEE276', '2021-02-25 14:04:44', '2021-02-25 14:05:36', 1, 12, '2021-02-25', 16, 1, 0, 11, NULL, NULL),
(35, 'E84B7CB7-0C93-4801-BBDF-C7E00E668E7D', '2021-02-25 14:05:58', '2021-02-25 14:15:28', 1, 12, '2021-02-25', 16, 1, 0, 11, NULL, NULL),
(36, '2343A313-53EE-496A-A2F8-0CC9B8DF48CE', '2021-02-25 14:17:10', '2021-02-25 14:20:10', 1, 1, '2021-02-25', 18, 1, 0, 9, 7, NULL),
(38, '713E7E6E-60ED-45A5-94C5-68F90F5CFECE', '2021-02-25 14:24:25', '2021-02-25 14:26:21', 1, 1, '2021-02-25', 16, 1, 0, 11, NULL, NULL),
(39, 'CD4FB1B6-4AA2-4347-BA04-34FF713FF60A', '2021-02-25 14:28:27', '2021-02-25 15:45:24', 1, 1, '2021-02-25', 19, 1, 0, 11, NULL, NULL),
(40, 'C9DD4D61-3105-49DD-AF50-08057FB32A49', '2021-02-25 14:43:39', '2021-02-25 14:43:39', 1, 11, '2021-02-27', 11, 1, 5, 12, NULL, NULL),
(41, 'ADBC2BF8-4BA9-4ABD-825B-C7B547BE748C', '2021-02-25 15:46:46', '2021-02-25 15:48:13', 1, 1, '2021-02-25', 17, 1, 0, 11, NULL, NULL),
(42, 'ED6FC28C-6E75-4942-B28F-A981CFA580BC', '2021-02-25 15:54:52', '2021-02-25 15:54:52', 1, 1, '2021-02-25', 18, 1, 5, 11, NULL, NULL),
(43, '1DD98575-A819-47E9-82A9-3B7E1CEFE135', '2021-02-26 10:38:13', '2021-02-26 10:38:13', 1, 4, '2021-02-27', 8, 1, 5, 8, NULL, NULL),
(44, '702EA5CE-00B3-4FBA-85D3-AC0B87BC5C81', '2021-02-26 10:38:30', '2021-02-26 10:38:30', 1, 4, '2021-02-28', 11, 1, 5, 7, NULL, NULL),
(45, '973FBF47-05D5-4B09-805C-C4AB1E339B24', '2021-02-26 10:38:43', '2021-02-26 10:38:43', 1, 4, '2021-03-04', 13, 1, 5, 11, 3, 6),
(46, '9C8FEBD5-1B4E-4480-B356-723A8D8353F8', '2021-02-26 10:39:31', '2021-02-26 10:39:31', 1, 4, '2021-03-03', 15, 1, 5, 12, NULL, NULL),
(47, '95D5BD54-FAFE-4D4D-B17F-0331BE212075', '2021-02-26 19:16:10', '2021-02-27 14:28:49', 1, 11, '2021-03-03', 8, 1, 0, 8, NULL, NULL),
(48, '93868448-EB11-403F-A309-B5465568CFC6', '2021-02-27 08:20:37', '2021-02-27 08:20:37', 1, 1, '2021-02-23', 8, 0, 10, 3, NULL, NULL),
(49, '5438B715-3D89-441C-97B9-CD64DA8D9D98', '2021-02-27 13:15:41', '2021-03-01 09:52:10', 1, 11, '2021-03-05', 8, 1, 0, 12, NULL, NULL),
(50, 'F9BEF6D9-F108-4EB6-B179-A8078996D83C', '2021-02-28 06:35:40', '2021-02-28 06:40:53', 1, 11, '2021-03-06', 8, 1, 0, 12, NULL, NULL),
(51, '1ED5F8D3-5F05-42A9-BF8F-EFECEEE9DBD1', '2021-03-01 07:54:17', '2021-03-01 07:56:34', 1, 11, '2021-03-02', 8, 1, 0, 12, NULL, NULL),
(52, 'A62C6095-44A0-40CA-90B7-D24FBD94BAA2', '2021-03-01 09:53:42', '2021-03-01 10:47:54', 1, 11, '2021-03-01', 12, 1, 10, 12, NULL, NULL),
(53, 'CCE0D06F-2EF2-4C31-8951-B6A9E5B253C2', '2021-03-01 12:06:29', '2021-03-01 12:14:32', 1, 11, '2021-03-02', 8, 1, 0, 12, NULL, NULL),
(54, 'A77F8E04-3269-4323-8EA9-C207840E71BE', '2021-03-01 12:37:00', '2021-03-01 12:39:00', 1, 11, '2021-03-02', 8, 1, 0, 12, NULL, NULL),
(55, 'D2E5EB68-743A-42F3-88CB-07C09065C4A0', '2021-03-01 13:18:56', '2021-03-01 13:21:26', 1, 11, '2021-03-02', 8, 1, 0, 12, NULL, NULL);

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
