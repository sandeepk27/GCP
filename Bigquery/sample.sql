--- distinct count of a column
select count(distinct spotify_track_uri) from tsda-456117.RDL.SPOTIFY

-- 1. Find the top 5 most played tracks
SELECT 
    spotify_track_uri,
    artist_name,
    album_name,
    play_count
FROM 
    tsda-456117.RDL.SPOTIFY
ORDER BY 
    play_count DESC
LIMIT 5;

-- 2. Calculate the average play count per artist
SELECT 
    artist_name,
    AVG(play_count) AS avg_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    avg_play_count DESC;

-- 3. Extract the year from the release date
SELECT 
    spotify_track_uri,
    artist_name,
    album_name,
    EXTRACT(YEAR FROM release_date) AS release_year
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 4. Group tracks by album and calculate total plays
SELECT 
    album_name,
    SUM(play_count) AS total_album_plays
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    album_name
ORDER BY 
    total_album_plays DESC;

-- 5. Find the artist with the highest total play count
SELECT 
    artist_name,
    SUM(play_count) AS total_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    total_play_count DESC
LIMIT 1;

-- 6. Count the number of unique albums in the dataset
SELECT 
    COUNT(DISTINCT album_name) AS unique_album_count
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 7. Find the top 3 albums with the highest average play count per track
SELECT 
    album_name,
    AVG(play_count) AS avg_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    album_name
ORDER BY 
    avg_play_count DESC
LIMIT 3;

-- 8. Identify tracks released in the last 5 years
SELECT 
    spotify_track_uri,
    artist_name,
    album_name,
    release_date
FROM 
    tsda-456117.RDL.SPOTIFY
WHERE 
    EXTRACT(YEAR FROM release_date) >= EXTRACT(YEAR FROM CURRENT_DATE()) - 5;

-- 9. Calculate the percentage of total plays for each artist
SELECT 
    artist_name,
    SUM(play_count) AS artist_play_count,
    ROUND(SUM(play_count) * 100.0 / SUM(SUM(play_count)) OVER (), 2) AS play_percentage
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    play_percentage DESC;

-- 10. Find the most recent track for each artist
SELECT 
    artist_name,
    spotify_track_uri,
    album_name,
    release_date
FROM 
    (
        SELECT 
            artist_name,
            spotify_track_uri,
            album_name,
            release_date,
            ROW_NUMBER() OVER (PARTITION BY artist_name ORDER BY release_date DESC) AS rank
        FROM 
            tsda-456117.RDL.SPOTIFY
    ) ranked_tracks
WHERE 
    rank = 1;

-- 11. Find the total play count for each year
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    SUM(play_count) AS total_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    release_year
ORDER BY 
    release_year DESC;

-- 12. Identify the top 3 artists with the most unique tracks
SELECT 
    artist_name,
    COUNT(DISTINCT spotify_track_uri) AS unique_tracks
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    unique_tracks DESC
LIMIT 3;

-- 13. Calculate the median play count for all tracks
SELECT 
    PERCENTILE_CONT(play_count, 0.5) OVER () AS median_play_count
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 14. Find the album with the longest name
SELECT 
    album_name,
    LENGTH(album_name) AS album_name_length
FROM 
    tsda-456117.RDL.SPOTIFY
ORDER BY 
    album_name_length DESC
LIMIT 1;

-- 15. Identify the most common release year
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    COUNT(*) AS track_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    release_year
ORDER BY 
    track_count DESC
LIMIT 1;

-- 16. Find tracks with play counts above the 90th percentile
SELECT 
    spotify_track_uri,
    artist_name,
    album_name,
    play_count
FROM 
    tsda-456117.RDL.SPOTIFY
WHERE 
    play_count > (
        SELECT 
            PERCENTILE_CONT(play_count, 0.9) OVER ()
        FROM 
            tsda-456117.RDL.SPOTIFY
    )
ORDER BY 
    play_count DESC;

