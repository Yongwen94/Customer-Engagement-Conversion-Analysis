USE customer_engagement;  -- call database

SELECT
	certificate_id,
	student_id,
	certificate_type,
	date_issued,
	MAX(CASE 
		WHEN date_issued BETWEEN date_start AND date_end THEN 1
        ELSE 0
	END) AS paid
FROM 
	student_certificates
LEFT JOIN 
	purchases_info
USING (student_id)
GROUP BY 
	certificate_id
ORDER BY certificate_id;