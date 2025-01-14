USE customer_engagement; -- call dataset

-- minutes watched by each student
-- students with purchase: sum of minutes watched before purchase date
-- students without purchase: sum of minutes watched
WITH total_minutes_learned AS
(
SELECT 
	DISTINCT sl.student_id,
	COALESCE(ROUND(SUM(
    CASE 
	WHEN sp.purchase_id IS NULL THEN sl.minutes_watched
	WHEN sl.date_watched <= sp.date_purchased  THEN sl.minutes_watched ELSE 0 
	END),2),0) AS total_minutes_learned
FROM 
	student_learning sl
LEFT JOIN 
	student_purchases sp
USING (student_id)
GROUP BY 
	sl.student_id
)
SELECT
DISTINCT si.student_id,   -- a student may purchase multiple times, request distinct student 
    si.date_registered,
    IF(sp.purchase_type IS NULL, 0, 1) AS f2p,
    COALESCE(tl.total_minutes_learned,0) AS total_minutes_watched,
	CASE 
    WHEN COALESCE(tl.total_minutes_learned,0) = 0 THEN '[0]'
    WHEN COALESCE(tl.total_minutes_learned,0)>0 AND COALESCE(tl.total_minutes_learned,0)<=5 THEN '(0, 5]'
    WHEN COALESCE(tl.total_minutes_learned,0)>5 AND COALESCE(tl.total_minutes_learned,0)<=10 THEN '(5, 10]'
    WHEN COALESCE(tl.total_minutes_learned,0)>10 AND COALESCE(tl.total_minutes_learned,0)<=15 THEN '(10, 15]'
    WHEN COALESCE(tl.total_minutes_learned,0)>15 AND COALESCE(tl.total_minutes_learned,0)<=20 THEN '(15, 20]'
    WHEN COALESCE(tl.total_minutes_learned,0)>20 AND COALESCE(tl.total_minutes_learned,0)<=25 THEN '(20, 25]'
    WHEN COALESCE(tl.total_minutes_learned,0)>25 AND COALESCE(tl.total_minutes_learned,0)<=30 THEN '(25, 30]'
    WHEN COALESCE(tl.total_minutes_learned,0)>30 AND COALESCE(tl.total_minutes_learned,0)<=40 THEN '(30, 40]'
    WHEN COALESCE(tl.total_minutes_learned,0)>40 AND COALESCE(tl.total_minutes_learned,0)<=50 THEN '(40, 50]'
    WHEN COALESCE(tl.total_minutes_learned,0)>50 AND COALESCE(tl.total_minutes_learned,0)<=60 THEN '(50, 60]'
    WHEN COALESCE(tl.total_minutes_learned,0)>60 AND COALESCE(tl.total_minutes_learned,0)<=70 THEN '(60, 70]'
    WHEN COALESCE(tl.total_minutes_learned,0)>70 AND COALESCE(tl.total_minutes_learned,0)<=80 THEN '(70, 80]'
    WHEN COALESCE(tl.total_minutes_learned,0)>80 AND COALESCE(tl.total_minutes_learned,0)<=90 THEN '(80, 90]'
    WHEN COALESCE(tl.total_minutes_learned,0)>90 AND COALESCE(tl.total_minutes_learned,0)<=100 THEN '(90, 100]'
    WHEN COALESCE(tl.total_minutes_learned,0)>100 AND COALESCE(tl.total_minutes_learned,0)<=110 THEN '(100, 110]'
    WHEN COALESCE(tl.total_minutes_learned,0)>110 AND COALESCE(tl.total_minutes_learned,0)<=120 THEN '(110, 120]'
    WHEN COALESCE(tl.total_minutes_learned,0)>120 AND COALESCE(tl.total_minutes_learned,0)<=240 THEN '(120, 240]'
    WHEN COALESCE(tl.total_minutes_learned,0)>240 AND COALESCE(tl.total_minutes_learned,0)<=480 THEN '(240, 480]'
    WHEN COALESCE(tl.total_minutes_learned,0)>480 AND COALESCE(tl.total_minutes_learned,0)<=1000 THEN '(480, 1000]'
    WHEN COALESCE(tl.total_minutes_learned,0)>1000 AND COALESCE(tl.total_minutes_learned,0)<=2000 THEN '(1000, 2000]'
    WHEN COALESCE(tl.total_minutes_learned,0)>2000 AND COALESCE(tl.total_minutes_learned,0)<=3000 THEN '(2000, 3000]'
    WHEN COALESCE(tl.total_minutes_learned,0)>3000 AND COALESCE(tl.total_minutes_learned,0)<=4000 THEN '(3000, 4000]'
    WHEN COALESCE(tl.total_minutes_learned,0)>4000 AND COALESCE(tl.total_minutes_learned,0)<=6000 THEN '(4000, 6000]'
    ELSE  '6000+'
	END AS buckets
FROM 
	student_info si
LEFT JOIN 
	student_purchases sp
USING (student_id)
LEFT JOIN 
	total_minutes_learned tl
USING (student_id)
ORDER BY si.student_id;








