
INSERT INTO Members (first_name, surname, address, telephone, email, dob, has_medical_condition) VALUES 
	('George', 'Hamil', 'Lalitpur-14', '047-5678989', 'hamilGeorge@gmail.com', '1997-04-24', FALSE),
    ('Ram', 'Bahadur', 'New Baneshwor, KTM', '(059) 5648989', 'ram.bahadur@gmail.com', '1999-10-04', TRUE),
    ('Sita', 'Nepal', 'Jawlakhel, Lalitpur', '047 532689', 'sita@hello.info.com.np', '1991-04-24', FALSE);
    
INSERT INTO Facilities VALUES
	(101, 'Main Hall', 80, 'football, basketball, netball, volleyball'),
    (102, 'Yoga Hall', 25, 'yoga, dance, combat'),
    (201, 'Small Dance Room', 10, 'yoga, dance');
    
INSERT INTO Staffs VALUES
	(11, 'Marie', 'Key', 'Manager', '986-658-9999'),
    (14, 'Jeremy', 'Williamson', 'Class Instructor', '+977-984-1234598'),
    (103, 'Darragh', 'Krueger', 'Personal Trainer', '(323) 642-1512');
    
INSERT INTO Classes VALUES
	(034, 'Dance-101', 11, 25),
    (095, 'Football for Beginners', 14, 30),
    (077, 'Goat Yoga', 103, 10);

INSERT INTO ClassSchedule VALUES
	(108, 034, 'Monday', '14:30:00'),
    (258, 034, 'Thursday', '15:30:00'),
    (128, 095, 'Sunday', '08:00:00');

INSERT INTO FacilityBookings VALUES
	(102, '2025-03-21', '14:20:00' , '15:45:00', NULL, 108),
    (101, '2025-03-20', '08:00:00' , '11:00:00', NULL, 128),
    (201, '2025-03-19', '16:00:00' , '17:45:00', 2, NULL);


INSERT INTO ClassBookings VALUES
	(108, 1, '2025-03-17'),
    (258, 1, '2025-03-18'),
    (128, 3, '2025-03-20');

INSERT INTO Payments (membership_number, amount, payment_date) VALUES
	(1, 20, '2025-03-21'),
    (2, 20, '2025-03-20'),
    (3, 20, '2025-03-17');

INSERT INTO WeeklySubscription VALUES
	(1, '2025', 6, 1),
    (2, '2025', 3, 2),
    (3, '2025', 4, 3);

INSERT INTO MedicalConditions (name, prevention, first_aid_desc) VALUES
	('Asthma', 'Avoid intense cardio and ensure inhaler is available', 'Rest, use inhaler, seek medical advice if symptoms persist'),
	('Back Pain', 'Use proper posture during exercises and avoid heavy lifting', 'Apply heat or ice, take pain relief, and consult physiotherapist'),
	('Ankle Sprain', 'Avoid high-impact exercises and wear supportive footwear', 'Rest, elevate the leg, apply ice, and use compression bandage');

INSERT INTO MembersMedicalConditions VALUES
	(2, 1),
    (2, 2),
    (2, 3);