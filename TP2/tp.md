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
encuestas <- read.csv("./datos.csv")
encuestas$X <- NULL
```

### Resumen de datos

Visualizamos un resumen de los datos que vamos a usar para esta clasificación.

``` r
# ----------------------  imprimir resumen de campos  ----------------------

str(encuestas)
```

    ## 'data.frame':    17940 obs. of  46 variables:
    ##  $ Edad                               : int  32 34 52 37 26 31 39 33 30 31 ...
    ##  $ IdSexo                             : Factor w/ 3 levels "Femenino","Masculino",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ IdNivelEducativo                   : Factor w/ 10 levels "Master o postgrado completo",..: 10 10 9 10 10 7 9 9 10 10 ...
    ##  $ IdTipoDeEmpresa                    : Factor w/ 7 levels "Mi propia empresa",..: 6 6 6 6 6 6 6 6 6 6 ...
    ##  $ IdProvincia                        : Factor w/ 28 levels "Buenos Aires",..: 1 12 3 2 3 3 28 1 25 3 ...
    ##  $ IdPuesto                           : Factor w/ 90 levels "Administrador de Almacenamiento (Storage)",..: 6 28 6 39 77 27 28 4 45 27 ...
    ##  $ horasTrabajadasXSemana             : int  40 45 40 40 35 40 40 50 40 40 ...
    ##  $ TrabajaDesdeCasa                   : Factor w/ 2 levels "No","Si": 1 1 1 1 1 2 2 1 1 1 ...
    ##  $ LeGustaTrabajarDesdeCasa           : Factor w/ 2 levels "No","Si": 2 2 1 2 2 2 1 2 2 2 ...
    ##  $ MesesDeExperiencia                 : int  96 36 144 96 12 12 36 60 6 60 ...
    ##  $ IdTecnologiaPrincipal              : Factor w/ 65 levels ".Net","ActionScript",..: 41 1 41 20 41 29 36 36 53 45 ...
    ##  $ MesesEnElPuestoActual              : int  36 36 0 36 28 18 30 60 24 24 ...
    ##  $ SalarioActualNeto                  : int  6000 4500 4300 4750 3300 4900 3200 3900 3200 4500 ...
    ##  $ SalarioIdealNeto                   : int  10000 7500 6500 6500 4100 6000 4500 5000 5000 6800 ...
    ##  $ SeSientePresionado                 : int  0 0 0 0 0 0 0 0 10 0 ...
    ##  $ SeSienteSobreexigido               : int  10 0 0 0 0 0 10 0 10 0 ...
    ##  $ EnElLugarSeDesarrolla              : int  0 10 10 10 10 10 0 10 1 10 ...
    ##  $ LaboresDiariasGratas               : int  10 10 10 10 0 10 10 10 0 10 ...
    ##  $ SeLoReconoceComoDebiera            : int  10 10 10 0 10 10 0 0 0 10 ...
    ##  $ HayDesarrolloProfesional           : int  10 10 10 0 0 10 10 0 0 0 ...
    ##  $ SeSienteMotivado                   : int  10 10 10 0 0 10 10 0 0 0 ...
    ##  $ RelacionConJefes                   : int  8 10 10 9 9 6 9 8 4 10 ...
    ##  $ CambioPorMejorSalario              : Factor w/ 2 levels "No","Si": 2 2 1 2 2 2 2 2 2 2 ...
    ##  $ CambioPorMejorAmbiente             : Factor w/ 2 levels "No","Si": 1 1 1 2 1 1 2 1 2 1 ...
    ##  $ CambioPorFormaDeTrabajo            : Factor w/ 2 levels "No","Si": 1 2 1 2 2 1 2 2 2 2 ...
    ##  $ CambioPorTecnologia                : Factor w/ 2 levels "No","Si": 1 1 1 2 2 1 2 2 1 2 ...
    ##  $ NoCambio                           : Factor w/ 2 levels "False","True": 1 1 2 1 1 1 1 1 1 1 ...
    ##  $ CantidadDeMesesParaCambiarDeTrabajo: int  NA 12 NA 1 1 12 12 1 12 12 ...
    ##  $ NivelDeDesconfianza                : int  0 0 0 0 0 0 1 0 0 0 ...
    ##  $ CambioPorCercania                  : Factor w/ 3 levels "No","No informa",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ CambioPorMenorCargaHoraria         : Factor w/ 3 levels "No","No informa",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ CambioPorOportunidadDeCarrera      : Factor w/ 3 levels "No","No informa",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ TienePersonasACargo                : Factor w/ 3 levels "No","No informa",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ RelaciónLaboral                    : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ Anio                               : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
    ##  $ Mes                                : int  6 6 6 6 6 6 6 6 6 6 ...
    ##  $ Semestre                           : Factor w/ 2 levels "Primer","Segundo": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Hora                               : int  10 10 10 10 11 11 11 11 11 11 ...
    ##  $ RangoHora                          : Factor w/ 5 levels "Madrugada","Mañana",..: 2 2 2 2 3 3 3 3 3 3 ...
    ##  $ DiferenciaSalarioRealIdeal         : int  4000 3000 2200 1750 800 1100 1300 1100 1800 2300 ...
    ##  $ SalarioNetoPorHora                 : num  150 100 107.5 118.8 94.3 ...
    ##  $ RangoSalario                       : Factor w/ 5 levels "Alto","Bajo",..: 2 5 5 5 5 5 5 5 5 5 ...
    ##  $ CargaLaboral                       : Factor w/ 4 levels "Extra Time","Full Time",..: 2 2 2 2 3 2 2 1 2 2 ...
    ##  $ Antiguedad                         : Factor w/ 4 levels "Expert","Junior",..: 3 3 NA 3 3 2 3 4 3 3 ...
    ##  $ Experiencia                        : Factor w/ 4 levels "Expert","Junior",..: 4 3 1 4 2 2 3 3 2 3 ...
    ##  $ RangoEdad                          : Factor w/ 10 levels "(0,20]","(20,25]",..: 4 4 8 5 3 4 5 4 3 4 ...

``` r
summary(encuestas)
```

    ##       Edad              IdSexo     
    ##  Min.   :18.00   Femenino  : 1859  
    ##  1st Qu.:28.00   Masculino :14926  
    ##  Median :32.00   No informa: 1155  
    ##  Mean   :33.52                     
    ##  3rd Qu.:38.00                     
    ##  Max.   :65.00                     
    ##                                    
    ##                                  IdNivelEducativo
    ##  Universitario en curso o incompleto     :6015   
    ##  Universitario completo                  :4181   
    ##  Terciario completo                      :3445   
    ##  Terciario en curso o incompleto         :1397   
    ##  Secundario completo                     :1107   
    ##  Master o postgrado en curso o incompleto: 873   
    ##  (Other)                                 : 922   
    ##                       IdTipoDeEmpresa           IdProvincia  
    ##  Mi propia empresa            :  381   Buenos Aires   :6817  
    ##  No informa                   : 1376   Capital Federal:6695  
    ##  Otro                         :  317   CÃ³rdoba       :1671  
    ##  Soy independiente / freelance:  102   Sante Fe       : 710  
    ##  Un organismo estatal         :  980   GBA Zona Norte : 453  
    ##  Una empresa privada          :14726   Mendoza        : 321  
    ##  Una ONG                      :   58   (Other)        :1273  
    ##                                     IdPuesto    horasTrabajadasXSemana
    ##  Desarrollador de software / Programador:4694   Min.   :20.00         
    ##  Analista Funcional                     :1325   1st Qu.:40.00         
    ##  Lider de Proyecto                      :1244   Median :40.00         
    ##  Consultor TI                           : 890   Mean   :41.52         
    ##  Soporte TÃ©cnico                       : 672   3rd Qu.:45.00         
    ##  Gerente de Sistemas                    : 623   Max.   :96.00         
    ##  (Other)                                :8492                         
    ##  TrabajaDesdeCasa LeGustaTrabajarDesdeCasa MesesDeExperiencia
    ##  No:14374         No: 5588                 Min.   :  0.00    
    ##  Si: 3566         Si:12352                 1st Qu.: 36.00    
    ##                                            Median : 60.00    
    ##                                            Mean   : 65.58    
    ##                                            3rd Qu.: 96.00    
    ##                                            Max.   :144.00    
    ##                                                              
    ##  IdTecnologiaPrincipal MesesEnElPuestoActual SalarioActualNeto
    ##  .Net   :3812          Min.   :  0.0         Min.   : 3011    
    ##  Windows:2557          1st Qu.:  9.0         1st Qu.: 6000    
    ##  Java   :2447          Median : 24.0         Median : 9000    
    ##  Otro   :1338          Mean   : 33.9         Mean   :10811    
    ##  Oracle :1086          3rd Qu.: 48.0         3rd Qu.:13500    
    ##  SAP    :1047          Max.   :456.0         Max.   :70000    
    ##  (Other):5653                                                 
    ##  SalarioIdealNeto SeSientePresionado SeSienteSobreexigido
    ##  Min.   :    0    Min.   : 0.000     Min.   : 0.000      
    ##  1st Qu.: 8000    1st Qu.: 2.000     1st Qu.: 1.000      
    ##  Median :12000    Median : 5.000     Median : 5.000      
    ##  Mean   :14563    Mean   : 4.815     Mean   : 4.728      
    ##  3rd Qu.:18000    3rd Qu.: 7.000     3rd Qu.: 7.000      
    ##  Max.   :85000    Max.   :10.000     Max.   :10.000      
    ##                                                          
    ##  EnElLugarSeDesarrolla LaboresDiariasGratas SeLoReconoceComoDebiera
    ##  Min.   : 0.0          Min.   : 0.000       Min.   : 0.000         
    ##  1st Qu.: 3.0          1st Qu.: 5.000       1st Qu.: 3.000         
    ##  Median : 6.0          Median : 7.000       Median : 5.000         
    ##  Mean   : 6.1          Mean   : 6.744       Mean   : 5.265         
    ##  3rd Qu.: 9.0          3rd Qu.:10.000       3rd Qu.: 8.000         
    ##  Max.   :10.0          Max.   :10.000       Max.   :10.000         
    ##                                                                    
    ##  HayDesarrolloProfesional SeSienteMotivado RelacionConJefes
    ##  Min.   : 0.000           Min.   : 0.000   Min.   : 0.000  
    ##  1st Qu.: 2.000           1st Qu.: 2.000   1st Qu.: 6.000  
    ##  Median : 5.000           Median : 5.000   Median : 8.000  
    ##  Mean   : 5.141           Mean   : 5.316   Mean   : 7.212  
    ##  3rd Qu.: 8.000           3rd Qu.: 8.000   3rd Qu.: 9.000  
    ##  Max.   :10.000           Max.   :10.000   Max.   :10.000  
    ##                                                            
    ##  CambioPorMejorSalario CambioPorMejorAmbiente CambioPorFormaDeTrabajo
    ##  No: 3411              No:12969               No:10042               
    ##  Si:14529              Si: 4971               Si: 7898               
    ##                                                                      
    ##                                                                      
    ##                                                                      
    ##                                                                      
    ##                                                                      
    ##  CambioPorTecnologia  NoCambio     CantidadDeMesesParaCambiarDeTrabajo
    ##  No:12661            False:15872   Min.   : 0.000                     
    ##  Si: 5279            True : 2068   1st Qu.: 0.000                     
    ##                                    Median : 6.000                     
    ##                                    Mean   : 5.379                     
    ##                                    3rd Qu.:12.000                     
    ##                                    Max.   :12.000                     
    ##                                    NA's   :5588                       
    ##  NivelDeDesconfianza  CambioPorCercania CambioPorMenorCargaHoraria
    ##  Min.   :0.0000      No        :10602   No        :10900          
    ##  1st Qu.:0.0000      No informa: 3396   No informa: 3396          
    ##  Median :0.0000      Si        : 3942   Si        : 3644          
    ##  Mean   :0.2838                                                   
    ##  3rd Qu.:0.0000                                                   
    ##  Max.   :5.0000                                                   
    ##                                                                   
    ##  CambioPorOportunidadDeCarrera TienePersonasACargo RelaciónLaboral
    ##  No        :6391               No        :9725     Min.   :0.00   
    ##  No informa:3396               No informa:4603     1st Qu.:1.00   
    ##  Si        :8153               Si        :3612     Median :1.00   
    ##                                                    Mean   :1.02   
    ##                                                    3rd Qu.:1.00   
    ##                                                    Max.   :3.00   
    ##                                                    NA's   :4603   
    ##       Anio           Mes            Semestre          Hora      
    ##  Min.   :2010   Min.   : 1.000   Primer :10291   Min.   : 0.00  
    ##  1st Qu.:2011   1st Qu.: 2.000   Segundo: 7649   1st Qu.:10.00  
    ##  Median :2013   Median : 6.000                   Median :13.00  
    ##  Mean   :2013   Mean   : 5.497                   Mean   :13.26  
    ##  3rd Qu.:2014   3rd Qu.: 8.000                   3rd Qu.:17.00  
    ##  Max.   :2016   Max.   :12.000                   Max.   :23.00  
    ##                                                                 
    ##      RangoHora    DiferenciaSalarioRealIdeal SalarioNetoPorHora
    ##  Madrugada:1381   Min.   :-4800              Min.   :  46.25   
    ##  Mañana   :3789   1st Qu.: 1600              1st Qu.: 147.17   
    ##  Mediodia :5006   Median : 3000              Median : 212.50   
    ##  Noche    :2591   Mean   : 3752              Mean   : 263.14   
    ##  Tarde    :4824   3rd Qu.: 5000              3rd Qu.: 325.00   
    ##  NA's     : 349   Max.   :29500              Max.   :1425.00   
    ##                                                                
    ##    RangoSalario           CargaLaboral        Antiguedad  
    ##  Alto    :3592   Extra Time     : 1390   Expert    :2304  
    ##  Bajo    :2754   Full Time      :14902   Junior    :7672  
    ##  Medio   :7328   Part Time      : 1256   SemiSenior:4600  
    ##  Muy Alto:1493   Very Extra Time:  392   Senior    :3063  
    ##  Muy Bajo:2772                           NA's      : 301  
    ##  NA's    :   1                                            
    ##                                                           
    ##      Experiencia     RangoEdad   
    ##  Expert    :3555   (30,35]:4866  
    ##  Junior    :3282   (25,30]:4794  
    ##  SemiSenior:7368   (35,40]:3023  
    ##  Senior    :2829   (20,25]:2226  
    ##  NA's      : 906   (40,45]:1455  
    ##                    (45,50]: 836  
    ##                    (Other): 740

``` r
# ----------------------   primeros campos  ---------------------- 
kable(head(encuestas))
```

|  Edad| IdSexo    | IdNivelEducativo                    | IdTipoDeEmpresa     | IdProvincia     | IdPuesto                                |  horasTrabajadasXSemana| TrabajaDesdeCasa | LeGustaTrabajarDesdeCasa |  MesesDeExperiencia| IdTecnologiaPrincipal |  MesesEnElPuestoActual|  SalarioActualNeto|  SalarioIdealNeto|  SeSientePresionado|  SeSienteSobreexigido|  EnElLugarSeDesarrolla|  LaboresDiariasGratas|  SeLoReconoceComoDebiera|  HayDesarrolloProfesional|  SeSienteMotivado|  RelacionConJefes| CambioPorMejorSalario | CambioPorMejorAmbiente | CambioPorFormaDeTrabajo | CambioPorTecnologia | NoCambio |  CantidadDeMesesParaCambiarDeTrabajo|  NivelDeDesconfianza| CambioPorCercania | CambioPorMenorCargaHoraria | CambioPorOportunidadDeCarrera | TienePersonasACargo |  RelaciónLaboral|  Anio|  Mes| Semestre |  Hora| RangoHora |  DiferenciaSalarioRealIdeal|  SalarioNetoPorHora| RangoSalario | CargaLaboral | Antiguedad | Experiencia | RangoEdad |
|-----:|:----------|:------------------------------------|:--------------------|:----------------|:----------------------------------------|-----------------------:|:-----------------|:-------------------------|-------------------:|:----------------------|----------------------:|------------------:|-----------------:|-------------------:|---------------------:|----------------------:|---------------------:|------------------------:|-------------------------:|-----------------:|-----------------:|:----------------------|:-----------------------|:------------------------|:--------------------|:---------|------------------------------------:|--------------------:|:------------------|:---------------------------|:------------------------------|:--------------------|----------------:|-----:|----:|:---------|-----:|:----------|---------------------------:|-------------------:|:-------------|:-------------|:-----------|:------------|:----------|
|    32| Masculino | Universitario en curso o incompleto | Una empresa privada | Buenos Aires    | Administrador de Redes                  |                      40| No               | Si                       |                  96| Otro                  |                     36|               6000|             10000|                   0|                    10|                      0|                    10|                       10|                        10|                10|                 8| Si                    | No                     | No                      | No                  | False    |                                   NA|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    10| Mañana    |                        4000|           150.00000| Bajo         | Full Time    | SemiSenior | Senior      | (30,35\]  |
|    34| Masculino | Universitario en curso o incompleto | Una empresa privada | GBA Zona Oeste  | Director de Sistemas                    |                      45| No               | Si                       |                  36| .Net                  |                     36|               4500|              7500|                   0|                     0|                     10|                    10|                       10|                        10|                10|                10| Si                    | No                     | Si                      | No                  | False    |                                   12|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    10| Mañana    |                        3000|           100.00000| Muy Bajo     | Full Time    | SemiSenior | SemiSenior  | (30,35\]  |
|    52| Masculino | Universitario completo              | Una empresa privada | Capital Federal | Administrador de Redes                  |                      40| No               | No                       |                 144| Otro                  |                      0|               4300|              6500|                   0|                     0|                     10|                    10|                       10|                        10|                10|                10| No                    | No                     | No                      | No                  | True     |                                   NA|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    10| Mañana    |                        2200|           107.50000| Muy Bajo     | Full Time    | NA         | Expert      | (50,55\]  |
|    37| Masculino | Universitario en curso o incompleto | Una empresa privada | CÃ³rdoba        | Gerente de Operaciones                  |                      40| No               | Si                       |                  96| Delphi                |                     36|               4750|              6500|                   0|                     0|                     10|                    10|                        0|                         0|                 0|                 9| Si                    | Si                     | Si                      | Si                  | False    |                                    1|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    10| Mañana    |                        1750|           118.75000| Muy Bajo     | Full Time    | SemiSenior | Senior      | (35,40\]  |
|    26| Masculino | Universitario en curso o incompleto | Una empresa privada | Capital Federal | Otro                                    |                      35| No               | Si                       |                  12| Otro                  |                     28|               3300|              4100|                   0|                     0|                     10|                     0|                       10|                         0|                 0|                 9| Si                    | No                     | Si                      | Si                  | False    |                                    1|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    11| Mediodia  |                         800|            94.28571| Muy Bajo     | Part Time    | SemiSenior | Junior      | (25,30\]  |
|    31| Masculino | Terciario completo                  | Una empresa privada | Capital Federal | Desarrollador de software / Programador |                      40| Si               | Si                       |                  12| Java                  |                     18|               4900|              6000|                   0|                     0|                     10|                    10|                       10|                        10|                10|                 6| Si                    | No                     | No                      | No                  | False    |                                   12|                    0| No informa        | No informa                 | No informa                    | No informa          |               NA|  2010|    6| Primer   |    11| Mediodia  |                        1100|           122.50000| Muy Bajo     | Full Time    | Junior     | Junior      | (30,35\]  |

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
# nn2 <- nnet(entrenamiento_input, entrenamiento_output,data=dat.in,size=10, maxit=10000, decay=0.001, reltol=FALSE)
```

### Evaluación del modelo

``` r
# Calculamos las predicciones usando el modelo
# predicciones <- compute(nn,test_input)
# predicciones <- predict(nn2, test_input)

# Redondiamos la salida del modelo (si es > 0.5 lo consideramos 1)
# predicciones <- sapply(predicciones$net.result,round,digits=0)
# predicciones <- sapply(predicciones,round,digits=0)

# Validamos las predicciones con los valores reales.
# table(test_output,predicciones)
```

### Visualización del modelo

``` r
# plot(nn)
# plot.nnet(nn2)
```
