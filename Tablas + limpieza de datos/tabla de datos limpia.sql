-- 0. Limpieza inicial: eliminar la columna por si quedó de un intento previo
SET @col_exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'dataset' AND column_name = 'flag_borrar');
SET @drop_sql = IF(@col_exists > 0, 'ALTER TABLE dataset DROP COLUMN flag_borrar', 'SELECT "No existe"');
PREPARE stmt FROM @drop_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1. Desactivar modo seguro
SET SQL_SAFE_UPDATES = 0;

-- 2. Añadir la columna de nuevo
ALTER TABLE dataset ADD COLUMN flag_borrar INT DEFAULT 0;

-- 3. Marcar filas a borrar (duplicados y nulos)
UPDATE dataset d1
SET flag_borrar = 1
WHERE d1.track_id IS NULL 
   OR d1.artists IS NULL 
   OR d1.album_name IS NULL
   OR d1.track_id NOT IN (
       SELECT min_id FROM (
           SELECT MIN(track_id) as min_id FROM dataset GROUP BY track_id
       ) AS temp
   );

-- 4. Borrar las marcadas
DELETE FROM dataset WHERE flag_borrar = 1;

-- 5. Limpiar valores nulos en columnas numéricas
UPDATE dataset SET popularity = 0 WHERE popularity IS NULL;
UPDATE dataset SET danceability = 0 WHERE danceability IS NULL;
UPDATE dataset SET energy = 0 WHERE energy IS NULL;

-- 6. Eliminar la columna auxiliar
ALTER TABLE dataset DROP COLUMN flag_borrar;

-- 7. Reactivar modo seguro
SET SQL_SAFE_UPDATES = 1;