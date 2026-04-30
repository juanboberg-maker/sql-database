-- =====================================================
-- Dataset Spotify → 5 tablas + análisis + exportación
-- TODAS LAS TABLAS EN MINÚSCULAS | SIN audio_analysis
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
DROP TABLE IF EXISTS popularity_analysis, audio_features, albums, genre, dataset;

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
-- 3. TABLA audio_features (datos únicos de audio)
-- =====================================================
CREATE TABLE audio_features (
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

INSERT INTO audio_features
SELECT DISTINCT
    track_id, danceability, energy, `key`, loudness, mode, speechiness,
    acousticness, instrumentalness, liveness, valence, tempo, time_signature
FROM dataset
WHERE track_id IS NOT NULL AND track_id <> '';

-- =====================================================
-- 4. NUEVA TABLA popularity_analysis (REEMPLAZA audio_analysis)
-- =====================================================

CREATE TABLE IF NOT EXISTS popularity_analysis (
    track_id VARCHAR(255) PRIMARY KEY, 
    track_name VARCHAR(255) NOT NULL,  
    artist_id VARCHAR(255),            
    track_genre VARCHAR(255), #modif        
    album_id VARCHAR(255),             
    popularity INT,                    
    danceability DECIMAL(5, 4)         
);

    track_id, 
    track_name, 
    artist_id, 
    track_genre, #modif
    album_id, 
    popularity, 
    danceability
)
SELECT 
    d.track_id,
    d.track_name,
    d.artists AS artist_id,
    g.genre_name AS track_genre, -- Fetched from the genre table
    d.album_name AS album_id,
    d.popularity,
    af.danceability
FROM  #modif
    dataset d
JOIN 
    audio_features af ON d.track_id = af.track_id
JOIN 
    genre g ON d.genre_id = g.genre_id 
WHERE 
    d.popularity IS NOT NULL 
    AND d.popularity > 0
ORDER BY 
    d.popularity DESC;


SELECT 
    track_name, 
    track_genre, 
    popularity 
FROM 
    popularity_analysis 
LIMIT 15;

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
  AND popularity IS NOT NULL;

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
-- 7. VERIFICACIÓN DE TABLAS (5 tablas, UNION ALL corregido)
-- =====================================================
SELECT 
    'dataset' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(popularity), 1) AS avg_popularity,
    COUNT(DISTINCT artists) AS distinct_artists
FROM dataset

UNION ALL

SELECT 
    'audio_features' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(tempo), 1) AS avg_tempo,
    ROUND(AVG(danceability), 3) AS avg_danceability
FROM audio_features

UNION ALL

SELECT 
    'popularity_analysis' AS tabla,
    COUNT(*) AS total_registros,
    ROUND(AVG(popularity), 1) AS avg_popularity,
    COUNT(DISTINCT artist_id) AS distinct_artists
FROM popularity_analysis

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
    COUNT(DISTINCT genre_category) AS genre_categories
FROM genre;

-- =====================================================
-- 8. ANÁLISIS EJECUTIVO (Top 10 por popularidad)
-- =====================================================
SELECT 'TOP 10 TRACKS POR POPULARIDAD' AS analisis;
SELECT 
    pa.track_name,
    pa.artist_id,
    pa.album_id,
    pa.popularity,
    pa.danceability,
    g.genre_category
FROM popularity_analysis pa
JOIN genre g ON pa.track_id = g.track_id
ORDER BY pa.popularity DESC, pa.danceability DESC
LIMIT 10;

-- =====================================================
-- 9. EXPORTACIÓN A CSV (ajusta secure_file_priv)
-- =====================================================
-- Ejecuta primero: SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM dataset
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM audio_features
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/audio_features_final.csv'
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT * FROM popularity_analysis
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/popularity_analysis_final.csv'
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
    (SELECT COUNT(*) FROM dataset) AS total_tracks,
    (SELECT ROUND(AVG(popularity), 1) FROM dataset) AS popularidad_promedio,
    CURRENT_TIMESTAMP() AS fecha_ejecucion;
