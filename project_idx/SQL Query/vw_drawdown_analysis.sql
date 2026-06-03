CREATE OR REPLACE VIEW vw_drawdown_analysis AS
	WITH peak_value_def AS (
		SELECT
			date,
            close,
			MAX(close) OVER(
				ORDER BY date) AS peak_value
		FROM project_idx
), drawdown_pct_def AS (
	SELECT
		*,
        ROUND((close - peak_value) /
		peak_value * 100, 2) AS drawdown_pct
	FROM peak_value_def
)

SELECT
	date,
    peak_value,
    drawdown_pct,
    CASE
		WHEN drawdown_pct < -30.0 THEN 'massive'
        WHEN drawdown_pct < -20.0 THEN 'deep'
        WHEN drawdown_pct < -10.0 THEN 'correction'
		ELSE 'normal'
	END AS drawdown_level,
	CASE
		WHEN (close - peak_value) / peak_value * 100 < -10.0
		THEN 1 ELSE 0 
	END AS drawdown_flag
FROM drawdown_pct_def