CREATE OR REPLACE VIEW vw_composite_score AS
SELECT
	d.date,
    d.drawdown_pct,
    d.drawdown_flag,
    v.volatility_pct,
    v.volatility_flag,
    t.trading_ratio,
    t.volume_flag,
    g.gap_pct,
    g.gap_down_flag,
    d.drawdown_flag + v.volatility_flag +
    t.volume_flag + g.gap_down_flag AS crisis_score_identifier
FROM vw_drawdown_analysis	d
JOIN vw_volatility_index	v USING (date)
JOIN vw_trade_volume_flag	t USING (date)
JOIN vw_gap_analysis		g USING (date);