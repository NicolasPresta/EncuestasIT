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

------------------------------------------------------------------------

### Carga de los datos

``` r
# ----------------------  Levantar DataFrame  ----------------------

# Levantamos el archivo ya formateado,
encuestas <- read.csv("./encuestas.csv")
encuestas$X <- NULL
```

### Resumen de datos

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

Lo que vamos a intentar predecir es si el encuestado tiene más de 35 años
- 0 = NO
- 1 = SI

Todos las columnas de tipo "Factor" (Enumeración) las llevamos a int (entero)

``` r
# Output
Output <- as.numeric(encuestas$Edad > 35)
encuestas$Edad <- NULL

# Convercion de Enums a Int
encuestas$IdSexo <- as.numeric(encuestas$IdSexo)
encuestas$IdNivelEducativo <- as.numeric(encuestas$IdNivelEducativo)
encuestas$IdTipoDeEmpresa <- as.numeric(encuestas$IdTipoDeEmpresa)
encuestas$IdProvincia <- as.numeric(encuestas$IdProvincia)
encuestas$IdPuesto <- as.numeric(encuestas$IdPuesto)
encuestas$IdTecnologiaPrincipal <- as.numeric(encuestas$IdTecnologiaPrincipal)
encuestas$CargaLaboral <- as.numeric(encuestas$CargaLaboral)

# Escalado entre 0 y 1
# range01 <- function(x){(x-min(x))/(max(x)-min(x))}
# encuestas <- as.data.frame(sapply(encuestas, range01)) 
```

### Separación en sets

Selección de una submuestra de 450 (el 25% de los datos) para test El resto de los datos seràn de entrenamiento.

``` r
set.seed(101)
indices <- sample(1:nrow(encuestas),size=450)

entrenamiento_input <- encuestas[-indices,]
entrenamiento_output = Output[-indices]
entrenamiento <- entrenamiento_input
entrenamiento$Output <- entrenamiento_output

test_input <- encuestas[indices,]
test_output <- Output[indices]
```

### Armado de la red neuronal

``` r
# Outputs:
nombres <- names(encuestas)

# Inputs:
f <- paste(nombres,collapse=' + ')
f <- paste('Output ~',f)

# Formula:
f <- as.formula(f)

# -------------------


# Creación y entrenamiento de la red neuronal
# nn <- neuralnet(f,entrenamiento,hidden=c(10,10,10),stepmax=1000)
nn2 <- nnet(entrenamiento_input, entrenamiento_output,data=dat.in,size=10, maxit=10000, decay=0.001, reltol=FALSE)
```

    ## # weights:  111
    ## initial  value 333.538050 
    ## iter  10 value 254.417972
    ## iter  20 value 249.841742
    ## iter  30 value 246.963512
    ## iter  40 value 246.705567
    ## iter  50 value 246.657109
    ## iter  60 value 246.644219
    ## iter  70 value 243.311958
    ## iter  80 value 213.537345
    ## iter  90 value 204.745557
    ## iter 100 value 201.937323
    ## iter 110 value 200.652062
    ## iter 120 value 199.163740
    ## iter 130 value 198.522586
    ## iter 140 value 198.450369
    ## iter 150 value 198.432550
    ## iter 160 value 198.298942
    ## iter 170 value 198.259807
    ## iter 180 value 198.211917
    ## iter 190 value 196.701796
    ## iter 200 value 192.666646
    ## iter 210 value 190.626866
    ## iter 220 value 189.574490
    ## iter 230 value 189.322017
    ## iter 240 value 189.289234
    ## iter 250 value 189.055484
    ## iter 260 value 188.629325
    ## iter 270 value 188.132740
    ## iter 280 value 187.993449
    ## iter 290 value 187.615429
    ## iter 300 value 185.477059
    ## iter 310 value 182.942118
    ## iter 320 value 182.789999
    ## iter 330 value 182.706325
    ## iter 340 value 182.213797
    ## iter 350 value 180.327659
    ## iter 360 value 179.367445
    ## iter 370 value 178.124867
    ## iter 380 value 177.248945
    ## iter 390 value 175.209450
    ## iter 400 value 173.506264
    ## iter 410 value 172.832471
    ## iter 420 value 171.710562
    ## iter 430 value 170.622612
    ## iter 440 value 170.484835
    ## iter 450 value 170.470514
    ## iter 460 value 170.417073
    ## iter 470 value 170.106823
    ## iter 480 value 169.863543
    ## iter 490 value 169.801245
    ## iter 500 value 169.794941
    ## iter 510 value 169.791767
    ## iter 520 value 169.789530
    ## iter 530 value 169.781333
    ## iter 540 value 169.742893
    ## iter 550 value 169.706828
    ## iter 560 value 169.692149
    ## iter 570 value 169.684332
    ## iter 580 value 169.622890
    ## iter 590 value 169.593619
    ## iter 600 value 169.515430
    ## iter 610 value 169.453714
    ## iter 620 value 169.385005
    ## iter 630 value 169.226479
    ## iter 640 value 169.073521
    ## iter 650 value 169.025528
    ## iter 660 value 168.955856
    ## iter 670 value 168.866760
    ## iter 680 value 168.778288
    ## iter 690 value 168.714585
    ## iter 700 value 168.379398
    ## iter 710 value 168.030955
    ## iter 720 value 167.921640
    ## iter 730 value 167.863845
    ## iter 740 value 167.850692
    ## iter 750 value 167.841882
    ## iter 760 value 167.841244
    ## iter 770 value 167.841156
    ## iter 780 value 167.841129
    ## iter 790 value 167.841126
    ## iter 800 value 167.841124
    ## iter 810 value 167.841124
    ## iter 820 value 167.841123
    ## iter 830 value 167.841123
    ## iter 840 value 167.841123
    ## iter 850 value 167.841123
    ## iter 860 value 167.841123
    ## iter 870 value 167.841123
    ## iter 880 value 167.841123
    ## iter 890 value 167.841123
    ## iter 900 value 167.841123
    ## iter 910 value 167.841123
    ## iter 920 value 167.841123
    ## iter 930 value 167.841123
    ## iter 940 value 167.841123
    ## iter 950 value 167.841123
    ## final  value 167.841123 
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
    ##           0 221  39
    ##           1  71 119

### Visualización del modelo

``` r
# plot(nn)
plot.nnet(nn2)
```

![](tp_files/figure-markdown_github/Visualización%20del%20modelo-1.png)
