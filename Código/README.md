
 #  Proyecto: Spotify Music Tracks Popularity Analyse

 Título del proyecto → Claro, profesional y orientado al negocio.
Objetivo del proyecto → 1–2 frases explicando qué problema resuelves y por qué importa.
Dataset → Fuente (real, sintético, generado). Tablas y variables principales. Diccionario breve.
Proceso de análisis → Describe brevemente: EDA, limpieza, KPIs calculados, métricas clave usadas...
Resultados / Insights → Los hallazgos más importantes, claros y accionables.
Próximos pasos → Qué extenderías si tuvieras más datos o más tiempo.
Cómo replicar el proyecto → Enlace al notebook, queries SQL o dashboard.

# Objetivo: 

Construir una pipeline de datos completa para analizar qué factores definen la popularidad de las canciones en Spotify. Partiendo de datos crudos, normalizaremos la información en una base de datos relacional para realizar consultas SQL analíticas y extraer conclusiones narrativas mediante visualizaciones en Python.

# Estructura de la Base de Datos 


## Dataset


- **Fuente:** **Spotify Tracks Dataset**— registro que recopila las canciones de Spotify con sus distinctos generos y sus características audio 
- **Registros originales:** 114.000 filas × 21 columnas
- **Registros tras limpieza:** ~89,741 filas útiles para el análisis
- **Cobertura temporal:** datos recopilados en el año 2022

### Variables principales utilizadas

| Variable |   Tipo             | Descripción |
| `track_id` |cadena(texto) | id de la canción |
|`track_name` | cadena(texto) | nombre de la canción|
| `artist_id` | cadena(texto)  | id del artista |
| `album_id` | cadena(texto)  | id del album |
| `track_genre` | cadena(texto) |genero de la canción|
| ` popularity` | INT | mide la popularidad de la canción |
| ` danceability`| INT | mide la bailabilid de la canción |

## Proceso de Análisis
 
# 1 Limpieza de datos

Carga e inspección del dataset

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


# 2 Preguntas de Investigación
¿Pueden las características de audio (tempo, energía, bailabilidad) :tener un impacto en la popularidad de una canción? Eligimos bailabidad #modif

¿Existe un dominio de ciertos artistas o géneros musicales en el top de las listas de reproducción, o la popularidad está distribuida de manera equitativa?

# 3 Caso de Negocio
Este análisis sirve para Product Managers de plataformas de streaming o sellos discográficos. Los hallazgos permitirán entender qué perfiles de canciones tienen mayor probabilidad de éxito comercial, ayudando en la toma de decisiones sobre recomendaciones algorítmicas, estrategias de marketing para nuevos lanzamientos o selección de talento para inversión.


# 4 Simplificación de los datos

Dividimos el dataset en tres tablas relacionales para optimizar la estructura:

albums: información basícas de los albums de donde provienen las canciones  id de la canción, nombre de la canción, nombre del album, artistas, popularidad.

genre: recopoila la id de las canciones y también sus respectivos generos musicales

auddio_features: recopila las id de las canciones y sus caracteríticas audio como bailabilidad, acousticidad, intrumentalidad... 

# 5 Analisis de los datos obetenidos

Partimos de estas tablas para realizar **JOINs** para deducir correlaciones entre el artista, el álbum, las características audio (en nuestro caso nos centramos sobre la bailibidad) de las canciones y la populiridad de la pista. 

# Verificación de los datos #esto ponlo en la diapo bonus (solo pon que usamos estas funciones para verificar y confirmar nuestos)

. El Rol de la Función **COUNT()** 
Hemos establecido la función COUNT() como nuestro primer control de calidad. Nos sirve para:

. Validación de Volumen: Confirmamos que la cantidad de registros en las tablas derivadas (como popularity_analysis) coincida con los filtros aplicados al dataset original.

. Análisis de Diversidad: Mediante el uso de **COUNT(DISTINCT ...)**, cuantificamos la variedad real de artistas, álbumes y géneros, evitando que los duplicados distorsionen nuestra visión del catálogo.

. Evaluación de métricas con **AVG()** y **ROUND()**
Una vez validado el volumen con los conteos, utilizamos la función **AVG()** para diagnosticar el perfil de nuestra biblioteca:

. Impacto Comercial: Calculamos la popularidad promedio para entender el posicionamiento de nuestro contenido. 

. Atributos Sonoros: Definimos el carácter musical predominante a través del promedio de tempo y danceability.

Presentación Profesional: Integramos la función **ROUND()** para asegurar que todos nuestros resultados numéricos sean precisos, limpios y fáciles de interpretar en presentaciones ejecutivas.

. Compromiso con la Calidad del Código
Para garantizar que nuestro trabajo sea escalable, hemos aplicado estándares de desarrollo de alto nivel:

Empleamos alias significativos **(AS)** para que nuestros reportes sean legibles.

Mantenemos una indentación estructurada y comentarios técnicos precisos, asegurando que nuestra lógica sea transparente y fácil de mantener por nosotros o cualquier otro equipo.

# Resultados / Insights 

## Tablas utilizadas
- albums
- genre
- Audio_Features
- Popularity_Analysis

## Visualizaciones generadas
- Top géneros a partir de genre.
- Popularidad de una canción según el album donde se encuentra, su género y su bailabilidad
- Promedio de audio features desde Audio_Features.
- Top canciones a partir de albums (el visual )
- Popularidad media por género y bailabidad join entre albums, genre y audio_features. (no está la bailibilidad)

## Insights
 
- El género con mayor popularidad media es k-pop con 59.36 de popularidad media.


- Sinergia Álbum-Popularidad: Es evidente que álbumes como "Un Verano Sin Ti" de Bad Bunny logran posicionar múltiples canciones (Me Porto Bonito, Tití Me Preguntó, Efecto) en el top más alto del ranking. Esto confirma que el éxito de un álbum arrastra la popularidad de sus tracks individuales.

Patrones de Bailabilidad:La mayoría de los éxitos rotundos  tienen una bailabilidad muy alta (superior a 0.65). Sin embargo, hay excepciones interesantes como Unholy, que demuestra que una canción puede ser extremadamente popular incluso con una métrica de baile menor si el género (Pop/Dance) tiene una fuerte tracción.
El catálogo muestra que los géneros Latino, Pop y Reggaetón dominan actualmente las posiciones de mayor popularidad, sugiriendo una tendencia clara en los gustos del público



