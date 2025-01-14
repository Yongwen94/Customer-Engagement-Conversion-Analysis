USE customer_engagement;  -- call database

SELECT
	s.*,
    e.exam_category
FROM 
	student_exams s
LEFT JOIN 
	exam_info e
USING (exam_id);