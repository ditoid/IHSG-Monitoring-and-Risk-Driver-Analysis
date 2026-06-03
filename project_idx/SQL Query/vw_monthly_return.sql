CREATE OR REPLACE VIEW vw_monthly_return AS
	WITH monthly_first_and_last_day AS (
		SELECT
			*,
            ROW_NUMBER() OVER(
				PARTITION BY YEAR(date), MONTH(date)
                ORDER BY DAY(date)) AS daily_rn_asc,
			ROW_NUMBER() OVER(
				PARTITION BY YEAR(date), MONTH(date)
                ORDER BY DAY(date) DESC) AS daily_rn_desc
		FROM project_idx
)

SELECT
	YEAR(date) AS year_num,
    MONTH(date) AS month_num,
    SUM(CASE WHEN daily_rn_asc = 1 THEN close END) AS first_day_close_value,
	SUM(CASE WHEN daily_rn_desc = 1 THEN close END) AS last_day_close_value,
    SUM(CASE WHEN daily_rn_desc = 1 THEN close END) -  SUM(CASE WHEN daily_rn_asc = 1 THEN close END) AS monthly_return_value
FROM monthly_first_and_last_day
GROUP BY
	YEAR(date),  MONTH(date)