CREATE OR REPLACE VIEW vw_crisis_intensity AS
		WITH crisis_intensity_def AS (
		SELECT
			date,
			crisis_score_identifier,
			drawdown_flag,
			volatility_flag, 
			volume_flag,
			gap_down_flag,
			SUM(crisis_score_identifier) OVER (
				ORDER BY date
				ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
			) AS rolling_crisis_intensity
		FROM vw_composite_score
	), crisis_intensity_ntile AS (
		SELECT
			*,
			ROUND(NTILE(100) OVER (
				ORDER BY rolling_crisis_intensity
			) / 100, 2) AS pct_ranked
		FROM crisis_intensity_def
	)

	SELECT
		*,
		CASE
			WHEN pct_ranked >= 0.9 THEN 'Crisis'
			WHEN pct_ranked >= 0.6 THEN 'Stress'
			WHEN pct_ranked >= 0.3 THEN 'Caution'
			ELSE 'Normal'
		END AS market_status
	FROM crisis_intensity_ntile
	ORDER BY date