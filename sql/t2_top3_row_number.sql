-- T2 (version 1, ROW_NUMBER). The three highest-rated movies for each
-- occupation, among movies rated at least 20 times by users with that occupation.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
-- Order the window so that the result is the same on every run (state your
-- tie-breaker in WRITEUP.md).
--
-- Prediction (commit before running): 63 rows.assuming there are 21 occupations and each occupation has at least three qualifying movies. ROW_NUMBER() assigns a unique position to each movie, so each occupation can contribute at most three rows.

-- YOUR QUERY HERE
