-- T2 (version 2, RANK). The same question, with RANK() ordered by mean_rating
-- only, keeping rows with pos <= 3.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
--
-- Prediction (commit before running): more rows, which is (more / the same / fewer)
-- than version 1, because assuming at least one occupation has multiple movies tied at the third rank. Unlike ROW_NUMBER(), RANK() assigns the same position to movies with equal mean ratings, so filtering for pos <= 3 can include more than three movies per occupation..

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
        RANK() OVER (
    PARTITION BY occupation
    ORDER BY mean_rating DESC
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
ORDER BY rm.occupation, rm.pos, rm.movie_id;
