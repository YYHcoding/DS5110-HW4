# DS5110 Homework 4 — Writeup

## T1(a) — Rating in Context

### Prediction
I expect 100,000 rows because window functions
keep all original rating records.

### Result
The query returned 100,000 rows, matching my prediction. Each row contains the original rating together with the corresponding user's mean rating and movie's mean rating.


### Explanation
Window functions calculate aggregate values without collapsing individual rows. PARTITION BY user_id calculates the mean rating for each user, while PARTITION BY movie_id calculates the mean rating for each movie. Unlike GROUP BY, both window functions preserve the original 100,000 rating records.

## T1(b) — Ratings Above Both Means

### Prediction

I predict that fewer than 50,000 ratings, or less than 50% of the total 100,000 ratings, will be above both the user mean and the movie mean.

This is because each rating must satisfy two conditions simultaneously: it must be higher than the user's average rating and the movie's average rating.

For movies with at least 20 ratings, I predict that the share will also be below 50%, although it may differ from the overall share.

### Result

The query returned an above_both_count of 45,232 and an above_both_share of 0.45232 (45.232%). For movies with at least 20 ratings, the share was approximately 0.46041 (46.041%).The total number of ratings was 100,000, and the query passed the T1 runner check after matching the required output column names.

All three results were consistent with my prediction that the shares would be below 50%.

### Explanation

I used window functions to calculate the mean rating for each user, the mean rating for each movie, and the number of ratings per movie.

A CASE WHEN expression identified ratings above both means. SUM() counted the qualifying ratings, while AVG() calculated their share.

For movies with at least 20 ratings, I used conditional aggregation with NULL values to exclude movies with fewer ratings from the denominator.

The share for movies with at least 20 ratings was slightly higher than the overall share, by approximately 0.81 percentage points.

## T1(c) — Window Function Rewrite

### Prediction

I predict that the window-function rewrite will return the same rows and values as the original CTE query.

Both queries calculate the mean rating for movies with at least 30 ratings, then compare each movie's mean with the mean of qualifying movie means within its genre. The rewritten query uses `AVG(movie_mean) OVER (PARTITION BY genre_id)` instead of a separate grouped CTE and join.

### Result

The original CTE query returned 269 rows, and the window-function rewrite also returned 269 rows. After sorting both result sets, the comparison returned True, confirming that the two queries produced identical results for this dataset.

### Explanation

The original query uses a separate genre_means CTE with GROUP BY and then joins the genre averages back to individual movies.

The rewritten query replaces this step with AVG(movie_mean) OVER (PARTITION BY genre_id), which calculates each genre's mean while preserving the movie-level rows.

Both queries first restrict the data to movies with at least 30 ratings and then select movies whose mean rating is at least 0.5 higher than their genre mean.

The window-function approach eliminates the separate genre aggregation and join while preserving the original calculation.