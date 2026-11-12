-- T2 (version 2, RANK). The same question, with RANK() ordered by mean_rating
-- only, keeping rows with pos <= 3.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
--
-- Prediction (commit before running): more rows, which is (more / the same / fewer)
-- than version 1, because assuming at least one occupation has multiple movies tied at the third rank. Unlike ROW_NUMBER(), RANK() assigns the same position to movies with equal mean ratings, so filtering for pos <= 3 can include more than three movies per occupation..

-- YOUR QUERY HERE