-- 17. Calculate the cumulative play count for each artist
SELECT 
    artist_name,
    play_count,
    SUM(play_count) OVER (PARTITION BY artist_name ORDER BY play_count DESC) AS cumulative_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
ORDER BY 
    artist_name, cumulative_play_count DESC;

-- 18. Find the average play count for tracks released in each month
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    EXTRACT(MONTH FROM release_date) AS release_month,
    AVG(play_count) AS avg_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    release_year, release_month
ORDER BY 
    release_year DESC, release_month DESC;

-- 19. Identify artists with no tracks played (zero play count)
SELECT 
    DISTINCT artist_name
FROM 
    tsda-456117.RDL.SPOTIFY
WHERE 
    play_count = 0;

-- 20. Find the top 5 tracks with the highest play count-to-release-year ratio
SELECT 
    spotify_track_uri,
    artist_name,
    album_name,
    play_count,
    EXTRACT(YEAR FROM release_date) AS release_year,
    play_count / NULLIF(EXTRACT(YEAR FROM CURRENT_DATE()) - EXTRACT(YEAR FROM release_date), 0) AS play_count_ratio
FROM 
    tsda-456117.RDL.SPOTIFY
ORDER BY 
    play_count_ratio DESC
LIMIT 5;

-- 21. Find the total number of tracks for each artist
SELECT 
    artist_name,
    COUNT(spotify_track_uri) AS total_tracks
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    total_tracks DESC;

-- 22. Calculate the standard deviation of play counts for all tracks
SELECT 
    STDDEV(play_count) AS play_count_stddev
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 23. Find the earliest and latest release dates in the dataset
SELECT 
    MIN(release_date) AS earliest_release_date,
    MAX(release_date) AS latest_release_date
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 24. Identify the top 3 artists with the highest average play count per track
SELECT 
    artist_name,
    AVG(play_count) AS avg_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    artist_name
ORDER BY 
    avg_play_count DESC
LIMIT 3;

-- 25. Find the percentage of tracks that have a play count greater than 1000
SELECT 
    ROUND(COUNTIF(play_count > 1000) * 100.0 / COUNT(*), 2) AS percentage_above_1000
FROM 
    tsda-456117.RDL.SPOTIFY;

-- 26. Identify the top 5 albums with the most unique tracks
SELECT 
    album_name,
    COUNT(DISTINCT spotify_track_uri) AS unique_tracks
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    album_name
ORDER BY 
    unique_tracks DESC
LIMIT 5;

-- 27. Calculate the cumulative percentage of total play counts for all tracks
SELECT 
    spotify_track_uri,
    play_count,
    SUM(play_count) OVER (ORDER BY play_count DESC) * 100.0 / SUM(play_count) OVER () AS cumulative_percentage
FROM 
    tsda-456117.RDL.SPOTIFY
ORDER BY 
    play_count DESC;

-- 28. Find the average play count for tracks grouped by decade
SELECT 
    (EXTRACT(YEAR FROM release_date) DIV 10) * 10 AS release_decade,
    AVG(play_count) AS avg_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    release_decade
ORDER BY 
    release_decade;

-- 29. Identify tracks with duplicate names
SELECT 
    album_name,
    COUNT(*) AS duplicate_count
FROM 
    tsda-456117.RDL.SPOTIFY
GROUP BY 
    album_name
HAVING 
    COUNT(*) > 1
ORDER BY 
    duplicate_count DESC;

-- 30. Find the top 5 artists with the highest total play count in the last 3 years
SELECT 
    artist_name,
    SUM(play_count) AS total_play_count
FROM 
    tsda-456117.RDL.SPOTIFY
WHERE 
    EXTRACT(YEAR FROM release_date) >= EXTRACT(YEAR FROM CURRENT_DATE()) - 3
GROUP BY 
    artist_name
ORDER BY 
    total_play_count DESC
LIMIT 5;