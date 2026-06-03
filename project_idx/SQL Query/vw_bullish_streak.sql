CREATE OR REPLACE VIEW vw_bullish_streak AS
	WITH overall_row_num AS (
		SELECT
			*,
            LAG(close) OVER(
				ORDER BY date) AS previous_close,
            ROW_NUMBER() OVER(
				ORDER BY date) AS overall_rn
	FROM project_idx
), bullish_streak_count AS (
	SELECT
		*,
        ROW_NUMBER() OVER(
				ORDER BY date) AS bullish_rn
	FROM overall_row_num
    WHERE close > previous_close
), streak_grouping AS (
	SELECT
		*,
        overall_rn - bullish_rn AS streak_group
	FROM bullish_streak_count
)
	
SELECT
	MIN(date) AS streak_start,
    MAX(date) AS streak_end,
    COUNT(*) AS streak_length
FROM streak_grouping
GROUP BY streak_group
ORDER BY streak_length DESC;