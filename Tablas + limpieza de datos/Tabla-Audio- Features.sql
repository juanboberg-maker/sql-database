CREATE TABLE Audio_Features AS
SELECT DISTINCT track_id, danceability, energy, `key`, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, time_signature
FROM dataset;