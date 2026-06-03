CREATE OR REPLACE VIEW vw_yearly_return AS
	WITH first_and_last_day_yearly AS (
		SELECT
			*,
            ROW_NUMBER() OVER (
				PARTITION BY YEAR(date)
                ORDER BY date) AS yearly_rn_asc,
			ROW_NUMBER() OVER (
				PARTITION BY YEAR(date)
                ORDER BY date DESC) AS yearly_rn_desc
		FROM project_idx
)

SELECT
	YEAR(date),
	SUM(CASE WHEN yearly_rn_asc = 1 THEN close END) AS first_day_yearly,
    SUM(CASE WHEN yearly_rn_desc = 1 THEN close END) AS last_day_yearly,
    SUM(CASE WHEN yearly_rn_desc = 1 THEN close END) -
    SUM(CASE WHEN yearly_rn_asc = 1 THEN close END) AS yearly_return_value
FROM first_and_last_day_yearly
GROUP BY
	YEAR(date)