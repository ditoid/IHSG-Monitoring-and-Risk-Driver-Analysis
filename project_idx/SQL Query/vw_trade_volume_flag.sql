CREATE OR REPLACE VIEW vw_trade_volume_flag AS 
	WITH volume_mvg_avg AS (
		SELECT
        date,
        close,
        volume,
        ROUND(AVG(volume) OVER(
			ORDER BY date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), 2) AS rolling_vol_avg
	FROM project_idx
), volume_trading_ratio AS (
	SELECT
		*,
        ROUND(volume / rolling_vol_avg, 2) AS trading_ratio,
        LAG(close) OVER(
			ORDER BY date) AS prev_trade_volume
	FROM volume_mvg_avg
)

SELECT
	date,
    volume,
    rolling_vol_avg,
	trading_ratio,
    CASE
		WHEN trading_ratio > 1.5
        AND close < prev_trade_volume THEN 1
        ELSE 0
	END AS volume_flag
FROM volume_trading_ratio