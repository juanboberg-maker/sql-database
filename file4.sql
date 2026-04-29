-- =====================================================
-- BLOQUE COMPLETO: Importar dataset.csv + Crear Tablas
-- =====================================================
-- TABLA ORIGEN: dataset.csv (guardado en carpeta dataset.csv)

-- 0. PRIMERO: Creamos tabla 'dataset' e importamos el CSV
CREATE TABLE IF NOT EXISTS dataset (
    track_id VARCHAR(255),
    danceability DECIMAL(5,4),
    energy DECIMAL(5,4),
    `key` INT,
    loudness DECIMAL(5,3),
    mode INT,
    speechiness DECIMAL(5,4),
    acousticness DECIMAL(5,4),
    instrumentalness DECIMAL(5,4),
    liveness DECIMAL(5,4),
    valence DECIMAL(5,4),
    tempo DECIMAL(6,3),
    time_signature INT
    -- Agrega otras columnas del CSV si las tiene (track_name, artists, etc.)
);

-- IMPORTAR dataset.csv (ajusta la ruta absoluta a tu carpeta)
LOAD DATA LOCAL INFILE 'C:/ruta/a/tu/carpeta/dataset.csv'
INTO TABLE dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS  -- Salta cabecera
(track_id, danceability, energy, `key`, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, time_signature);

-- 1. Creamos Audio_Features con datos únicos desde dataset
CREATE TABLE IF NOT EXISTS Audio_Features (
    track_id VARCHAR(255) PRIMARY KEY, 
    danceability DECIMAL(5,4) NOT NULL,
    energy DECIMAL(5,4) NOT NULL,
    `key` INT,
    loudness DECIMAL(5,3),
    mode INT,
    speechiness DECIMAL(5,4),
    acousticness DECIMAL(5,4),
    instrumentalness DECIMAL(5,4),
    liveness DECIMAL(5,4),
    valence DECIMAL(5,4),
    tempo DECIMAL(6,3),
    time_signature INT
);

INSERT INTO Audio_Features
SELECT DISTINCT 
    track_id, danceability, energy, `key`, loudness, mode, speechiness, 
    acousticness, instrumentalness, liveness, valence, tempo, time_signature
FROM dataset;

-- 2. Creamos NUEVA TABLA: Audio_Analysis (métricas derivadas)
CREATE TABLE IF NOT EXISTS Audio_Analysis (
    track_id VARCHAR(255) PRIMARY KEY,
    dance_energy_sum DECIMAL(6,4) NOT NULL,
    dance_energy_avg DECIMAL(5,4) NOT NULL,
    is_dance_track BOOLEAN,
    is_energy_high BOOLEAN,
    tempo_category VARCHAR(50),
    total_features_score DECIMAL(6,4)
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
        ELSE 'Rápido'
    END AS tempo_category,
    (danceability + energy + valence) AS total_features_score
FROM Audio_Features;

-- 3. Verificación final de las 3 tablas
SELECT 
    'dataset (CSV original)' AS tabla_origen, COUNT(*) AS total_registros,
    ROUND(AVG(danceability), 4) AS avg_dance, ROUND(AVG(energy), 4) AS avg_energy
FROM dataset

UNION ALL
SELECT 
    'Audio_Features', COUNT(*) AS total_registros,
    ROUND(AVG(danceability), 4), ROUND(AVG(energy), 4)
FROM Audio_Features

UNION ALL
SELECT 
    'Audio_Analysis', COUNT(*) AS total_registros,
    ROUND(dance_energy_avg, 4), ROUND(dance_energy_avg, 4)
FROM Audio_Analysis;
-- =====================================================
-- EXPORTAR LAS 3 TABLAS A CSV - CÓDIGO + PASOS ÚNICO BLOQUE
-- =====================================================

-- PASO 1: Verifica carpeta de exportación permitida
SHOW VARIABLES LIKE 'secure_file_priv';

-- PASO 2: Configura sesión para exportar (ejecuta SIEMPRE primero)
SET SESSION sql_log_bin = 0;
SET GLOBAL local_infile = 1;

-- PASO 3: EXPORTAR dataset.csv
SELECT * FROM dataset
INTO OUTFILE '/var/lib/mysql-files/dataset_final.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- PASO 4: EXPORTAR Audio_Features.csv
SELECT * FROM Audio_Features
INTO OUTFILE '/var/lib/mysql-files/Audio_Features_final.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- PASO 5: EXPORTAR Audio_Analysis.csv
SELECT * FROM Audio_Analysis
INTO OUTFILE '/var/lib/mysql-files/Audio_Analysis_final.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- PASO 6: VERIFICACIÓN (muestra si se crearon)
SELECT 
    'EXPORTACIÓN EXITOSA ✅' AS Estado,
    '/var/lib/mysql-files/dataset_final.csv' AS dataset_csv,
    '/var/lib/mysql-files/Audio_Features_final.csv' AS features_csv,
    '/var/lib/mysql-files/Audio_Analysis_final.csv' AS analysis_csv;