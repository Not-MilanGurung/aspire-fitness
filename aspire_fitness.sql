CREATE DATABASE SportsClub;

USE SportsClub;
-- Creating Members Table
CREATE TABLE Members ( 
	membership_number INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    dob DATE NOT NULL,
    has_medical_condition BOOL NOT NULL,
    CONSTRAINT telephoneFormat_Members_CK 
		CHECK ((LENGTH(REGEXP_REPLACE(telephone, '[- ()]', '')) BETWEEN 8 and 11) 
        and (REGEXP_LIKE(telephone, '^[0(][- ()0-9]*$'))),
	CONSTRAINT emailFormat_Members_CK
		CHECK (REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'))
);


CREATE TABLE Facilities (
	facility_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    capacity TINYINT NOT NULL,
    activities VARCHAR(500) NOT NULL
);


CREATE TABLE Staffs (
	staff_number INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    role ENUM('Personal Trainer', 'Class Instructor', 'GYM Staff', 'Manager', 'Administration'),
    phone_number VARCHAR(20) NOT NULL,
    CONSTRAINT phone_numberFormat_Staffs_CK
    CHECK ((LENGTH(REGEXP_REPLACE(phone_number, '[- +()]', '')) BETWEEN 10 and 13) 
        and (REGEXP_LIKE(phone_number, '^[0-9(+][- ()0-9]*$')))
);

CREATE TABLE Classes (
	class_code INT PRIMARY KEY,
    name VARCHAR(50),
    instructor_id INT NOT NULL,
    maximum_class_size TINYINT NOT NULL,
    CONSTRAINT ClassesStaff_FK FOREIGN KEY (instructor_id) REFERENCES Staffs(staff_number)
);

CREATE TABLE ClassSchedule (
	class_schedule_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    day ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') NOT NULL,
    time TIME NOT NULL
);

CREATE TABLE FacilityBookings (
	facility_id INT,
    date DATE NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    membership_number INT,
    class_schedule_id INT,
    CONSTRAINT FacilityBookings_PK PRIMARY KEY (facility_id, date, time_start),
    CONSTRAINT FacilityBookings_Facilities_FK FOREIGN KEY (facility_id) REFERENCES Facilities(facility_id),
    CONSTRAINT FacilityBookings_Members_FK FOREIGN KEY (membership_number) REFERENCES Members(membership_number),
    CONSTRAINT FacilityBookings_ClassSchedule_FK FOREIGN KEY (class_schedule_id) REFERENCES ClassSchedule(class_schedule_id),
    CONSTRAINT timeLimit 
		CHECK ((time_start - time_end) <= CAST('02:00:00' AS TIME) OR (membership_number IS NULL)),
	CONSTRAINT either_member_or_class
		CHECK ((membership_number IS NULL OR class_schedule_id IS NULL)
			AND
            NOT (membership_number IS NULL AND class_schedule_id IS NULL)
		)
);

delimiter //
CREATE TRIGGER member_weekly_limit_insert BEFORE
	INSERT ON FacilityBookings
    FOR EACH ROW
BEGIN
	DECLARE rowcount INT;
    
    SELECT COUNT(*) INTO rowcount FROM FacilityBookings
    WHERE membership_number = NEW.membership_number
    AND (yearweek(date, 3) = yearweek(NEW.date, 3)); 
    IF rowcount > 0 THEN
		signal sqlstate '45000' set message_text = 'Members can only book facilities once a week';
	END IF;
END; //
delimiter ;

delimiter //
CREATE TRIGGER member_weekly_limit_update BEFORE
	UPDATE ON FacilityBookings
    FOR EACH ROW
BEGIN
	DECLARE rowcount INT;
    
    SELECT COUNT(*) INTO rowcount FROM FacilityBookings
    WHERE membership_number = NEW.membership_number
    AND (facility_id != OLD.facility_id AND date != OLD.date AND time_start != OLD.time_start)
    AND (yearweek(date, 3) = yearweek(NEW.date, 3)); 
    IF rowcount > 0 THEN
		signal sqlstate '45000' set message_text = 'Members can only book facilities once a week';
	END IF;
END; //
delimiter ;

delimiter //
CREATE TRIGGER booking_overlap_insert BEFORE
INSERT ON FacilityBookings
FOR EACH ROW
BEGIN
	DECLARE rowcount INT;
    
    SELECT COUNT(*) INTO rowcount FROM FacilityBookings
    WHERE facility_id = NEW.facility_id
    AND (date = NEW.date) 
    AND (NEW.time_start <= time_end AND NEW.time_end >= time_start);
    
    IF rowcount > 0 THEN
		signal sqlstate '45000' set message_text = 'The bookings can not overlap';
	END IF;
END; //
delimiter ;

delimiter //
CREATE TRIGGER booking_overlap_update BEFORE
UPDATE ON FacilityBookings
FOR EACH ROW
BEGIN
	DECLARE rowcount INT;
    
    SELECT COUNT(*) INTO rowcount FROM FacilityBookings
    WHERE facility_id = NEW.facility_id
    AND (facility_id != OLD.facility_id AND date != OLD.date AND time_start != OLD.time_start)
    AND (date = NEW.date) 
    AND (NEW.time_start <= time_end AND NEW.time_end >= time_start);
    
    IF rowcount > 0 THEN
		signal sqlstate '45000' set message_text = 'The bookings can not overlap';
	END IF;
END; //
delimiter ;

CREATE TABLE ClassBookings (
	class_schedule_id INT,
    membership_number INT,
    date DATE,
    CONSTRAINT ClassBookings_PK PRIMARY KEY (class_schedule_id, membership_number, date),
    CONSTRAINT ClassBookings_ClassSchedule_FK FOREIGN KEY (class_schedule_id) REFERENCES ClassSchedule(class_schedule_id),
    CONSTRAINT ClassBookings_Members_FK FOREIGN KEY (membership_number) REFERENCES Members(membership_number)
);

CREATE TABLE Payments (
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_number INT NOT NULL,
    amount INT NOT NULL,
    payment_date DATETIME NOT NULL,
    CONSTRAINT PaymentsMembers_FK FOREIGN KEY (membership_number) REFERENCES Members(membership_number)
);

CREATE TABLE WeeklySubscription (
	membership_number INT,
    year YEAR,
    week_no INT,
    payment_id INT,
    CONSTRAINT PRIMARY KEY (membership_number, year, week_no),
    CONSTRAINT WeeklySubscription_Payments_FK FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

CREATE TABLE MedicalConditions (
	condition_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    prevention VARCHAR(500),
    first_aid_desc VARCHAR(500),
    INDEX (name)
);

CREATE TABLE MembersMedicalConditions (
	membership_number INT,
    condition_id INT,
    CONSTRAINT MembersMedicalConditions_PK PRIMARY KEY (membership_number, condition_id),
    CONSTRAINT Members_MedicalConditon_FK FOREIGN KEY (membership_number) REFERENCES Members(membership_number),
    CONSTRAINT MedicalCondition_Members_FK FOREIGN KEY (condition_id) REFERENCES MedicalConditions(condition_id)
);