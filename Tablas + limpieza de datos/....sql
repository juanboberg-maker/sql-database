CREATE DATABASE IF NOT EXISTS spotify_db;
USE spotify_db;
CREATE TABLE IF NOT EXISTS Tracks (
    track_id VARCHAR(255) PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),
    popularity INT,
    duration_ms INT,
    explicit BOOLEAN,
    track_genre VARCHAR(100)
);