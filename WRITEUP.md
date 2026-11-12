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
## T2 — ROW_NUMBER vs. RANK

### Prediction

**Version 1 — ROW_NUMBER**

I predict approximately 63 rows, assuming there are 21 occupations and each occupation has at least three qualifying movies. `ROW_NUMBER()` assigns a unique position to each movie, so each occupation can contribute at most three rows.
For ROW_NUMBER(), I will order by mean_rating DESC, movie_id ASC to ensure deterministic results when movies have equal mean ratings.

**Version 2 — RANK**

I predict more than 63 rows, assuming at least one occupation has multiple movies tied at the third rank. Unlike `ROW_NUMBER()`, `RANK()` assigns the same position to movies with equal mean ratings, so filtering for `pos <= 3` can include more than three movies per occupation.

### Result

The database contains 21 occupations. The ROW_NUMBER() query returned 27 rows, while the RANK() query returned 28 rows. Both queries passed the runner checks.

My prediction of approximately 63 rows was too high because I assumed that every occupation would have at least three qualifying movies. In reality, 11 occupations had no qualifying movies, and two occupations (executive and technician) had fewer than three qualifying results.

The RANK() query returned one additional row compared with ROW_NUMBER().

### Explanation

I first grouped ratings by occupation and movie, calculated the number of ratings and the mean rating, and retained only groups with at least 20 ratings.

ROW_NUMBER() assigned unique positions within each occupation using mean_rating DESC, movie_id ASC as a deterministic tie-breaker. This limited the result to at most three movies per occupation.

RANK() assigned equal positions to movies with identical mean ratings. Therefore, filtering with pos <= 3 could preserve additional movies when ties occurred.

The results demonstrate that ranking functions behave differently when ties are present. They also show that the number of qualifying groups must be considered before predicting the final row count.

## T3 — Rating Sessions

### Prediction (Before Running)

**Predicted median ratings per session: 1**

I predict that the median number of ratings per session will be 1. A new session begins whenever the gap between two consecutive ratings by the same user exceeds 1,800 seconds (30 minutes).

I expect that many sessions may contain only one rating because users may submit ratings at widely separated times. However, some sessions may contain multiple ratings submitted within a short period.

### Method

I used `LAG(timestamp)` to obtain the previous rating timestamp for each user, ordered by `timestamp` and `movie_id`. A `CASE WHEN` expression marked the first rating and ratings following gaps greater than 1,800 seconds as new sessions.

I then used a running `SUM()` with an explicit `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` frame to assign session numbers. Finally, I grouped the records by `user_id` and `session_no` to calculate session-level statistics.

### Actual Result

The query identified **2,793 sessions**, with a median of **11 ratings per session** and a maximum of **737 ratings in one session**.

A total of **562 users** had only one session, and the median number of sessions per user was **1**.

The automated checks passed.

### Explanation

My prediction of 1 rating per session was incorrect. The actual median was 11, suggesting that users frequently submitted multiple ratings within relatively short periods.

The maximum of 737 ratings in one session further demonstrates that the 30-minute inactivity threshold can group many ratings into a single session.

This exercise shows why assumptions about user activity patterns should be validated against actual timestamp data.

---

## T3b — Running Mean and Window Frames

### Prediction (Before Running)

**Predicted disagreement: A few rows**

I predict that `run_default` and `run_rows` will disagree on a few rows.

The default window frame uses `RANGE` semantics, which include all peer rows sharing the same timestamp within a user. In contrast, the explicit `ROWS` frame calculates the running average one row at a time, using `movie_id` as an additional ordering key.

Therefore, the two running averages may differ when the same user has multiple ratings with identical timestamps. I expect such cases to occur occasionally, rather than in most rows.

### Method

I calculated two running averages using `AVG(rating) OVER`.

The `run_default` calculation partitions by `user_id` and orders by `timestamp`, using SQLite's default window frame.

The `run_rows` calculation partitions by `user_id`, orders by `timestamp` and `movie_id`, and uses an explicit `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` frame.

### Actual Result

The two running averages disagreed on **49,787 rows**, approximately **49.8%** of the 100,000 ratings.

There were **75,772 rows** sharing a timestamp with another rating from the same user. All **49,787 disagreeing rows** belonged to this group.

The final running averages agreed for all **943 users**.

The automated checks passed.

### Explanation

My prediction of only a few disagreements was incorrect because identical timestamps were much more common than I expected.

The default `RANGE` frame includes all rows sharing the same timestamp, while the explicit `ROWS` frame processes records one row at a time according to the specified ordering.

Consequently, intermediate running averages may differ substantially when multiple ratings share a timestamp.

However, the final running averages agree for all users because both methods eventually include every rating belonging to that user.

This demonstrates that choosing the correct window frame is important when calculating cumulative statistics, especially when the ordering column contains duplicate values.