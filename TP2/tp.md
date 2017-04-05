TP2-IA-RNA
================

TP 2 - Inteligencia Artificial - UTN FRBA
-----------------------------------------

Los datos se obtienen de las encuestas recolectadas por el sitio <http://www.encuestasit.com/>
Los datos en crudo de las encuestas están disponibles en el sitio, en la sección de Preguntas Frecuentes.
Para este analisis solo se tienen en cuenta las encuestas de 2016.

Links: - <http://www.kdnuggets.com/2016/08/begineers-guide-neural-networks-r.html/2>

### Resumen:

Descripción de lo que se encontrará en el trabajo práctico, detallando el objetivo del trabajo

### Introducción:

Descripción del problema que se desea resolver, indicando su relevancia y características.

### Elementos del Trabajo y Metodología:

-   Modelo de RNA utilizada con la justificación de su elección.
-   Arquitectura y topología final de la RNA.
-   Descripción de los patrones utilizados para el entrenamiento y la validación de la RNA (por lo menos se debe utilizar un 25% de los patrones disponibles para la validación).
-   Herramientas, lenguajes y/o librerías seleccionadas para la implementación de la RNA.
-   En caso de haber utilizado varios prototipos, las características de las principales versiones utilizadas.

### Resultados:

-   El error general obtenido en el entrenamiento de la RNA.
-   Los resultados obtenidos al aplicar en la RNA entrenada los patrones de validación (correctos y/o incorrectos). Para ello, se debe utilizar una tabla que indique por cada patrón:
-   los datos de entrada ingresados,
-   la salida generada por la RNA,
-   la salida esperada para los datos de entrada, y
-   la comparación entre la salida esperada y la generada.

### Discusión:

Análisis de los resultados obtenidos en la sección anterior. Para ello, se puede evaluar de los resultados según dos perspectivas: - ¿El Sistema Inteligente propuesto resuelve satisfactoriamente el problema? En el caso en que el resultado no fuese satisfactorio, indique posibles causas y proponga cursos de acción. - ¿Cómo se compara con otras arquitecturas?

### Conclusión:

-   Conclusiones de la implementación del Sistema Inteligente.
-   Relación entre los resultados, el modelo utilizado y la teoría vista en clase.
-   Descripción de los problemas encontrados durante la implementación (si hubo alguno) y las estrategias de resolución aplicadas.

### Referencias:

-   Cita de bibliografía consultada, tanto escrita como digital (tal como una página web).
-   Cita de otras fuentes teóricas, datos, técnicas y cualquier otra cosa que se haya utilizado para la realización del trabajo práctico.

Carga de los datos
------------------

``` r
# ----------------------  Levantar DataFrame  ----------------------

# Levantamos el archivo ya formateado,
encuestas <- read.csv("./encuestas.csv")
encuestas$X <- NULL
```

### resumen de datos

Visualizamos un resumen de los datos que vamos a usar para esta clasificación.

``` r
# ----------------------  imprimir resumen de campos  ----------------------

str(encuestas)
```

    ## 'data.frame':    1791 obs. of  10 variables:
    ##  $ Edad                 : int  25 41 23 40 33 28 34 44 26 29 ...
    ##  $ IdSexo               : Factor w/ 3 levels "Femenino","Masculino",..: 2 1 2 2 2 2 2 2 2 2 ...
    ##  $ IdNivelEducativo     : Factor w/ 10 levels "Master o postgrado completo",..: 10 9 7 8 10 10 9 10 8 5 ...
    ##  $ IdTipoDeEmpresa      : Factor w/ 7 levels "Mi propia empresa",..: 6 6 6 5 5 6 6 6 6 6 ...
    ##  $ IdProvincia          : Factor w/ 25 levels "Buenos Aires",..: 3 2 3 3 3 8 3 2 3 3 ...
    ##  $ IdPuesto             : Factor w/ 76 levels "Administrador de Almacenamiento (Storage)",..: 24 1 24 72 43 76 24 16 76 74 ...
    ##  $ MesesDeExperiencia   : int  0 96 36 144 0 60 0 96 0 36 ...
    ##  $ IdTecnologiaPrincipal: Factor w/ 57 levels ".Net","ActionScript",..: 4 1 24 23 26 23 1 54 23 57 ...
    ##  $ CargaLaboral         : Factor w/ 4 levels "Extra Time","Full Time",..: 3 2 2 2 2 2 2 1 2 2 ...
    ##  $ SalarioNetoPorHora   : num  406 419 238 560 564 ...

``` r
# ----------------------   primeros campos  ---------------------- 
kable(head(encuestas))
```

