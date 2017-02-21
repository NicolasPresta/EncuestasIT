# Definimos algunas constantes que nos seràn utiles durante el proceso.
FILE_ENCUESTAS  <- "./datos/encuestas.txt"
FILE_TABLAS  <- "./datos/tablas_anexas.txt"


# Descargamos los datos en crudo del sitio de encuestasIT
if(!file.exists(FILE_ENCUESTAS))
    download.file(  "http://www.encuestasit.com/preguntas-frecuentes/descargar-encuestas", 
                    FILE_ENCUESTAS)

# Descargamos la información de las tablas anexas
if(!file.exists(FILE_TABLAS))
    download.file(  "http://www.encuestasit.com/preguntas-frecuentes/descargar-tablas-anexas", 
                    FILE_TABLAS)


# Ya tenemos los datos de las encuestas en crudos, pero antes de levantarlos a una tabla necesitamos
# hacer algun preprocesamiento, ya que uno de los campos es "observaciones" y en el mismo se incluye
# un texto libre que puede contenter comas, saltos de linea, y demas caracteres que arruinarian el parseo
# al levantar el archivo directamente como un .csv, por lo que necesitamos "sanitizar" este campo antes
# de proseguir


# Levantamos el archico como un documento de texto
txtdata <- readLines(FILE_ENCUESTAS) 

# Quitamos todas las lineas en blanco, no tienen razon de ser en el archivo.
empty_lines = grepl('^\\s*$', txtdata)
txtdata = txtdata[! empty_lines]

# Quitamos los saltos de linea dentro de los comentarios
txtdata <- quitarSaltosLineaComentarios(txtdata)

# Quitamos los ", ," por ",," 
txtdata <- gsub(", ,", ",,", txtdata)
# y los ",  ," por ",,"
txtdata <- gsub(",  ,", ",,", txtdata)
# y los ", \r\n" por ","
txtdata <- gsub(", \r\n", ",\r\n", txtdata)
# y los ",  \r\n" por ","
txtdata <- gsub(",  \r\n", ",\r\n", txtdata)

# Quitamos los ",False, " y lo reemplazamos por ",False," (3 veces por si hay varios espacios)
txtdata <- gsub(",False, ", ",False,", txtdata)
txtdata <- gsub(",False,  ", ",False,", txtdata)
txtdata <- gsub(",False,   ", ",False,", txtdata)

# Quitamos los ",True, " y lo reemplazamos por ",True," (3 veces por si hay varios espacios)
txtdata <- gsub(",True, ", ",True,", txtdata)
txtdata <- gsub(",True,  ", ",True,", txtdata)
txtdata <- gsub(",True,   ", ",True,", txtdata)

# Quitamos los ", " y lo reemplazamos por " "
txtdata <- gsub(", ", " ", txtdata)

# Veamos cuantas lineas no tienen la cantidad de "," que esperamos que tengan
cantComasEsperadas <- cantidadComas(txtdata[1])
dataCantComas <- lapply(txtdata, cantidadComas)

# Buscamos los renglones que tienen más o menos comas de las esperadas
renglonesInconsistentes <- txtdata[dataCantComas != cantComasEsperadas]
renglonesConsistentes <- txtdata[dataCantComas == cantComasEsperadas]

# Cantidad de renglones inconsistentes: 
length(renglonesInconsistentes)

# Cantidad de renglones consistentes:
length(renglonesConsistentes)

# Cantidad de renglones total:
length(txtdata)

# Grabamos el procesado que hicimos hasta ahora
write(renglonesInconsistentes, "./datos/encuestas_unclear.txt")
write(renglonesConsistentes, "./datos/encuestas_clear.txt")

# Falta resolver el tema de todos los registros rotos

# Levantamos el archivo ya formateado, 
encuestas <- read.csv("./datos/encuestas_clear.txt")




