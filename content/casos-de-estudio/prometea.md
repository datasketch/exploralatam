---
title: "Prometea"
date: 2019-07-29T14:21:28-05:00
---

Prometea surgió en 2017 como una herramienta de inteligencia artificial (IA) predictiva para elaborar dictámenes judiciales de manera rápida, acelerando los procesos de resolución de casos los casos (Corvalán, 2017) en la Ciudad de Buenos Aires. La idea del proyecto estuvo estrechamente relacionada a disminuir un conjunto de tareas reiteradas y rutinarias en casos judiciales similares entre sí. El desarrollo se realizó íntegramente en el ámbito de la Fiscalía General del [Ministerio Público Fiscal de la Ciudad de Buenos Aires](https://www.fiscalias.gob.ar/), donde actualmente funciona. A poco de su creación, la institución ya firmó convenios para su aplicación en otros ámbitos, tales como la [Asociación de Mujeres Jueces de la República Argentina (AMJA)](https://www.fiscalias.gob.ar/project/la-fiscalia-firmo-convenio-con-la-asociacion-de-mujeres-jueces-de-la-republica-argentina/) y la Corte Interamericana de Derechos Humanos.

Juan Corvalán y Luis Cevasco, fiscales generales adjuntos del Ministerio Público porteño, fueron quienes lideraron el proyecto, que también estuvo integrado por todo el equipo de la Fiscalía General de la Ciudad e Ignacio Raffa y Nicolás Vilella, especialistas en IA.

Para un conjunto determinado de casos, Prometea permite detectar cuál es la respuesta judicial adecuada que debería brindarse en un promedio de 20 segundos.

Una vez que el expediente judicial ingresa a una fiscalía, se carga su número en la herramienta. A continuación, Prometea busca esa carátula en el Tribunal Superior de Justicia y lo asocia con otro expediente. Luego, lee las sentencias de primera y segunda instancia del Poder Judicial de la Ciudad y analiza más de 300.000 documentos. En ese momento, a través de la búsqueda y detección de determinadas palabras clave predefinidas con anterioridad, genera un modelo de dictamen sobre cómo debería resolverse ese expediente. Dicho documento es posteriormente controlado por el funcionario judicial a cargo, quien puede editarlo, descargarlo e imprimirlo desde la aplicación.

Para uno de sus creadores, el trabajo de Prometea se reduce a “predecir si se configuran situaciones y hechos sobre los cuales ya existe una tendencia jurisprudencial muy firme” (Corvalán 2018). Además, afirman que Prometea “funciona mediante aprendizaje automático trazable, auditable y reversible. Esto quiere decir que no es una “caja negra” (black box) y que es perfectamente posible establecer cuál es el razonamiento subyacente para elaborar la predicción”.

Una de las características más destacadas de Prometea es que funciona como un asistente virtual. La herramienta le realiza al usuario una serie de preguntas que pueden responderse a través de indicaciones orales o de un chat. Cuenta con la opción de búsqueda avanzada de documentos y leyes. El sistema se utiliza en la actualidad en expedientes de causas de empleo público, derecho a la vivienda (donde se incluyen distintas variables dependiendo si la causa involucra menores de edad, personas con discapacidad, etc.) y cuestiones procesales que son las que ocupan la mayor cantidad de tiempo de trabajo por el volumen de cantidad de causas (60% de las tareas dentro de la Fiscalía de la Ciudad).

La aplicación tiene también otra característica destacada: permite el control formal de los expedientes al contar con una funcionalidad que permite hacer un control de plazos en segundos y verificar si los recursos interpuestos por las partes se encuentran o no en término sin salir del asistente.

Por último, Prometea no busca reemplazar la inteligencia humana, por el contrario, la potencia para mejorar la toma de decisiones en la las instituciones públicas (Corvalán, 2018).

A futuro la herramienta busca extenderse a trámites y servicios judiciales. En paralelo, su uso se está adaptando a otras áreas como las compras públicas gubernamentales.

## Background y contexto

Los inicios de Prometea estuvieron precedidos por la sistematización de jurisprudencia del Tribunal Superior de Justicia de la Ciudad de Buenos Aires (TSJ CABA). La Fiscalía General Adjunta en lo Contencioso Administrativo y Tributario de esa jurisdicción, a cargo de Juan Corvalán, [comenzó a publicar cuadernos](https://es-es.facebook.com/mpfcaba/posts/cuadernillo-de-jurisprudencia-sobre-medidas-cautelares-del-tribunal-superior-de-/1435822176490972/) con información de fallos y material considerado “de relevancia académica y práctica” para funcionarios judiciales. Este trabajo se realizó sobre 1200 fallos del TSJ CABA e incluyó temas diversos, como por ejemplo, medidas cautelares, derecho a la vivienda y caducidad fueron algunos de los temas abordados por esta iniciativa. [La idea detrás de los cuadernillos digitales era que, si bien podía accederse a los documentos de manera online, al reunir la información el proceso podía agilizarse para que los empleados judiciales pudieran realizar sus tareas cotidianas de manera más sencilla](https://www.fiscalias.gob.ar/wp-content/uploads/2017/02/Analisis-y-Sistematizaci%C3%B3n-final.pdf). En estos cuadernillos se detallan los párrafos más importantes de los casos decididos por el TSJ y algunos de los criterios jurisprudenciales sobre las temáticas más importantes. En total, durante 2016 se sistematizaron más de 1200 fallos del TSJ.

Luego de este proceso, los fiscales Cevasco y Corvalán, junto a su equipo comenzaron a pensar en la posibilidad de desarrollar una herramienta que les permitiera automatizar la parte de su trabajo que consideraban repetitivo y rutinario. Por ejemplo, si ante un hecho el TSJ ya había resuelto de determinada manera, la tecnología podía ayudarlos a revisar de manera rápida los casos existentes sobre la temática y evitar hacerlo manualmente utilizando numerosas horas laborales. Así, comenzaron investigar sobre IA y desarrollaron Prometea.

Desde la fiscalía destacan que la sistematización de los fallos del TSJ fue de suma importancia porque les permitió generar una base de conocimiento para posteriormente incorporar Prometea de manera rápida ya que el sistema requería de un ordenamiento previo de documentos. Ello posibilitó que el equipo de funcionarios judiciales , trabajando en conjunto con el experto en IA , entrenaran a través de algoritmos a un dataset de más de 2400 expedientes judiciales, y 1400 opiniones legales de la Fiscalía de la Ciudad que previamente habían sido agrupados en temas y subtemas.

Sus creadores definen Prometea a través de 4 características. La consideran una herramienta innovadora porque el sistema fue desarrollado íntegramente en Argentina con un equipo interdisciplinario. También la definen una iniciativa “exponencial” al acelerar y mejorar procesos burocráticos. Es “inclusiva” porque su diseño contempla las necesidades de personas con capacidades diferentes. Además, resulta accesible ya que los funcionarios judiciales pueden utilizarla a través de un asistente de voz y no es necesaria la capacitación previa.

Otra de las características destacadas de la aplicación es que usa el formato de pantalla integrada, lo cual resulta de gran utilidad para el usuario, que no necesita salir del asistente en ningún momento. Ello así por cuanto Prometea integra, por ejemplo, una opción de búsqueda avanzada de documentos y leyes; un calendario inteligente y una solapa de recursos de donde se podrá extraer información de relevancia que podrá utilizarse en el documento a crear.

Para la realización del proyecto, hasta el momento el Ministerio Público de la Ciudad desembolsó 1.600.000 pesos argentinos.

## Beneficios de la herramienta para la gestión pública y los derechos de los ciudadanos

Para los creadores de Prometea, este sistema de inteligencia artificial baja los niveles de burocracia en expedientes poco complejos y permite que los funcionarios judiciales puedan dedicarle más tiempo a causas de delitos más complicados .El equipo que desarrolló la plataforma destaca que la baja complejidad “no tiene que ver con la cuestión de fondo, sino con el grado de estandarización de la respuesta judicial que se brinda ante una determinada situación de hecho. En su faceta predictiva, Prometea actúa en cinco supuestos que consideramos “casos estandarizados”. En ellos, el criterio y la jurisprudencia son uniformes con lo cual, siempre que se dan determinadas circunstancias se llega a una misma conclusión. Los temas que están involucrados detrás de estos dictámenes que se realizan con Prometea son derecho a la vivienda en diversos casos, por ejemplo relacionado a personas con discapacidad y derecho al trabajo enfocado en el empleo público”.

La clave del proyecto también es la reducción de la cantidad de clics y las ventanas digitales abiertas, aumentando la eficacia y la calidad de las decisiones tomadas, al funcionar bajo la modalidad de pantalla integrada. Además, desde el Ministerio Público Fiscal afirman que Prometea fortalece la seguridad jurídica: "Ante una situación de hecho análoga a otra sobre estas cuestiones, la respuesta al ciudadano siempre será la misma (siempre y cuando se mantenga el criterio judicial". En paralelo, monitorean el funcionamiento de Prometea, para refinar las palabras claves con las que trabaja y aumentar la tasa de acierto en la predicción que a fines de 2018 rondaba el 96%. Esta cifra se calculó teniendo en cuenta los dictámenes y sentencias con los que comenzó a trabajar Prometea (ver cuadro a continuación).

| Tema                                 | Detectados | Correctos | % Correcto de los detectados |
| ------------------------------------ | :--------: | :-------: | :--------------------------: |
| Empleo público - rubros remunetarios | 24         | 24        | 100%                         |
| Transferencias de licencias taxi     | 26         | 26        | 100%                         |
| Empleo público - Material didáctico  | 27         | 26        | 96%                          |
| Vivienda - personas con discapacidad | 72         | 69        | 96%                          |
| Vivienda - menores de edad           | 34         | 31        | 91%                          |
| **Total**                            | 183        | 176       | 96%                          |

En la presentación de la herramienta realizada ante la Organización de Estados Americanos, Juan Corvalán brindó algunas estadísticas sobre la reducción de tiempos en los expedientes judiciales. Calculando 6 horas de trabajo diarias y 22 días laborales al mes, a esta aplicación de IA le lleva solo 45 días elaborar 1000 dictámenes relacionados a expedientes del derecho a la vivienda; del modo tradicional, este trabajo tiene un tiempo estimado de 174 días. Los casos relativos al derecho al trabajo implican un promedio de 83 días laborales, con Prometea el trámite se reduce a solo 5.

Prometea también es utilizada para el proceso de compras públicas de la Ciudad de Buenos Aires. En estos casos, aun cuando todo el procedimiento es digital, se requerían de 29 días en promedio, 670 clics, la apertura de 60 ventanas y como mínimo la carga de 35 datos que se copian y pegan en el sistema de gestión digital para generar los pliegos de la contratación y la resolución o acto administrativo que ordena la publicación y el llamado a ofertar. Como complemento, incorpora una funcionalidad de control de precios públicos y privados del bien que se quiera adquirir, a efectos de tener una referencia de mercado.

En el ámbito de la Corte Interamericana de Derechos Humanos el sistema está listo para generar notificaciones en cuatro idiomas en apenas segundos. De acuerdo a los postulados de las personas que trabajan en la Corte, la realización de esta tarea -que implicaba controlar nombres, domicilios, cargos, etc.- requería de 3 días de trabajo, mientras que Prometea puede realizarla en solo 2 minutos. Asimismo, integra una herramienta de búsqueda avanzada y permite crear una resolución en minutos

## Desafíos y algunas pautas a tener en cuenta

Los modelos de dictamen generados a través de la herramienta deben ser revisados exhaustivamente por el funcionario o agente judicial a cargo para evitar errores. Por este motivo, desde el Ministerio Público porteño insisten en que la verificación, validación y evaluación del documento son pasos obligatorios para cualquier funcionario judicial que utilice el sistema. En este sentido, enfatizan en la necesidad de que la tecnología sea “custodiada” por el trabajo humano: “Prometea logra que se llegue a esa decisión de una manera más rápida y simple, pero quien adopta y toma la decisión propuesta por Prometea, es el funcionario habilitado para ello (...) la propuesta de dictamen de Prometea, queda sujeta en la totalidad de los casos y sin excepción al posterior control humano”.

La herramienta no es aplicable a todos los procesos judiciales y Corvalán destaca en varios documentos la necesidad de asegurar que el uso de la IA respete los derechos humanos fundamentales y el sistema jurídico donde se aplica.

Uno de los desafíos que destaca el equipo el uso más extendido de la herramienta es lograr que los participantes de un proyecto de estas características puedan “mirar más allá” de las tareas diarias para poder planificar y trabajar con ella. También resaltan la necesidad de conformar equipos con perfiles diferentes.

En cuanto a los posibles desafíos técnicos, en la actualidad, realiza procesos de búsquedas en documentos judiciales disponibles en sitios web. En este sentido, Prometea depende de que la información consultada continúe disponible y se actualice con regularidad. Para el Ministerio Público Fiscal de la Ciudad, el proceso de búsqueda de documentos es visto también como una ventaja en términos de privacidad y confidencialidad de los datos: “Prometea no guarda información, sino que funciona como un procesador de texto, que permite confeccionar un documento y posteriormente descargarlo o imprimirlo (...) predice en base a los documentos asociados al caso que se encuentran publicados en distintos sitios de internet de acceso público, a los que todo ciudadano tiene acceso”.

## El futuro de prometea

Hacia fines de 2018 el Ministerio Público Fiscal se encontraba realizando el trámite de patentamiento del nombre de la herramienta ante el Instituto Nacional de Propiedad Industrial (INPI) en Argentina. En el futuro buscan extender el uso de Prometea a otras áreas, tales como trámites y servicios judiciales. Todo con el objetivo de mejorar la relación con los ciudadanos y proteger a los sectores más vulnerables.

Durante 2018 la herramienta se adaptó y comenzó a funcionar  en “modo de prueba” para el armado de pliegos de contrataciones de bienes y servicios en el ámbito del Ministerio de Justicia y Seguridad de la Ciudad de Buenos Aires. Además de esta tarea, realiza un control de precios públicos: “El sistema busca y extrae el precio promedio del bien que se desee adquirir en base a las compras públicas realizadas con anterioridad y un control de precios privados que busca y extrae información similar, pero de precios de mercado (...) en ambos casos, la herramienta realiza una actualización de dichos precios en base a la inflación general y específica en tecnología (...) todo ello queda registrado en un informe que puede descargarse en cualquier computadora”.

El uso de Prometea también alcanzó al ámbito del fuero penal contravencional y de faltas, aplicándose, por ejemplo, en casos de multas de tránsito.

## Referencias

- Corvalán, Juan G.(29/09/2017).“La primera inteligencia artificial predictiva al servicio de la Justicia: Prometea”, en LA LEY del. Recuperado de:
http://thomsonreuterslatam.com/2017/10/la-primera-inteligencia-artificial-predictiva-al-servicio-de-la-justicia-prometea/
- La ley (12/03/2018). “Prometea”, el servicio de inteligencia artificial utilizado en la justicia argentina. Recuperado de:
https://laley.pe/art/5009/-ldquo-prometea-rdquo-el-servicio-de-inteligencia-artificial-utilizado-en-la-justicia-argentina
- Ministerio Público Fiscal de la Ciudad de Buenos Aires (20/2/2018). La fiscalía firmó convenio con la Asociación de Mujeres Jueces de la República Argentina. Recuperado de: https://www.fiscalias.gob.ar/project/la-fiscalia-firmo-convenio-con-la-asociacion-de-mujeres-jueces-de-la-republica-argentina/
- Ministerio Público Fiscal de la Ciudad de Buenos Aires.Derecho a la vivienda. Cuadernillo digital Nro.4 de jurisprudencia del Tribunal Superior de Justicia de la Ciudad Autónoma de Buenos Aires. Recuperado de: https://www.fiscalias.gob.ar/wp-content/uploads/2017/09/CUADERNILLO-DIGITAL-VIVIENDA.pdf
