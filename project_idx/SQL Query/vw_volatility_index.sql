CREATE OR REPLACE VIEW vw_volatility_index AS
	WITH volatility_pct_def AS(
		SELECT
			date,
			high,
			low,
            close,
			open,
			ROUND((high - low) /
			open * 100, 2) AS volatility_pct
		FROM project_idx
), volatility_moving_avg_def AS (
	SELECT
		*,
        ROUND(AVG(volatility_pct) OVER (
			ORDER BY date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), 2) AS volatility_pct_moving_avg
	FROM volatility_pct_def
)

SELECT
	date,
	volatility_pct,
    volatility_pct_moving_avg,
    CASE
		WHEN volatility_pct > 1.5 * volatility_pct_moving_avg
			AND volatility_pct >= 1.5
			THEN 1 ELSE 0
	END AS volatility_flag
FROM volatility_moving_avg_def