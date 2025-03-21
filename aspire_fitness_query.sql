SELECT M.membership_number AS m_id, concat(M.first_name,' ' , M.surname) as name, 
	C.date, C.class_schedule_id, CS.day, CS.time FROM Members AS M
	INNER JOIN ClassBookings AS C ON C.membership_number = M.membership_number
    INNER JOIN ClassSchedule AS CS ON C.class_schedule_id = CS.class_schedule_id
    WHERE M.membership_number = 1 AND yearweek(C.date,3) = yearweek(curdate(), 3);

SELECT M.membership_number AS m_id, concat(M.first_name,' ' , M.surname) as name, 
	FB.date, FB.time_start, FB.time_end FROM Members AS M
	INNER JOIN FacilityBookings AS FB ON FB.membership_number = M.membership_number
    INNER JOIN Facilities AS F ON F.facility_id = FB.facility_id
    WHERE M.membership_number = 2 AND yearweek(FB.date,3) = yearweek(curdate(), 3);


SELECT C.class_code, C.name, concat(S.first_name, ' ' , S.surname) AS instructor,
	CS.day, CS.time, FB.facility_id, F.name, FB.date FROM Classes AS C
	INNER JOIN ClassSchedule AS CS ON CS.class_id = C.class_code
    INNER JOIN FacilityBookings AS FB ON FB.class_schedule_id = CS.class_schedule_id
    INNER JOIN Facilities AS F ON F.facility_id = FB.facility_id
    INNER JOIN Staffs AS S ON S.staff_number = C.instructor_id
    WHERE C.instructor_id = 11 AND yearweek(FB.date, 3) = yearweek(curdate(), 3)
		AND FB.date >= curdate();

SELECT m.membership_number, COUNT(cb.membership_number) + COUNT(fb.membership_number) AS
	total_bookings FROM Members AS m
    LEFT JOIN ClassBookings AS cb ON 
		m.membership_number = cb.membership_number
		AND EXTRACT(YEAR_MONTH FROM cb.date) = EXTRACT(YEAR_MONTH FROM curdate())
    LEFT JOIN FacilityBookings AS fb ON 
		m.membership_number = fb.membership_number
        AND EXTRACT(YEAR_MONTH FROM fb.date) = EXTRACT(YEAR_MONTH FROM curdate())
    GROUP BY m.membership_number
    ORDER BY total_bookings DESC LIMIT 10;
