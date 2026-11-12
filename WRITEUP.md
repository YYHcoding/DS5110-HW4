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

The query returned an above_both_count of 45,232 and an above_both_share of 0.45232 (45.232%). For movies with at least 20 ratings, the share was approximately 0.46041 (46.041%).

All three results were consistent with my prediction that the shares would be below 50%.

### Explanation

I used window functions to calculate the mean rating for each user, the mean rating for each movie, and the number of ratings per movie.

A CASE WHEN expression identified ratings above both means. SUM() counted the qualifying ratings, while AVG() calculated their share.

For movies with at least 20 ratings, I used conditional aggregation with NULL values to exclude movies with fewer ratings from the denominator.

The share for movies with at least 20 ratings was slightly higher than the overall share, by approximately 0.81 percentage points.