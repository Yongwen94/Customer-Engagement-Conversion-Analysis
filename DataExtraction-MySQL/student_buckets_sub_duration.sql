USE customer_engagement;  -- call database

-- start date and end date for students with subscription
WITH student_sub_duration AS 
(
SELECT
	si.student_id,
    si.date_registered,
    MIN(pi.date_start) AS date_start,
    IF(MAX(pi.date_end)>'2022-10-31','2022-10-31',MAX(pi.date_end))  AS date_end,
    DATEDIFF(IF(MAX(pi.date_end)>'2022-10-31','2022-10-31',MAX(pi.date_end)), MIN(pi.date_start)  ) AS num_paid_days
FROM 
	student_info si
LEFT JOIN 
	purchases_info pi
USING (student_id)
WHERE 
	pi.purchase_type IS NOT NULL
GROUP BY 
	si.student_id
ORDER BY 
	si.student_id
),
minutes_watched AS
(
SELECT
	ssd.student_id,
    ssd.date_registered,
    COALESCE(ROUND(SUM(
		CASE WHEN date_watched BETWEEN date_start AND date_end THEN minutes_watched ELSE 0 END
	),2),0) AS total_minutes_watched,
     ssd.num_paid_days
FROM 	
	student_sub_duration ssd
LEFT JOIN 
	student_learning sl
USING (student_id)
GROUP BY 
	ssd.student_id,
    ssd.date_registered,
    ssd.num_paid_days
)    
    
SELECT 
	minutes_watched.*,
    CASE
		WHEN total_minutes_watched = 0 THEN '[0]'
        WHEN total_minutes_watched>0 AND total_minutes_watched<=30 THEN '(0, 30]'
        WHEN total_minutes_watched>30 AND total_minutes_watched<=60 THEN '(30, 60]'
        WHEN total_minutes_watched>60 AND total_minutes_watched<=120 THEN '(60, 120]'
        WHEN total_minutes_watched>120 AND total_minutes_watched<=240 THEN '(120, 240]'
        WHEN total_minutes_watched>240 AND total_minutes_watched<=480 THEN '(240, 480]'
        WHEN total_minutes_watched>480 AND total_minutes_watched<=1000 THEN '(480, 1000]'
        WHEN total_minutes_watched>1000 AND total_minutes_watched<=2000 THEN '(1000, 2000]'
        WHEN total_minutes_watched>2000 AND total_minutes_watched<=3000 THEN '(2000, 3000]'
        WHEN total_minutes_watched>3000 AND total_minutes_watched<=4000 THEN '(3000, 4000]'
        WHEN total_minutes_watched>4000 AND total_minutes_watched<=6000 THEN '(4000, 6000]'
        ELSE '6000+'
	END AS buckets
FROM  
	minutes_watched
ORDER BY 
	student_id

	

    
	