|  Edad| IdSexo    | IdNivelEducativo                    | IdTipoDeEmpresa      | IdProvincia      | IdPuesto                                  |  MesesDeExperiencia| IdTecnologiaPrincipal | CargaLaboral |  SalarioNetoPorHora|
|-----:|:----------|:------------------------------------|:---------------------|:-----------------|:------------------------------------------|-------------------:|:----------------------|:-------------|-------------------:|
|    25| Masculino | Universitario en curso o incompleto | Una empresa privada  | Capital Federal  | Desarrollador de software / Programador   |                   0| Android               | Part Time    |            406.2500|
|    41| Femenino  | Universitario completo              | Una empresa privada  | CÃ³rdoba         | Administrador de Almacenamiento (Storage) |                  96| .Net                  | Full Time    |            418.6047|
|    23| Masculino | Terciario completo                  | Una empresa privada  | Capital Federal  | Desarrollador de software / Programador   |                  36| Javascsript           | Full Time    |            237.7778|
|    40| Masculino | Terciario en curso o incompleto     | Un organismo estatal | Capital Federal  | Scrum Master                              |                 144| Java                  | Full Time    |            560.2500|
|    33| Masculino | Universitario en curso o incompleto | Un organismo estatal | Capital Federal  | Implementador de Sistemas                 |                   0| Mainframe             | Full Time    |            564.4737|
|    28| Masculino | Universitario en curso o incompleto | Una empresa privada  | Costa AtlÃ¡ntica | Tester Funcional                          |                  60| Java                  | Full Time    |            375.0000|

### Preprocesado de datos

La columna a predecir "IdSexo" tiene los siguientes valores:
- 0 = Masculino - 1 = Femenino

Todos las columnas de tipo "Factor" (Enumeración) las llevamos a int (entero)

``` r
# Output
UniversitarioCompleto <- as.numeric(encuestas$IdNivelEducativo == "Universitario completo")
encuestas$IdNivelEducativo <- NULL

# Convercion de Enums a Int
encuestas$IdSexo <- as.numeric(encuestas$IdSexo)
encuestas$IdTipoDeEmpresa <- as.numeric(encuestas$IdTipoDeEmpresa)
encuestas$IdProvincia <- as.numeric(encuestas$IdProvincia)
encuestas$IdPuesto <- as.numeric(encuestas$IdPuesto)
encuestas$IdTecnologiaPrincipal <- as.numeric(encuestas$IdTecnologiaPrincipal)
encuestas$CargaLaboral <- as.numeric(encuestas$CargaLaboral)



# Escalado entre 0 y 1
range01 <- function(x){(x-min(x))/(max(x)-min(x))}
encuestas <- as.data.frame(sapply(encuestas, range01)) 
```

### separación en sets

Selección de una submuestra de 450 (el 25% de los datos) para test El resto de los datos seràn de entrenamiento.

``` r
set.seed(101)
indices <- sample(1:nrow(encuestas),size=450)

entrenamiento_input <- encuestas[-indices,]
entrenamiento_output = UniversitarioCompleto[-indices]
entrenamiento <- entrenamiento_input
entrenamiento$UniversitarioCompleto <- entrenamiento_output

test_input <- encuestas[indices,]
test_output <- UniversitarioCompleto[indices]
```

### Armado de la red neuronal

``` r
# Outputs:
nombres <- names(encuestas)

# Inputs:
f <- paste(nombres,collapse=' + ')
f <- paste('UniversitarioCompleto ~',f)

# Formula:
f <- as.formula(f)

# -------------------


# Creación y entrenamiento de la red neuronal
# nn <- neuralnet(f,entrenamiento,hidden=c(10,10,10),linear.output=FALSE,stepmax=1000)
nn2 <- nnet(entrenamiento_input, entrenamiento_output,data=dat.in,size=10, maxit=1000)
```

    ## # weights:  111
    ## initial  value 328.205720 
    ## iter  10 value 271.686527
    ## iter  20 value 262.534748
    ## iter  30 value 255.618404
    ## iter  40 value 248.330645
    ## iter  50 value 240.655456
    ## iter  60 value 236.448311
    ## iter  70 value 231.323692
    ## iter  80 value 228.041906
    ## iter  90 value 226.579033
    ## iter 100 value 226.115870
    ## iter 110 value 225.942609
    ## iter 120 value 225.835251
    ## iter 130 value 225.607875
    ## iter 140 value 225.326730
    ## iter 150 value 225.245667
    ## iter 160 value 225.154091
    ## iter 170 value 225.134164
    ## iter 180 value 225.117199
    ## iter 190 value 225.116227
    ## final  value 225.116191 
    ## converged

### Evaluación del modelo

``` r
# Calculamos las predicciones usando el modelo
# predicciones <- compute(nn,test_input)
predicciones <- predict(nn2, test_input)

# Redondiamos la salida del modelo (si es > 0.5 lo consideramos 1)
# predicciones <- sapply(predicciones$net.result,round,digits=0)
predicciones <- sapply(predicciones,round,digits=0)

# Validamos las predicciones con los valores reales.
table(test_output,predicciones)
```

    ##            predicciones
    ## test_output   0   1
    ##           0 231  60
    ##           1 109  50

### Visualización del modelo

``` r
# plot(nn)
plot.nnet(nn2)
```

![](tp_files/figure-markdown_github/Visualización%20del%20modelo-1.png)
