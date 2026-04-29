-- =====================================================
-- PROYECTO SQL IRONHACK - SCRIPT COMPLETO CORREGIDO
-- Juan Boberg Aguirre - Data Analytics Bootcamp
-- Dataset Spotify → 6 tablas + análisis + exportación
-- Fecha: 29/04/2026
-- =====================================================

-- =====================================================
-- 0. CONFIGURACIÓN INICIAL
-- =====================================================
SET GLOBAL local_infile = 1;
SET SESSION sql_log_bin = 0;

-- Verificar configuración
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';

USE tu_base_de_datos;  -- CAMBIA POR TU BASE DE DATOS

-- =====================================================
-- 1. LIMPIEZA PREVIA (evita errores "table exists")
-- =====================================================
DROP TABLE IF EXISTS Audio_Analysis, Audio_Features, albums, genre, dataset;

-- =====================================================
-- 2. TABLA PRINCIPAL: dataset (desde CSV)
-- =====================================================
CREATE TABLE dataset (
    track_id VARCHAR(255),
    track_name VARCHAR(255),
    artists VARCHAR(255),
    album_name VARCHAR(255),
    danceability DECIMAL(5,4),
    energy DECIMAL(5,4),
    `key` INT,
    loudness DECIMAL(6,3),
    mode INT,
    speechiness DECIMAL(5,4),
    acousticness DECIMAL(5,4),
    instrumentalness DECIMAL(6,5),
    liveness DECIMAL(5,4),
    valence DECIMAL(5,4),
    tempo DECIMAL(7,3),
    time_signature INT,
    popularity INT,
    duration_ms INT,
    track_genre VARCHAR(255)
);

-- IMPORTAR CSV (AJUSTA LA RUTA EXACTA)
LOAD DATA LOCAL INFILE 'C:/Users/juanb/Desktop/IronHack/SQL/Proyecto SQL/dataset.csv'
INTO TABLE dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, track_name, artists, album_name, danceability, energy, `key`, loudness, mode, 
 speechiness, acousticness, instrumentalness, liveness, valence, tempo, time_signature, 
 popularity, duration_ms, track_genre);

-- =====================================================
-- 3. TABLA Audio_Features (datos únicos de audio)
-- =====================================================
CREATE TABLE Audio_Features (
    track_id VARCHAR(255) PRIMARY KEY,
    danceability DECIMAL(5,4) NOT NULL,
    energy DECIMAL(5,4) NOT NULL,
    `key` INT,
    loudness DECIMAL(6,3),
    mode INT,
    speechiness DECIMAL(5,4),
    acousticness DECIMAL(5,4),
    instrumentalness DECIMAL(6,5),
    liveness DECIMAL(5,4),
    valence DECIMAL(5,4),
    tempo DECIMAL(7,3),
    time_signature INT
);

INSERT INTO Audio_Features
SELECT DISTINCT
    track_id, danceability, energy, `key`, loudness, mode, speechiness,
    acousticness, instrumentalness, liveness, valence, tempo, time_signature
FROM dataset
WHERE track_id IS NOT NULL AND track_id <> '';

-- =====================================================
-- 4. TABLA Audio_Analysis (métricas derivadas)
-- =====================================================
CREATE TABLE Audio_Analysis (
    track_id VARCHAR(255) PRIMARY KEY,
    dance_energy_sum DECIMAL(6,4) NOT NULL,
    dance_energy_avg DECIMAL(5,4) NOT NULL,
    is_dance_track BOOLEAN,
    is_energy_high BOOLEAN,
    tempo_category VARCHAR(50),
    total_features_score DECIMAL(6,4),
    energy_efficiency DECIMAL(5,4)  -- Nueva métrica: valence/energy
);

INSERT INTO Audio_Analysis
SELECT
    track_id,
    (danceability + energy) AS dance_energy_sum,
    ((danceability + energy) / 2) AS dance_energy_avg,
    (danceability + energy > 1.2) AS is_dance_track,
    (energy > 0.7) AS is_energy_high,
    CASE
        WHEN tempo < 90 THEN 'Lento'
        WHEN tempo < 120 THEN 'Medio'
        WHEN tempo < 140 THEN 'Rápido'
        ELSE 'Muy Rápido'
    END AS tempo_category,
    (danceability + energy + valence) AS total_features_score,
    (valence / NULLIF(energy, 0)) AS energy_efficiency
