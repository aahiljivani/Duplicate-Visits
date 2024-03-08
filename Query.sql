WITH base_table AS (
	SELECT
		Visits.id AS visit_id, DATE_TRUNC('minute',
			CONVERT_TIMEZONE (buildings.preferred_timezone,
				visits.start)) AS start_date,
		DATE_TRUNC('minute',
			CONVERT_TIMEZONE (buildings.preferred_timezone,
				visits.end)) AS end_date,
				beacon_pings.user_id AS user_id,
		restrooms.location AS restroom_location,
		MAX(beacon_pings.signal_strength) AS max_signal_reading,
		LAG(end_date,
			1) OVER (PARTITION BY beacon_pings.user_id ORDER BY start_date) AS lag_end,
		DATEDIFF('minute',
		start_date,
		lag_end) AS time_interval
	FROM
		mero.visits
		JOIN mero.beacon_pings ON visits.id = beacon_pings.visit_id
		JOIN mero.restrooms ON visits.restroom_id = restrooms.id
		JOIN mero.floors ON restrooms.floor_id = floors.id
		JOIN mero.buildings ON floors.building_id = buildings.id
	WHERE
		buildings.id = 191
		AND CONVERT_TIMEZONE ('UTC',
		buildings.preferred_timezone,
		visits.created_at) BETWEEN '2023-03-13'
	AND '2023-03-14'
GROUP BY
	1,
	2,
	3,
	4,
	5
	 ORDER BY
		3,
		2
),
 duplicate_table AS (SELECT
	visit_id, user_id, start_date, end_date,lag_end, restroom_location, max_signal_reading, time_interval, CASE WHEN time_interval > -1 THEN LAG(visit_id) OVER(PARTITION BY user_id ORDER BY start_date) ELSE NULL END AS duplicate_record   
FROM
	base_table),
	
	not_null_table AS (SELECT * FROM duplicate_table
	WHERE duplicate_record IS NOT NULL),
	union_table AS 
	(
	SELECT visit_id AS visits_id
	FROM not_null_table
	UNION
	SELECT duplicate_record
	FROM not_null_table
)
SELECT
u.visits_id, start_date, end_date, user_id, restroom_location, max_signal_reading
FROM base_table
JOIN union_table AS u ON base_table.visit_id = u.visits_id
ORDER BY user_id, start_date
