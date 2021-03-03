-- VIEW COURTS
DROP TABLE IF EXISTS `vw_Courts`;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Courts`  AS SELECT `t1`.`pkid` AS `pkid`, `t1`.`bActive` AS `bActive`, `t1`.`bDisplay` AS `bDisplay`, `t2`.`text` AS `displayName`, `t2`.`fk_lang` AS `fk_lang` FROM (`tCourts` `t1` left join `tCourts_L` `t2` on(`t1`.`pkid` = `t2`.`fk_court`)) ;

-- VIEW USERS
DROP TABLE IF EXISTS `vw_Users`;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Users`  AS SELECT `tActiveUsers`.`pkid` AS `pkid`, `tActiveUsers`.`fk_utype` AS `fk_utype`, `tActiveUsers`.`displayName` AS `displayName`, `tActiveUsers`.`lastName` AS `lastName`, `tActiveUsers`.`firstName` AS `firstName`, `tActiveUsers`.`emailAddress` AS `emailAddress`, `tActiveUsers`.`pwhash` AS `pwhash`, `tActiveUsers`.`birthdate` AS `birthdate`, year(curdate()) - year(`tActiveUsers`.`birthdate`) - (date_format(curdate(),'%m%d') < date_format(`tActiveUsers`.`birthdate`,'%m%d')) AS `age` FROM `tActiveUsers` ;

-- VIEW RESERVATIONS
DROP TABLE IF EXISTS `vw_Reservations`;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`jkollbach`@`localhost` SQL SECURITY DEFINER VIEW `vw_Reservations`  AS SELECT `t1`.`schedule` AS `schedule`, concat(lpad(cast(`t1`.`hour` as char charset utf8mb4),2,0),':00') AS `Time`, `t1`.`fk_court` AS `court`, concat(`p1`.`lastName`,', ',`p1`.`firstName`) AS `Player1`, concat(`p2`.`lastName`,', ',`p2`.`firstName`) AS `Player2`, concat(`p3`.`lastName`,', ',`p3`.`firstName`) AS `Player3`, concat(`p4`.`lastName`,', ',`p4`.`firstName`) AS `Player4`, `t1`.`status` AS `Status` FROM (((((`tReservations` `t1` left join `tActiveUsers` `p1` on(`t1`.`fk_requester` = `p1`.`pkid`)) left join `tActiveUsers` `p2` on(`t1`.`fk_player2` = `p2`.`pkid`)) left join `tActiveUsers` `p3` on(`t1`.`fk_player3` = `p3`.`pkid`)) left join `tActiveUsers` `p4` on(`t1`.`fk_player4` = `p4`.`pkid`)) left join `tCourts` `c` on(`t1`.`fk_court` = `c`.`pkid`)) ORDER BY `t1`.`schedule` ASC, `t1`.`hour` ASC, `t1`.`fk_court` ASC ;
