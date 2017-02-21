# ----------------------  Importamos funciones  ----------------------  
source("./funciones/quitarSaltosLineaComentarios.R")
source("./funciones/cantidadOcurrenciasStr.R")


# ----------------------  Constantes  ----------------------  

FILE_ENCUESTAS  <- "./datos/encuestas.txt"
FILE_TABLAS  <- "./datos/tablas_anexas.txt"


# ----------------------  Descarga  ----------------------

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

# ----------------------  Preprocesado  ----------------------

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

# TODO: Falta resolver el tema de todos los registros rotos

# ----------------------  Levantar DataFrame  ----------------------

# Levantamos el archivo ya formateado, 
encuestas <- read.csv("./datos/encuestas_clear.txt")

# ----------------------  Procesado de caracteristicas  ----------------------

# Pasamos la fecha al formato correcto
encuestas$Fecha1 <- 
encuestas$Fecha <- lapply(encuestas$Fecha, as.character)
encuestas$Fecha <- lapply(encuestas$Fecha, function(x){substr(x, 0, 16)})
encuestas$Fecha <- lapply(encuestas$Fecha, function(x){strptime(x, "%Y-%m-%d %H:%M")})

# Buscamos valores faltantes
na_count <-sapply(encuestas, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)

# Quitamos las columnas que tienen todos NA
encuestas$SalarioActualBruto <- NULL
encuestas$IdArea <- NULL
encuestas$puestoGenerico <- NULL
encuestas$especialidadGenerico <- NULL

# La mayoria de los datos de la columna NivelRemunerativo son NA, y sumado a que tampoco hay
# referencias sobre ese campo, lo mejor parece ser que es quitarla
# veamos si existe alguna correlaciòn entre el nivelRemunerativo y el salario
boxplot(SalarioActualNeto ~ NivelRemunerativo, data = encuestas)

# No se ve ninguna relación clara, quitamos entonces nivelRemunerativo
encuestas$NivelRemunerativo <- NULL

# Vemos que hay un registro con IdPais en NA, lo eliminamos
encuestas <- encuestas[complete.cases(encuestas[,"IdPais"]),]

# Nos quedamos solo con los de Argentina, ya que para este estudio no nos interesa el resto. 
# Ademas sus salarios están expresados en moneda local de cada país, lo que requeriria conversion
encuestas <- subset(encuestas, IdPais == 1)


# Esto último tambien eliminó el unico registro que tenia un NA en NivelDeDesconfianza, genial!



# TODO: Falta levantar las tablas auxiliares y setear bien los factors

# ---------------------- Creación de caracteristicas  ---------------------- 
encuestas$DiferenciaSalarioRealIdeal <- encuestas$SalarioIdealNeto - encuestas$SalarioActualNeto

# ---------------------- Limpieza de valores anomalos  ---------------------- 

# todas las (edad > 65) las vamos a considerar anomalas y vamos a desechar esos registros
encuestas <- encuestas[encuestas$Edad < 66, ]
hist(encuestas$Edad)
rug(encuestas$Edad)

# todas las (horas trabajadas >= 150) las vamos a considerar anomalas y vamos a desechar esos registros
encuestas <- encuestas[encuestas$horasTrabajadasXSemana < 150, ]
hist(encuestas$horasTrabajadasXSemana)
rug(encuestas$horasTrabajadasXSemana)

# todos los (meses en el puesto actual >= 360) los vamos a considerar anomalas y vamos a desechar esos registros
encuestas <- encuestas[encuestas$MesesEnElPuestoActual < 480, ]
hist(encuestas$MesesEnElPuestoActual)
rug(encuestas$MesesEnElPuestoActual)

# todos los (salario actual neto >= 150000) los vamos a considerar anomalas y vamos a desechar esos registros
encuestas <- encuestas[encuestas$SalarioActualNeto < 150000, ]
hist(encuestas$SalarioActualNeto)
rug(encuestas$SalarioActualNeto)

# todos los (salario ideal neto >= 150000) los vamos a considerar anomalas y vamos a desechar esos registros
encuestas <- encuestas[encuestas$SalarioIdealNeto < 150000, ]
hist(encuestas$SalarioIdealNeto)
rug(encuestas$SalarioIdealNeto)


# ---------------------- Exploración grafica ----------------------


# Las variables mas interesantes que nos interesan explorar, en principio, son:
# SalarioActualNeto
# IdNivelEducativo
# IdSexo
# horasTrabajadasXSemana

# histogramas de salarios netos para hombres y mujeres en los puestos bajos
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(encuestas, IdSexo == 1 & SalarioActualNeto < 20000)$SalarioActualNeto)
hist(subset(encuestas, IdSexo == 2 & SalarioActualNeto < 20000)$SalarioActualNeto)

par(mfrow = c(1, 1), mar = c(4, 4, 1, 1))

# Salario y nivel educativo
boxplot(SalarioActualNeto ~ IdNivelEducativo, data = subset(encuestas, SalarioActualNeto < 50000 & ))
# La media sube mientras sube el nivel educativo.
# Ahora veamos la relación entre nivel educativo y horas de trabajo por semana

plot(encuestas$IdNivelEducativo, encuestas$horasTrabajadasXSemana)
# Aquellos que tienen universitario incompleto tienen una mayor media de cantidad de horas que el resto.
# Parece lógico.

# Veamos la relación entre el salario y la antiguedad, para puestos bajos y medios
with(subset(encuestas, SalarioActualNeto < 40000), plot(SalarioActualNeto, MesesEnElPuestoActual) )

# Veamos la relación entre el salario y la edad, para puestos bajos y medios
with(subset(encuestas, SalarioActualNeto < 40000), plot(SalarioActualNeto, Edad) )
# Hay una correlación, aunque se ameceta luego de los 40

# veamos el salario medio para cada nivel educativo



