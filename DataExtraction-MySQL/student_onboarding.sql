USE customer_engagement;  -- call database

-- student onborading indicates whether students have engagement with the platform, including quiz, exam and lessons.

WITH engaged_student AS
(
SELECT 
	student_id,
    MAX(CASE 
		WHEN (engagement_quizzes + engagement_exams + engagement_lessons) > 0 THEN 1 ELSE 0 
	END) AS engaged_student
FROM 
	student_engagement
GROUP BY 
	student_id
)
SELECT
	si.student_id,
    si.date_registered,
    CASE 
		WHEN es.student_id IS NOT NULL THEN 1 ELSE 0
	END AS student_onboarded
FROM 
	student_info si
LEFT JOIN 
	engaged_student es
USING (student_id)
ORDER BY student_id;