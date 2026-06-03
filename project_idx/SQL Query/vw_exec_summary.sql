CREATE OR REPLACE VIEW vw_exec_summary AS
	WITH pct_rank_conversion AS (
		SELECT
			c.date,
			p.close,
			c.market_status,
			c.pct_ranked,
			v.drawdown_pct,
			v.volatility_pct,
            v.trading_ratio,
            v.gap_pct,
            ROUND(PERCENT_RANK() OVER (
				ORDER BY v.drawdown_pct ASC), 2) AS drawdown_pct_rank,
			ROUND(PERCENT_RANK() OVER (
				ORDER BY v.volatility_pct), 2) AS volatility_pct_rank,
			ROUND(PERCENT_RANK() OVER (
				ORDER BY v.trading_ratio), 2) AS trading_ratio_rank,
			ROUND(PERCENT_RANK() OVER (
				ORDER BY ABS(v.gap_pct)), 2) AS gap_pct_rank
		FROM vw_crisis_intensity c
        JOIN vw_composite_score v USING (date)
        JOIN project_idx p USING (date)
)

SELECT
	*
FROM pct_rank_conversion
ORDER BY date