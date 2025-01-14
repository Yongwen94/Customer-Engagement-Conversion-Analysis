USE customer_engagement; -- call dataset

SELECT 
	course_id,
    course_title,
    ROUND(SUM(s.minutes_watched),2) AS minutes_watched,
    ROUND(SUM(s.minutes_watched) / COUNT(DISTINCT s.student_id),2) AS minutes_per_student,
    ROUND((SUM(s.minutes_watched) / COUNT(DISTINCT s.student_id)) / c.course_duration,2) AS completion_rate
FROM 
	course_info c
LEFT JOIN 
	student_learning s
USING (course_id)
WHERE 
	minutes_watched != 0
GROUP BY 
	course_id
ORDER BY 
	course_id;


    
    
    
