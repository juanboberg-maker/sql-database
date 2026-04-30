# sql-database
# Resumen del Proyecto: Spotify Music Insights
# Objetivo
Construir una pipeline de datos completa para analizar qué factores definen la popularidad de las canciones en Spotify. Partiendo de datos crudos, normalizaremos la información en una base de datos relacional para realizar consultas SQL analíticas y extraer conclusiones narrativas mediante visualizaciones en Python.

# Estructura de la Base de Datos
Dividiremos el dataset en tres tablas relacionales para optimizar la estructura:

Tracks: Información base de la canción (ID, nombre, popularidad, duración).

Artists: Datos de los artistas.

# Albums: Datos de los álbumes y fechas de lanzamiento.
Esto nos permite realizar JOINs para analizar correlaciones entre el artista, el álbum y el rendimiento comercial de la pista.

# Preguntas de Investigación
¿Pueden las características de audio (tempo, energía, bailabilidad) tener un impacto en la popularidad de una canción? Eligimos bailabidad #modif

¿Existe un dominio de ciertos artistas o géneros musicales en el top de las listas de reproducción, o la popularidad está distribuida de manera equitativa?

# Caso de Negocio
Este análisis sirve para Product Managers de plataformas de streaming o sellos discográficos. Los hallazgos permitirán entender qué perfiles de canciones tienen mayor probabilidad de éxito comercial, ayudando en la toma de decisiones sobre recomendaciones algorítmicas, estrategias de marketing para nuevos lanzamientos o selección de talento para inversión.