FROM Audio_Features;

-- =====================================================
-- 5. TABLA albums (metadatos de álbumes)
-- =====================================================
CREATE TABLE albums (
    track_id VARCHAR(255) PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),
    artists VARCHAR(255),
    popularity INT
);

INSERT INTO albums
SELECT 
    track_id, track_name, album_name, artists, popularity
FROM dataset
WHERE track_id IS NOT NULL 
  AND popularity IS NOT NULL
  AND track_id NOT IN (SELECT track_id FROM Audio_Features);

-- =====================================================
-- 6. TABLA genre (clasificación por géneros)
-- =====================================================
CREATE TABLE genre (
    track_id VARCHAR(255) PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    track_genre VARCHAR(255),
    genre_category VARCHAR(50)
);

INSERT INTO genre
SELECT 
    track_id,
    track_name,
    track_genre,
    CASE 
        WHEN track_genre LIKE '%pop%' OR track_genre LIKE '%Pop%' THEN 'Pop'
        WHEN track_genre LIKE '%rock%' OR track_genre LIKE '%Rock%' THEN 'Rock'
        WHEN track_genre LIKE '%hip hop%' OR track_genre LIKE '%rap%' THEN 'Hip-Hop'
        WHEN track_genre LIKE '%electronic%' OR track_genre LIKE '%edm%' THEN 'Electronic'
        WHEN track_genre LIKE '%latin%' THEN 'Latin'
        ELSE 'Other'
    END AS genre_category
FROM dataset
WHERE track_genre IS NOT NULL AND track_genre <> '';

-- =====================================================
-- 7. VERIFICACIÓN DE TABLAS (UNION ALL corregido)
-- =====================================================
SELECT 
    'dataset' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(popularity), 1) AS avg_popularity,
    COUNT(DISTINCT artists) AS distinct_artists
FROM dataset

UNION ALL

SELECT 
    'Audio_Features' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(tempo), 1) AS avg_tempo,
    SUM(is_dance_track) AS dance_tracks
FROM Audio_Analysis aa JOIN Audio_Features af ON aa.track_id = af.track_id

UNION ALL

SELECT 
    'Audio_Analysis' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(total_features_score), 2) AS avg_score,
    SUM(is_energy_high) AS high_energy_tracks
FROM Audio_Analysis

UNION ALL

SELECT 
    'albums' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(popularity), 1) AS avg_popularity,
    COUNT(DISTINCT album_name) AS distinct_albums
FROM albums

UNION ALL

SELECT 
    'genre' AS tabla,
    COUNT(*) AS total_registros,
    COUNT(DISTINCT track_genre) AS distinct_genres,
    0 AS dummy
FROM genre;

-- =====================================================
-- 8. ANÁLISIS EJECUTIVO (Top 10)
-- =====================================================
SELECT 'TOP 10 DANCE TRACKS' AS analisis;
SELECT 
    a.track_name,
    a.artists,
    aa.dance_energy_avg,
    aa.total_features_score,
    g.track_genre
FROM albums a
JOIN Audio_Analysis aa ON a.track_id = aa.track_id
JOIN genre g ON a.track_id = g.track_id
ORDER BY aa.dance_energy_avg DESC
LIMIT 10;

-- =====================================================
-- 9. EXPORTACIÓN A CSV (ajusta secure_file_priv)
-- =====================================================
-- Ejecuta primero: SHOW VARIABLES LIKE 'secure_file_priv';
-- Y usa esa ruta exacta abajo:

SELECT * FROM dataset
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM Audio_Features
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Audio_Features_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM Audio_Analysis
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Audio_Analysis_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM albums
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/albums_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM genre
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- =====================================================
-- 10. RESUMEN FINAL
-- =====================================================
SELECT 
    'PROYECTO COMPLETADO ✅' AS estado,
    COUNT(*) AS total_tracks,
    ROUND(AVG(popularity), 1) AS popularidad_promedio,
    CURRENT_TIMESTAMP() AS fecha_ejecucion
FROM dataset;