-- Esto borra la tabla si existe, evitando el error 1050
DROP TABLE IF EXISTS Tracks;

-- Ahora puedes crearla con total seguridad
CREATE TABLE Tracks AS
SELECT DISTINCT track_id, track_name, album_name, popularity, duration_ms, explicit, track_genre
FROM dataset;