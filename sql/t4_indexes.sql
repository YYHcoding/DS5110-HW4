-- T4. At most TWO CREATE INDEX statements, chosen for the four app queries
-- in run.py (A_profile, B_movie_page, C_recent, D_month). run.py applies them to a
-- copy of the database and measures plans, time and size before and after.
--
-- Prediction (commit before running), for each app query:
-- A_profile:
--   plan before: SCAN ratings
--   plan after: SEARCH ratings USING INDEX idx_ratings_user_time
--
-- B_movie_page:
--   plan before: SCAN ratings
--   plan after: SCAN ratings
--
-- C_recent:
--   plan before: SCAN ratings
--   plan after: SEARCH ratings USING COVERING INDEX idx_ratings_timestamp
--
-- D_month:
--   plan before: SCAN ratings
--   plan after: SCAN ratings

-- YOUR INDEXES HERE

CREATE INDEX idx_ratings_timestamp
ON ratings(timestamp);
