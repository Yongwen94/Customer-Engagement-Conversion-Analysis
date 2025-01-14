USE customer_engagement;  -- call database

SELECT 
	sl.student_id,
    sl.date_watched,
    ROUND(SUM(sl.minutes_watched),2) AS minutes_watched,
    MAX(CASE
		WHEN date_watched BETWEEN date_start AND date_end THEN 1 ELSE 0 
        END) AS paid
FROM 
	student_learning sl
LEFT JOIN 
	purchases_info pi
USING (student_id)
GROUP BY student_id, date_watched;