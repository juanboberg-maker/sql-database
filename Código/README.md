# sql-database
# Resumen del Proyecto: Spotify Music Insights
# Objetivo
Construir una pipeline de datos completa para analizar qué factores definen la popularidad de las canciones en Spotify. Partiendo de datos crudos, normalizaremos la información en una base de datos relacional para realizar consultas SQL analíticas y extraer conclusiones narrativas mediante visualizaciones en Python.

# Estructura de la Base de Datos #modif
Dividiremos el dataset en tres tablas relacionales para optimizar la estructura:

albums: Información base de los albums de donde provienen las canciones  id de la canción, nombre de la canción, nombre del album, artistas, popularidad.

genre: generos musicales 

tracks_features:

Esto nos permite realizar JOINs para analizar correlaciones entre el artista, el álbum y la populiridad de la pista. #mmdif

# Preguntas de Investigación
¿Pueden las características de audio (tempo, energía, bailabilidad) tener un impacto en la popularidad de una canción? Eligimos bailabidad #modif

¿Existe un dominio de ciertos artistas o géneros musicales en el top de las listas de reproducción, o la popularidad está distribuida de manera equitativa?

# Caso de Negocio
Este análisis sirve para Product Managers de plataformas de streaming o sellos discográficos. Los hallazgos permitirán entender qué perfiles de canciones tienen mayor probabilidad de éxito comercial, ayudando en la toma de decisiones sobre recomendaciones algorítmicas, estrategias de marketing para nuevos lanzamientos o selección de talento para inversión.