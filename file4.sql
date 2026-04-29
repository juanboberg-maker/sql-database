-- 1. Creamos de la tabla 'albums'
-- Defimos el esquema 
CREATE TABLE IF NOT EXISTS albums (
    track_id VARCHAR(255) PRIMARY KEY, 
    track_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),   
    artists VARCHAR(255),
    popularity INT                    
);
-- 2. Recuperación de datos
-- Obtención de registros ordenados por mayor popularidad primero
SELECT 
    track_id AS track_identifier, 
    album_name AS album_title, 
    artist AS artist_name,
    popularity AS popularity_score;
    
    CREATE TABLE IF NOT EXISTS genre (
    track_id VARCHAR(255) PRIMARY KEY, 
    track_name VARCHAR(255) NOT NULL,
    track_genre VARCHAR(255)     
                       
);
SELECT 
    track_id AS track_identifier, 
    track_name AS track_title, 
    track_genre AS track_genre;
    
-- Esto va la tabla final luego podremos su nombre y yasta 
FROM 
    albums
ORDER BY 
    popularity DESC;
    fffffff