-- T2 (version 1, ROW_NUMBER). The three highest-rated movies for each
-- occupation, among movies rated at least 20 times by users with that occupation.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
-- Order the window so that the result is the same on every run (state your
-- tie-breaker in WRITEUP.md).
--
-- Prediction (commit before running): 63 rows.assuming there are 21 occupations and each occupation has at least three qualifying movies. ROW_NUMBER() assigns a unique position to each movie, so each occupation can contribute at most three rows.

-- YOUR QUERY HERE
WITH movie_stats AS (
    SELECT
        u.occupation,
        r.movie_id,
        COUNT(*) AS n,
        AVG(r.rating) AS mean_rating
    FROM ratings AS r
    JOIN users AS u
        ON r.user_id = u.user_id
    GROUP BY u.occupation, r.movie_id
    HAVING COUNT(*) >= 20
),
ranked_movies AS (
    SELECT
        occupation,
        movie_id,
        n,
        mean_rating,
        ROW_NUMBER() OVER (
            PARTITION BY occupation
            ORDER BY mean_rating DESC, movie_id ASC
        ) AS pos
    FROM movie_stats
)
SELECT
    rm.occupation,
    rm.pos,
    rm.movie_id,
    m.title,
    rm.n,
    rm.mean_rating
FROM ranked_movies AS rm
JOIN movies AS m
    ON rm.movie_id = m.movie_id
WHERE rm.pos <= 3
ORDER BY rm.occupation, rm.pos;
