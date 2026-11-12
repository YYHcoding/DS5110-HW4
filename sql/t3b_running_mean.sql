-- T3b. Each user's running mean rating, in time order, computed twice.
-- Required columns: user_id, movie_id, timestamp, rating, run_default, run_rows
--   run_default: AVG(rating) OVER (PARTITION BY user_id ORDER BY timestamp)
--   run_rows:    the same, ORDER BY timestamp, movie_id, with an explicit
--                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW frame
--
-- Prediction (commit before running): the two columns disagree on a few rows
-- (no rows / a few rows / many rows), because  some ratings may share the same timestamp within a user. The default RANGE frame includes all peer rows with the same timestamp, whereas the explicit ROWS frame calculates the running average one row at a time.

-- YOUR QUERY HERE
SELECT
    user_id,
    movie_id,
    timestamp,
    rating,

    AVG(rating) OVER (
        PARTITION BY user_id
        ORDER BY timestamp
    ) AS run_default,

    AVG(rating) OVER (
        PARTITION BY user_id
        ORDER BY timestamp, movie_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS run_rows

FROM ratings
ORDER BY user_id, timestamp, movie_id;
