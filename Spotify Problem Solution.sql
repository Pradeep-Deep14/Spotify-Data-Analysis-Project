DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

/*

CLEANING AND DATA ANALYSIS

SELECT * FROM SPOTIFY

SELECT COUNT(*)FROM SPOTIFY


SELECT * FROM SPOTIFY
WHERE duration_min = 0

DELETE FROM SPOTIFY 
WHERE duration_min = 0

*/


--Easy Level Questions
--Q1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT TRACK FROM SPOTIFY
WHERE STREAM > 1000000000
	 
--Q2.List all albums along with their respective artists.

SELECT 
DISTINCT ALBUM,ARTIST 
FROM SPOTIFY
ORDER BY 1
	
--Q3.Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(COMMENTS) AS TOTAL_COMMENTS
FROM SPOTIFY
WHERE LICENSED='true'

--Q4.Find all tracks that belong to the album type single.

SELECT TRACK
FROM SPOTIFY
WHERE ALBUM_TYPE='single'

--Q5. Count the total number of tracks by each artist.

SELECT DISTINCT ARTIST,
	   COUNT(*) AS TOTAL_SONGS
FROM SPOTIFY
GROUP BY 1
ORDER BY 2 


--MEDIUM LEVEL QUESTIONS

--Q6.Calculate the average danceability of tracks in each album.

SELECT 
    ALBUM,
	AVG(DANCEABILITY) AS AVERAGE_DANCEABLILITY
FROM SPOTIFY
GROUP BY 1
ORDER BY 2 DESC

--Q7.Find the top 5 tracks with the highest energy values.

SELECT TRACK,
	   MAX(ENERGY) AS HIGHEST_ENERGY_VALUE
FROM SPOTIFY
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q8.List all tracks along with their views and likes where official_video = TRUE.

SELECT TRACK,
	SUM(VIEWS) AS TOTAL_VIEWS,
	SUM(LIKES) AS TOTAL_LIKES
FROM SPOTIFY
WHERE OFFICIAL_VIDEO= 'true'
GROUP BY 1

--Q9.For each album, calculate the total views of all associated tracks.

SELECT ALBUM,
	   TRACK,
	   SUM(VIEWS) AS TOTAL_VIEWS
FROM SPOTIFY
GROUP BY 1,2
ORDER BY 3 DESC

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(
SELECT track,
      	COALESCE(SUM(CASE WHEN most_played_on='Youtube' THEN stream END),0)  AS STREAMED_ON_YOUTUBE,
 		COALESCE(SUM(CASE WHEN most_played_on='Spotify' THEN stream END),0) AS STREAMED_ON_SPOTIFY   	
FROM SPOTIFY
GROUP BY 1
) AS T1
WHERE STREAMED_ON_SPOTIFY > STR EAMED_ON_YOUTUBE
AND STREAMED_ON_YOUTUBE <> 0

--Q11.Find the top 3 most-viewed tracks for each artist using window functions.

WITH CTE AS
(
SELECT ARTIST,
       TRACK,
	   SUM(VIEWS) AS TOTAL_VIEWS,
       DENSE_RANK()OVER(PARTITION BY ARTIST ORDER BY SUM(VIEWS)DESC )AS DRNK
FROM SPOTIFY
GROUP BY 1,2
)
SELECT * FROM CTE WHERE DRNK <=3

--Q12. Write a query to find tracks where the liveness score is above the average.

SELECT TRACK,
       ARTIST,
       LIVENESS
FROM SPOTIFY
WHERE LIVENESS > (SELECT AVG(LIVENESS) FROM SPOTIFY)

--Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH CTE AS
(
SELECT ALBUM,
       MAX(ENERGY) AS MAX_ENERGY,
       MIN(ENERGY) AS MIN_ENERGY
FROM SPOTIFY
GROUP BY 1
)
SELECT ALBUM,
	   MAX_ENERGY - MIN_ENERGY AS ENERGY_DIFF
FROM CTE
ORDER BY 2 DESC

--Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT
      ENERGY,
      LIVENESS,
	  (ENERGY/LIVENESS) AS RATIO
FROM SPOTIFY
WHERE (ENERGY/LIVENESS) > 1.2

--Q15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
	
WITH CTE AS
(
    SELECT 
        LIKES,
        VIEWS,
        SUM(LIKES) OVER (ORDER BY VIEWS) AS CUMULATIVE_LIKES
    FROM SPOTIFY
)
SELECT * FROM CTE;
