# Informe de análisis de datos

## 1. Resumen del dataset
- Base de datos SQLite creada: `C:\Users\juanb\Desktop\IronHack\SQL\Proyecto SQL\sql-database\proyecto_sql.db`
- Tabla analizada: `audio_features`
- Número de filas: 89741
- Número de columnas: 13
- Columnas disponibles: track_id, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, time_signature

## 2. Calidad de datos
- `track_id`: 0 valores nulos
- `danceability`: 0 valores nulos
- `energy`: 0 valores nulos
- `key`: 0 valores nulos
- `loudness`: 0 valores nulos
- `mode`: 0 valores nulos
- `speechiness`: 0 valores nulos
- `acousticness`: 0 valores nulos
- `instrumentalness`: 0 valores nulos
- `liveness`: 0 valores nulos
- `valence`: 0 valores nulos
- `tempo`: 0 valores nulos
- `time_signature`: 0 valores nulos

## 3. Variables detectadas automáticamente
- Columna categórica usada: `None`
- Columna numérica usada: `danceability`
- Columna temporal usada: `None`

## 4. Estadísticas descriptivas
```text
       danceability    energy       key  loudness      mode  speechiness  acousticness  instrumentalness  liveness   valence     tempo  time_signature
count      89741.00  89741.00  89741.00  89741.00  89741.00     89741.00      89741.00          89741.00  89741.00  89741.00  89741.00        89741.00
mean           0.56      0.63      5.28     -8.50      0.64         0.09          0.33              0.17      0.22      0.47    122.06            3.90
std            0.18      0.26      3.56      5.22      0.48         0.11          0.34              0.32      0.19      0.26     30.12            0.45
min            0.00      0.00      0.00    -49.53      0.00         0.00          0.00              0.00      0.00      0.00      0.00            0.00
25%            0.45      0.46      2.00    -10.32      0.00         0.04          0.02              0.00      0.10      0.25     99.26            4.00
50%            0.58      0.68      5.00     -7.18      1.00         0.05          0.19              0.00      0.13      0.46    122.01            4.00
75%            0.69      0.85      8.00     -5.11      1.00         0.09          0.62              0.10      0.28      0.68    140.08            4.00
max            0.98      1.00     11.00      4.53      1.00         0.96          1.00              1.00      1.00      1.00    243.37            5.00
```

## 5. Insights principales
- La media de `danceability` es **0.56**.
- La mediana de `danceability` es **0.58**.
- El valor mínimo es **0.00** y el máximo es **0.98**.

## 6. Conclusión
El análisis exploratorio permite identificar patrones de frecuencia, distribución y relaciones entre variables. Las visualizaciones convierten los datos importados desde CSV y SQLite en insights útiles para la toma de decisiones.
