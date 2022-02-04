### Proyecto de Simulación y Programación Declarativa 

#### José Carlos Hernández Piñera C411

​	Para brindar una aceptada solución al problema propuesto se realizó un análisis y estudio de los temas ofrecidos en clase, así como la bibilografía brindada en todo lo referente a Haskell y al tema de Agentes. El problema se presenta en un ambiente accesible (de información completa), discreto, dinámico y determinista, esto posibilita que se puedan formular y por tanto seguir una serie de reglas con cada agente para garantizar que se cumpla el objetivo de mantener el 60% de las casillas vacías del ambiente, limpias.

**Modelación del problema y enfoque de los agentes:**

​	En el problema que se presenta existen muchos enfoques, todos propensos a fallas y  a que en determinadas circunstancias impidan que se concrete el objetivo, lo ideal sería quiza tener un agente proactivo, reactivo y sociable que sea capaz de analizar todo el ambiente que le rodea, su historia y responder en consecuencia de lo que a largo plazo pudiera ser mejor para el medio (o a corto, depende de lo que se persiga). 

​	Una característica que hubiera aportado una notable mejora al proyecto que se presenta, fuera brindar un agente sociable, que sea capaz de interactúar con el resto de los agentes del ambiente y de cierto modo, acordar las acciones que va a realizar cada uno; puesto que en el problema en cuestión si dos agentes deciden ir a recoger al mismo niño o limpiar la misma basura se está generando incongruencias en el medio, por decirlo de alguna forma, y pérdida de tiempo; ya que que hubiera sido mejor que se hubieran percatado que los dos iban a realizar la misma actividad y por tanto responder en consecuencia. Por supuesto, como todo, aquí también se presentan problemas a resolver, ¿ qué pasa si a cada agente no se dirige a la misma casilla del tablero, pero hubiera sido mejor que el agente A fuera a la casilla $X_1$ y el agente B fuera a la casilla $X_2$ ? ¿ de qué forma aborar esa problemática y como controlarla ?

​	En definitiva, en el proyecto se presentan dos implementaciones de agente puramente reactivos, que deciden que hacer sin referencia a su historia, puesto que  basan su desición enteramente en el presente y responden, por tanto, en consecuencia al ambiente que se define actualmente.

Tipo 1:  El agente de tipo 1 se rige por las siguientes pautas

- Si el robot está cargando a un niño entonces en el próximo paso acércate más al corral.
- Si el robot está sobre una suciedad entonces límpiala.
- Si el robot está sobre un niño entonces cárgalo.
- En otro caso se procede de la siguiente forma:
  - Busca el niño más cerca que tengas, avanza hacia él para cargarlo y llevarlo al corral lo antes posible.
  - En caso de que ya no queden niños fuera del corral, entonces buscar toda la basura que quede y proceder a limpiarla.

​	A modo de resumen lo que se persigue con este agente es que lleve lo más rápido posible a todos los niños al corral, para evitar con ello que se siga generando más basura en el ambiente; lo que cuál es, en definitiva, el objetivo de la simulación; a la hora de trasladarse por el tablero se da la posibilidad además, de que, si estamos sobre una suciedad esta pueda ser limpiada.

Tipo 2: El agente de tipo 2 se rige por las siguientes pautas

- Si el robot está cargando a un niño entonces en el próximo paso acércate más al corral.
- Si el robot está sobre una suciedad entonces límpiala.
- Si el robot está sobre un niño entonces cárgalo.
- En otro caso se procede de la siguiente forma:
  - Busca la suciedad más cercana al robot y procede a limpiarla
  - En caso de que ya no queden más basuras en el ambiente, entonces llevar a los niños al corral

​	A modo de resumen lo que se persigue con este agente un poco lo contrario al agente anterior, en este caso se quiere que primero se limpie toda la basura posible, llevando a los niños al corral de modo aislado si se encuentran durante el recorrido; y luego, entonces, proceder a realizar la tarea de llevar todos los niños de forma inmediata. 

