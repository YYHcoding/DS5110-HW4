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

(To be completed after running the query.)

### Explanation

(To be completed after running the query.)