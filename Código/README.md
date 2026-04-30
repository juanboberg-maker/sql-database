
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

- **Fuente:** **Spotify Tracks Dataset**— registro que recopila las canciones de   Spotify con sus distinctos generos y sus características audio 
- **Registros originales:** 114.000 filas × 21 columnas
- **Registros tras limpieza:** ~89,741 filas útiles para el análisis
- **Cobertura temporal:** datos recopilados en el año 2022

### Variables principales utilizadas

| Variable | Tipo | Descripción |

| `track_id` | Categórica | País donde ocurrió el ataque |
| `state` | Categórica | Estado o región |
| `location` | Categórica | Lugar específico del ataque |
| `activity` | Categórica | Actividad que realizaba la víctima |
| `age` | Numérica | Edad de la víctima |
| `injury` | Texto | Descripción de la herida |
| `species` | Categórica | Especie de tiburón involucrada |
| `fatal` | Booleana | Si el ataque fue mortal (derivada de `injury`) |
| `age_range` | Categórica | Rango de edad (`<18`, `18-25`, `26-35`...) |
Dividiremos el dataset en tres tablas relacionales para optimizar la estructura:

albums: información basícas de los albums de donde provienen las canciones  id de la canción, nombre de la canción, nombre del album, artistas, popularidad.

genre: recopoila la id de las canciones y también sus respectivos generos musicales

auddio_features: recopila las id de las canciones y sus caracteríticas auditivas como bailabilidad, acousticidad, intrumentalidad... 

Partiremos de estas para realizar JOINs para analizar correlaciones entre el artista, el álbum, las características auditivas de las canciones y la populiridad de la pista. #mmdif

# Preguntas de Investigación
¿Pueden las características de audio (tempo, energía, bailabilidad) tener un impacto en la popularidad de una canción? Eligimos bailabidad #modif

¿Existe un dominio de ciertos artistas o géneros musicales en el top de las listas de reproducción, o la popularidad está distribuida de manera equitativa?

# Caso de Negocio
Este análisis sirve para Product Managers de plataformas de streaming o sellos discográficos. Los hallazgos permitirán entender qué perfiles de canciones tienen mayor probabilidad de éxito comercial, ayudando en la toma de decisiones sobre recomendaciones algorítmicas, estrategias de marketing para nuevos lanzamientos o selección de talento para inversión.