​	Con este enfoque, se cree que se cumpla mejor el objetivo de mantener lo más reducida posible la suciedad, pero a largo plazo se va a pasar trabajo en llevar a todos los niños al corral y por tanto estos van a seguir ensuciando el medio cada vez que se muevan; por ello, sin analizar los resultados antes, se piensa que el agente de tipo 1 sea más eficiente, a pesar de que puede que el ambiente se ensucie un poco en determinada circunstancia, la cantidad máxima de basura va a comenzar a disminuir con respecto al tipo 2 en cuanto se cominecen a dejar niños dentro del corral, por el hecho de que no es posible para el niño ensuciar cuando esté dentro y luego una vez que se cumpla el objetivo de tomar todos los niños, entonces se procede de forma inmediata a limpiar el ambiente.

​	De cualquier forma los dos enfoques, pueden traer incumplimientos de la función principal de la simulación, ya que todo depende de la cantidad de agentes y niños que se posea, las dimensiones del tablero y por supuesto la cantidad de rondas que se permita simular el funcionamiento.

​	Mucha es la teoría que existe detrás del tema de agentes y existen muchas maneras de describir el entorno y de quizá trazar funciones que expresen algún tipo de métrica y ponderen por tanto el peso de las acciones, para en todo momento, poder realizar lo mejor para el medio; pero incluso esas funciones no son perfectas y puede darse el caso de que bajo ciertas circunstancias no arrojen los mejores resultados o los esperados quizá; por ello se escogió el enfoque propuesto, considerando siempre las dimensiones del problema planteado, que no son tan grandes, y que se pueda hasta cierto punto cumplir el objetivo.

**Ideas de implementación: **

​	La dificultad de la implementación no es excesivamente grande, se cuentan con varias estructuras, para cada uno de los items del ambiente (_agent_, _child_, _corral_, _dirty_ y _obstacle_), así como un tipo ambiente (_enviroment_) que recoje la descripción del medio y el estado en que se encuentra en todo momento. 

​	La generación del entorno, en la fase inicial se realiza de forma random, una vez proporcionadas las dimensiones del tablero y las cantidades que se quiere que existan de cada uno de los elementos.

​	Los movimientos están dados por medio de BFSs para garantizar con ello que se alcancen las posiciones en los mejores tiempos y por consiguientes con las distancias más cortas. 

​	Se presentan dos métodos o funciones fundamentales que son las que rigen el funcionamiento del entorno: _moveChilds_ y _moveAgents_, estas son las que se llaman en cada una de las iteraciones de la simulación y son las que posibilitan la interacción dentro del medio. Las ideas seguidas para la implementación de _moveAgents_ están recogidas al inicio del documento, mientras que para cada niño se decide, cuando sea el caso, si moverse o no y en circunstancias positivas y analizando su entorno más próximo si dejar o no basura en su movimiento, así como la cantidad a dejar. Todas estas acciones se realiza de manera random. 

​	Presentó quizá un especial interés la forma de ubicar a los niños dentro del corral, una vez que son llevado a este; pues puede dearse el caso de que, si se ponen mal, el corral se bloquee y por tanto no se pueda llegar a las posiciones centrales de este debido a que todas las exteriores están ocupadas y por tanto el BFS no llega al interior. 

​	Para darle solución a dicha cuestión se elije de forma un poco inteligente, en cuál casilla ubicar al niño, una vez que el agente lo haya recogido. Para ello se lleva una especie de métrica con las posiciones de las casillas, considerando que el centro del corral, que se define al inicio, vale 0, las adyacentes no diagonales valen +1 y las adyacentes diagonales valen +2 y asi sucesivamente con todas las casillas del corral. Esta especie de valor se calcula para cada una de las celdas del corral y la celda vacías que menor valor tenga es la que se elige para dejar al niño; con ello las posiciones se toman a partir del centro del corral, asegurando que no se bloquee este en ningún momento, puesto que es siempre posbile acceder a todas.

