CREATE OR REPLACE VIEW vw_gap_analysis AS
    WITH gap_pct_def AS (
        SELECT
            date,
            open,
            close,
            ROUND(
                (open - LAG(close) OVER (ORDER BY date))
                / LAG(close) OVER (ORDER BY date) * 100
            , 2) AS gap_pct
        FROM project_idx
    ),
    gap_flagging AS (
        SELECT
            *,
            CASE WHEN gap_pct < -0.2 THEN 1 ELSE 0 END AS is_gap_down,
            CASE WHEN gap_pct >  0.2 THEN 1 ELSE 0 END AS is_gap_up,
            ROW_NUMBER() OVER (ORDER BY date)
            - ROW_NUMBER() OVER (PARTITION BY 
                CASE WHEN gap_pct < -0.2 THEN 1 ELSE 0 END 
              ORDER BY date) AS streak_group
        FROM gap_pct_def
    ),
    gap_streak AS (
        SELECT
            *,
            COUNT(*) OVER (
                PARTITION BY streak_group, is_gap_down
                ORDER BY date
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS gap_down_streak
        FROM gap_flagging
    )
    SELECT
        date,
        gap_pct,
        is_gap_down,
        gap_down_streak,
        CASE
            WHEN is_gap_down = 1
                AND gap_down_streak >= 4
                THEN 1
            ELSE 0
        END AS gap_down_flag
    FROM gap_streak;