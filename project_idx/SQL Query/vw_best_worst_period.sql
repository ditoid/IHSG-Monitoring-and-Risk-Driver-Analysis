CREATE OR REPLACE VIEW vw_best_worst_period AS
	WITH first_and_last_day_rn AS (
		SELECT
			*,
            ROW_NUMBER() OVER(
				PARTITION BY YEAR(date), MONTH(date)
                ORDER BY DAY(date)) AS daily_rn_asc,
			ROW_NUMBER() OVER(
				PARTITION BY YEAR(date), MONTH(date)
                ORDER BY DAY(date) DESC) AS daily_rn_desc
		FROM project_idx
), first_and_last_close AS (
	SELECT
		YEAR(date) AS year_num,
        MONTH(date) AS month_num,
        SUM(CASE WHEN daily_rn_asc = 1 THEN close ELSE null END) AS asc_close_value,
        SUM(CASE WHEN daily_rn_desc = 1 THEN close ELSE null END) AS desc_close_value
	FROM first_and_last_day_rn
    GROUP BY
		YEAR(date), MONTH(date)
), monthly_return_value AS (
	SELECT
		year_num,
        month_num,
        asc_close_value,
        desc_close_value,
        ROUND((desc_close_value - asc_close_value) /
		asc_close_value, 3) AS monthly_return
    FROM first_and_last_close
)

SELECT
	year_num,
    month_num,
    monthly_return,
    RANK() OVER(
        ORDER BY monthly_return DESC) AS return_monthly_rank
FROM monthly_return_value