
DELIMITER $$

-- EVENT: Cancel Bookings not checked in 5 mins prior to reservation start
CREATE EVENT `CancelBooking` ON SCHEDULE EVERY 1 HOUR STARTS '2021-03-01 12:55:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE tReservations SET status = -1, timestamp = current_timestamp() WHERE status = 5 And (now() + INTERVAL 5 Minute) >= DATE_ADD(CONVERT(schedule, datetime), INTERVAL hour HOUR)$$

DELIMITER ;
