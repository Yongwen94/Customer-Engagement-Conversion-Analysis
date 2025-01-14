USE customer_engagement;  -- call dataset



-- retrieve course_id that corresponding exams belong to students enrolled track
-- to get how many exams have been completed by students for each track
-- This is, for each track, how many (distinct) students have attemped a course exam

WITH student_exam_course AS 
(
SELECT
	s.student_id,
    e.course_id
FROM
	student_exams s
LEFT JOIN 
	exam_info e
USING (exam_id)
WHERE exam_category = 2
),
course_track_students_enrolled AS 
(SELECT
	s.student_id,
    s.track_id,
    c.course_id 
FROM 
	student_career_track_enrollments s
LEFT JOIN 
	career_track_info c
USING (track_id) ),
student_final_exam AS 
(
SELECT
	s.student_id,
    e.track_id
FROM
	student_exams s
LEFT JOIN 
	exam_info e
USING (exam_id)
WHERE exam_category = 3
)

-- retrieve students number for enrolled in each track
SELECT
	'Enrolled in a track' AS action,
	track_id,
    COUNT(student_id) AS count
FROM 
	student_career_track_enrollments
GROUP BY 
	track_id
    
UNION ALL

-- retrieve number of students who attempted a course exam for each track
SELECT 
	'Attempted a course exam' AS action,
	ct.track_id,
	COUNT(DISTINCT s.student_id) AS count
FROM 
	student_exam_course s
LEFT JOIN 
	course_track_students_enrolled ct
USING (student_id, course_id)
WHERE 
	ct.track_id IS NOT NULL
GROUP BY track_id

UNION ALL

-- retrieve number of students who completed a course exam for each track
SELECT
	'Completed a course exam' AS action,
	ct.track_id,
	COUNT(DISTINCT s.student_id) AS count
FROM 
	student_certificates s 
LEFT JOIN 
	course_track_students_enrolled ct
USING 
	(student_id, course_id)
WHERE 
	s.certificate_type = 1 AND ct.track_id IS NOT NULL
GROUP BY ct.track_id

UNION ALL 

-- retrieve number of (distinct) students who attemped a final exam for each track
-- attempted a final exam means students had exam belongs to category 3 in the exam_info table
SELECT
	'Attempted a final exam' AS action,
	s.track_id,
	COUNT(DISTINCT s.student_id) AS count
FROM 
	student_final_exam s
LEFT JOIN 
	course_track_students_enrolled ct
USING (student_id, track_id)
WHERE
	ct.course_id IS NOT NULL
GROUP BY
	s.track_id


UNION ALL
	
-- retrieve number of (distinct) students who earned a career track certificate for each track
-- earned a career track certificate means students got certificate where certificate_type = 2 in student_certificates table
SELECT 
	'Earned a career track certificate' AS action,
	s.track_id,
    COUNT(DISTINCT s.student_id) AS count
FROM 
	student_certificates s
LEFT JOIN 
	course_track_students_enrolled ct
USING (student_id, track_id)
WHERE 
	certificate_type = 2 AND ct.track_id IS NOT NULL
GROUP BY s.track_id;

