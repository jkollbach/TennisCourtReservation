# TennisCourtReservation
Reserve Tennis Courts using (L)AMP System Apache / PHP / MariaDB

To Install:

DATABASE
Use e.g. phpMyAdmin to create the database
Import the ./SQL/ files in their order...
1 .. will create the database
2 .. will create the tables
3 .. will create some views
4 .. will create the events (adjust the times to your needs: default: 5 mins prior of event, event will be canceled, if there was no check-in)

SCRIPTS
Just copy the files to somewhere on your system, keep the structure.

CONFIGURATION
./inc/config.php keeps the configuration data, which needs to be adjusted. Hints are in the file.
One special point: To check, wether the user is local (at the club area) or not, there has to be a specific test in place. This can be enhanced in ./inc/functions.php.

There are two examples:
1. the club owns a fritzbox and the tool is running on a server in local network, so you could check the local fritzbox mac address 
2. the tool is running on some provider anywhere - you still need a local network, from where to check-in. If so, create a dyn-dns entry for the local network. Now the dyn-dns assigned IP and the remote address of the logged in user should be identically.