​	Debido a la dificultad de hacer debug en haskell, cada función tiene una especie de _wrap_ que fue lo que posibilitó que se hiciera su test adecuado y que se corrigieran los problemas que se encontraron durante el desarrollo del mismo.

​	El archivo que contiene la mayor parte de la lógica del proyecto es _Enviroment.hs_ que se encuetra dentro de src/Items; ahí están recogidos todos los aspectos del funcionamiento del mismo y demás funciones de cálculo útiles a la hora de arrojar los resultados de la simulación. 

​	El resto de los ficheros dentro de Items, describe cada una de los elementos del sistema y presenta algunos métodos útiles relacionados con dichos elementos. 

​	La función principal del proyecto (el main por así decirlo) y la que ejecuta la simulación está en _app/Main.hs_, se pueden dirigir a ella sin problemas para realizar cualquier variación en los parámetros iniciales y probar cualquier _wrap_ de los que se ofrece.

**Como ejecutar el proyecto**:

​	Para el desarrollo del proyecto se utilizó una herramienta externa llamada stack, que facilita el manejo de las dependencias y por tanto la efectiva ejecución del mismo. Se hace necesario tener, por tanto esta herramienta instalada, para garantizar el mismo entorno de ejecución que se usó durante la realización. Una vez instalada la herramienta el siguiente comando se encarga de la ejecución:

```bash
stack build && stack exec Agents-exe
```

Para realizar una especie de comparación se presenta ahora un ejemplo para un tablero de dimensiones (7, 7) que cuenta con 5 niños, 2 obstáculos, 3 agentes y 5 casillas sucias al inicio. Se presenta para los dos tipos de agentes los resultados obtenidos luego de realizar 10 simulaciones con esos parámetros y cada simulación 1000 iteraciones del entorno.

| Simulation Agent Type 1 | Simulation Agent Type 2 |
| :---------------------: | :---------------------: |
|    38.46153846153846    |   12.820512820512821    |
|    35.8974358974359     |   7.6923076923076925    |
|   20.512820512820515    |    17.94871794871795    |
|   20.512820512820515    |   12.820512820512821    |
|   20.512820512820515    |   12.820512820512821    |
|           0.0           |   10.256410256410257    |
|   28.205128205128204    |   12.820512820512821    |
|   15.384615384615385    |   7.6923076923076925    |
|    41.02564102564103    |   7.6923076923076925    |
|   25.641025641025642    |   2.5641025641025643    |

​                             **% de suciedad del tablero luego de terminada cada simulación**

​	Estos valores que se muestran indican el porciento del tablero que quedó sucio después de terminada la simulación, solamente existe un caso en los agentes de tipo 1 donde la suciedad sobrepasa el 40% y por tanto se incumple el objetivo, sin embargo hay un caso para este agente también donde se pudo limpiar toda la suciedad del entorno (esto fue debido a que se pudieron llevar todos los niños al corral). Afortunadamente el resto de los casos fueron satisfactorios. Para el agente de tipo 2 los resultados se muestran un poco mejor debido a que este se encarga de limpiar siempre primero y luego llevar a los niños, pero si chequearamos el estado final del ambiente luego de terminar la simulación se comprobaría que en efecto quedan bastantes niños fuera del corral.



​	Presentamos ahora otro ejemplo, con las mismas condiciones iniciales, pero ahora solo variando la cantidad de iteraciones por simulación, en este caso se realizan 2000.

| Simulation Agent Type 1 | Simulation Agent Type 2 |
| :---------------------: | :---------------------: |
|   23.076923076923077    |   20.512820512820515    |
|   20.512820512820515    |   10.256410256410257    |
|   20.512820512820515    |   12.820512820512821    |
|    30.76923076923077    |    5.128205128205129    |
|    30.76923076923077    |   12.820512820512821    |
|           0.0           |   7.6923076923076925    |
|   12.820512820512821    |   12.820512820512821    |
|    17.94871794871795    |    5.128205128205129    |
|           0.0           |   15.384615384615385    |
|   28.205128205128204    |   20.512820512820515    |

​                                        **% de suciedad del tablero luego de terminada cada simulación**