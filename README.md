

# chopepi: Trocear episodios en multiples escalas de tiempo


<a id="org183f174"></a>

## Motivación

En estudios longitudinales de seguimiento es habitual enfrentarse al
problema de tener que analizar efectos temporales en **múltiples
escalas de tiempo**, tales como la edad, el tiempo calendario o la
duración desde un evento anterior. En situaciones donde no sea
asumible la linealidad de los efectos temporales o cuando se precise
estudiar interrelaciones suele ser preciso discretizar los tiempos de
exposición de las escalas temporales. Esta tarea suele implicar
relativamente costosas manipulaciones del "dataset original" de
acuerdo a prepararlo para las especificaciones del modelo que queremos
ajustar.

Los **dataset** crudos habitualmente están compuesto por secuencias
ordenadas de **episodios** independientes. Cada individuo en seguimiento
tendrá una secuencia de uno o más episodios, que recoge su trayectoria
en el **espacio de estados** que hemos definido durante la **ventana de
observación** que estemos analizando.

Los episodios, tienen fecha de comienzo y terminación y su correspondiente
estado al comienzo (**Current Status: Cst**) y a su finalización (**Exit
Status: Xst**). En la siguiente tabla se muestra un ejemplo de un
sencillo "dataset", con dos escalas de tiempo explicitas: tiempo
calendario y edad. En ella se representa las biografías reproductivas de
tres individuos ("ikey") resumida en 7 episodios de paridad ("ikey" +
"seq.epi" ~ "kepi"). Donde "date.star" es la fecha calendario del
evento, "age.entry" la edad exacta en años decimales al comienzo del
episodio; "span.years" y "span.days" son las duracione del episodio en
unidades dias y años; "Cst.par" la paridad al comienzo del episodio y
"Xst.par" la paridad al terminar el episodio. En esta tabla hay
redundancia, ya que varias de las variable pueden ser derivadas, por
manipulación o transformaciones de alguna de las otras variables y no
seria necesarias en una tabla de datos optimizada. Por motivos
de claridad se prefiere mantenerlas.

<table id="org088368b" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 1</span> Original data</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">ikey</th>
<th scope="col" class="org-right">seq.epi</th>
<th scope="col" class="org-right">kepi</th>
<th scope="col" class="org-right">date.start</th>
<th scope="col" class="org-right">age.entry</th>
<th scope="col" class="org-right">span.years</th>
<th scope="col" class="org-right">span.days</th>
<th scope="col" class="org-right">Cst.par</th>
<th scope="col" class="org-right">Xst.par</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">1</td>
<td class="org-right">1</td>
<td class="org-right">101</td>
<td class="org-right">1958-03-13</td>
<td class="org-right">0.000</td>
<td class="org-right">23.169</td>
<td class="org-right">8463</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">1</td>
<td class="org-right">2</td>
<td class="org-right">102</td>
<td class="org-right">1981-05-14</td>
<td class="org-right">23.169</td>
<td class="org-right">3.635</td>
<td class="org-right">1328</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">2</td>
<td class="org-right">1</td>
<td class="org-right">201</td>
<td class="org-right">1955-07-10</td>
<td class="org-right">0.000</td>
<td class="org-right">21.079</td>
<td class="org-right">7699</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">2</td>
<td class="org-right">2</td>
<td class="org-right">202</td>
<td class="org-right">1976-08-07</td>
<td class="org-right">21.079</td>
<td class="org-right">4.808</td>
<td class="org-right">1757</td>
<td class="org-right">1</td>
<td class="org-right">2</td>
</tr>


<tr>
<td class="org-right">2</td>
<td class="org-right">3</td>
<td class="org-right">203</td>
<td class="org-right">1981-05-30</td>
<td class="org-right">25.887</td>
<td class="org-right">3.591</td>
<td class="org-right">1312</td>
<td class="org-right">2</td>
<td class="org-right">3</td>
</tr>


<tr>
<td class="org-right">3</td>
<td class="org-right">1</td>
<td class="org-right">301</td>
<td class="org-right">1960-02-29</td>
<td class="org-right">0.000</td>
<td class="org-right">18.997</td>
<td class="org-right">6939</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">3</td>
<td class="org-right">2</td>
<td class="org-right">302</td>
<td class="org-right">1979-02-28</td>
<td class="org-right">18.997</td>
<td class="org-right">5.841</td>
<td class="org-right">2134</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>
</tbody>
</table>

Una de las manipulaciones habituales que hay que enfrentar al analizar
datos longitudinales es el particionado (también denominados
discretización o "split") de las escalas de tiempo a analizar. Por
ejemplo si queremos estudiar efectos no lineales de la edad sobre la
ampliación de la paridad, podríamos discretizar la variable edad, en
agrupaciones quinquenales, para comprobar los distintos efectos en
intensidad de fecundidad en cada uno de los grupo de edad. Para ello
seria preciso transformar la tabla anterior en otra donde cada
episodios de paridad (sin hijos, con un hijo, ..), se dividirá en
varios sub-episodios de acuerdo al tramo de edad de exposición en cada
intervalo de exposición por grupo de edad. En la siguiente tabla, se
muestra el resultado de particionar la escala de tiempo edad en grupos
de edad.

<table id="org0f21682" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 2</span> Split by age</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />

<col  class="org-right" />

<col  class="org-right" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">age</th>
<th scope="col" class="org-right">duration</th>
<th scope="col" class="org-left">band.age</th>
<th scope="col" class="org-right">Cst</th>
<th scope="col" class="org-right">Xst</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">0.000</td>
<td class="org-right">15.000</td>
<td class="org-left">[0,15)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">15.000</td>
<td class="org-right">5.000</td>
<td class="org-left">[15,20)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">20.000</td>
<td class="org-right">3.169</td>
<td class="org-left">[20,25)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">23.169</td>
<td class="org-right">1.831</td>
<td class="org-left">[20,25)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">25.000</td>
<td class="org-right">1.804</td>
<td class="org-left">[25,30)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">0.000</td>
<td class="org-right">15.000</td>
<td class="org-left">[0,15)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">15.000</td>
<td class="org-right">5.000</td>
<td class="org-left">[15,20)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">20.000</td>
<td class="org-right">1.079</td>
<td class="org-left">[20,25)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">21.079</td>
<td class="org-right">3.921</td>
<td class="org-left">[20,25)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">25.000</td>
<td class="org-right">0.887</td>
<td class="org-left">[25,30)</td>
<td class="org-right">1</td>
<td class="org-right">2</td>
</tr>


<tr>
<td class="org-right">203</td>
<td class="org-right">25.887</td>
<td class="org-right">3.591</td>
<td class="org-left">[25,30)</td>
<td class="org-right">2</td>
<td class="org-right">3</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">0.000</td>
<td class="org-right">15.000</td>
<td class="org-left">[0,15)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">15.000</td>
<td class="org-right">3.997</td>
<td class="org-left">[15,20)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">18.997</td>
<td class="org-right">1.003</td>
<td class="org-left">[15,20)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">20.000</td>
<td class="org-right">4.838</td>
<td class="org-left">[20,25)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>
</tbody>
</table>

Igual que subdividimos los episodio en la escala de edad, podríamos
subdividirlos tambien en la escala de tiempo calendario. particionado
que  quedaría de esta manera:

<table id="org64ab999" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 3</span> Split by period</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />

<col  class="org-right" />

<col  class="org-right" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">period</th>
<th scope="col" class="org-right">duration</th>
<th scope="col" class="org-left">band.period</th>
<th scope="col" class="org-right">Cst</th>
<th scope="col" class="org-right">Xst</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">1958.194</td>
<td class="org-right">16.806</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">1975.000</td>
<td class="org-right">5.000</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">1980.000</td>
<td class="org-right">1.363</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">1981.364</td>
<td class="org-right">3.635</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">1955.520</td>
<td class="org-right">19.480</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">1975.000</td>
<td class="org-right">1.599</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">1976.598</td>
<td class="org-right">3.402</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">1980.000</td>
<td class="org-right">1.406</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">2</td>
</tr>


<tr>
<td class="org-right">203</td>
<td class="org-right">1981.408</td>
<td class="org-right">3.591</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">2</td>
<td class="org-right">3</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">1960.161</td>
<td class="org-right">14.839</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">1975.000</td>
<td class="org-right">4.158</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">1979.158</td>
<td class="org-right">0.842</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">1980.000</td>
<td class="org-right">4.999</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>
</tbody>
</table>

Es posible combinar esta dos particiones en dos escalas temporales
distinta, para obtener una sola partición multi-escala, tal como se
muestra en la siguiente tabla:

<table id="org241a805" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 4</span> Split by age and period</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-right" />

<col  class="org-right" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">age</th>
<th scope="col" class="org-right">period</th>
<th scope="col" class="org-right">duration</th>
<th scope="col" class="org-left">band.age</th>
<th scope="col" class="org-left">band.period</th>
<th scope="col" class="org-right">Cst</th>
<th scope="col" class="org-right">Xst</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">0.000</td>
<td class="org-right">1958.194</td>
<td class="org-right">15.000</td>
<td class="org-left">[0,15)</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">15.000</td>
<td class="org-right">1973.194</td>
<td class="org-right">1.806</td>
<td class="org-left">[15,20)</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">16.806</td>
<td class="org-right">1975.000</td>
<td class="org-right">3.194</td>
<td class="org-left">[15,20)</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">20.000</td>
<td class="org-right">1978.194</td>
<td class="org-right">1.806</td>
<td class="org-left">[20,25)</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">101</td>
<td class="org-right">21.806</td>
<td class="org-right">1980.000</td>
<td class="org-right">1.363</td>
<td class="org-left">[20,25)</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">23.169</td>
<td class="org-right">1981.364</td>
<td class="org-right">1.831</td>
<td class="org-left">[20,25)</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">25.000</td>
<td class="org-right">1983.195</td>
<td class="org-right">1.804</td>
<td class="org-left">[25,30)</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">..</td>
<td class="org-right">&#xa0;</td>
<td class="org-right">&#xa0;</td>
<td class="org-right">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-right">&#xa0;</td>
<td class="org-right">&#xa0;</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">0.000</td>
<td class="org-right">1960.161</td>
<td class="org-right">14.839</td>
<td class="org-left">[0,15)</td>
<td class="org-left">[1950,1975)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">14.839</td>
<td class="org-right">1975.000</td>
<td class="org-right">0.161</td>
<td class="org-left">[0,15)</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">0</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">15.000</td>
<td class="org-right">1975.161</td>
<td class="org-right">3.997</td>
<td class="org-left">[15,20)</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">0</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">18.997</td>
<td class="org-right">1979.158</td>
<td class="org-right">0.842</td>
<td class="org-left">[15,20)</td>
<td class="org-left">[1975,1980)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">19.839</td>
<td class="org-right">1980.000</td>
<td class="org-right">0.161</td>
<td class="org-left">[15,20)</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">20.000</td>
<td class="org-right">1980.161</td>
<td class="org-right">4.838</td>
<td class="org-left">[20,25)</td>
<td class="org-left">[1980,1985)</td>
<td class="org-right">1</td>
<td class="org-right">1</td>
</tr>
</tbody>
</table>


<a id="org3b0e884"></a>

## Herramientas  para el particionado de episodios

Varios paquetes de [R empleados en el análisis de supervivencia](https://cran.r-project.org/web/views/Survival.html) tienen
funciones especificamente diseñadas para realizar el particionado de
los episodios en una dimesiónm temporal. Algunos de estas funciones
son, por ejemplom [survival::SurvSplit](https://www.rdocumentation.org/packages/survival/versions/3.1-8/topics/survSplit), [relsurv::survsplit](https://rdrr.io/cran/relsurv/man/survsplit.html) o
[Epi::splitLexis](https://www.rdocumentation.org/packages/Epi/versions/2.40/topics/splitLexis). Todas ellas hacen el particionado sobre una sola
escalan temporal, sin embargo aplicando sucesivamente estas funciones sobre
los sub-episodios resultado de ls partición con anterioridad, es posible
generar particiones en múltiples escalas temporales. Estas funciones
son sencillas de utilizar y eficientes cuando se trabaja con un número
no excesivamente grande de episodios y se dispone de suficientes
recursos de memoria RAM.

Desafortunadamente cuando el número de episodios que hay que
particionar crece, acercándose peligrosamente a los recurso de memoria
RAM del equipo, el rendimiento de estas funciones es pobre. Hay que
tener en cuenta que el crecimiento del número de episodio por encima
del óptimo, puede ocurrir incluso trabajando con tabla de episodios de
moderado tamaño, pero sobre las que precisemos realizar particionar en
múltiples escalas de tiempo (edades, tiempo calendario, duraciones
desde un episodio anterior &#x2026;)

El paquete **chopepi** que estamos desarrollando pretende mejora el
rendimiento de estos procesos, cuando no enfrentamos a tablas de
episodios de medio o gran tamaño. Para conseguir esta mejora aplicamos
dos estrategias: (1) por un lado usa objetos de tipo *data.table* para
procesar los episodios, más rápidamente y eficientemente que con las
habituales tablas del tipo data.frame; y por otro (2) los
particionados en una escala temporal son pre-tratado en forma de
listas en lugar de tabla de sup-episodios lo cual es más sencillo y
rapido de generar y menos oneroso en cuanto a uso de la memoria de
trabajo.

La primera estrategia, trabajar con objetos del tipo
*data.table*, resulta mucho mas eficiente, en lugar de los
tradicionales *data.frame* y sus derivados (Lexis, tibble &#x2026;), en
cuanto al uso de memoria RAM y velocidad de proceso, cuando se procesa
objeto de medio y gran tamaño. Si bien el uso del direccionamiento por
referencia de data.table crear algo de confusión en usuarios
poco habituados a trabajar con ello,  este inconvenientes es
rápidamente soluciónale, en cuanto se va adquiriendo cierta
experiencia en su manejo.

Esta misma estrategia de, usar *data.tabla* es empleada por el paquete
[popEpi](https://github.com/WetRobot/popEpi) para mejorar el rendimiento de procesar los objetos del tipo
[Lexis](https://rdrr.io/cran/Epi/man/Lexis.html) definidos que define el paquete [Epi de Bendix Carstensen](https://rdrr.io/cran/Epi/) como
data.frame clasicos.

La segunda estrategia que utiliza el paquete **chopepi** es generar el
particionado de las escalas temporales sobre una lista de vectores de
igual tamaño que el número de episodios a procesar. Esta estrategia
por un lado mejora significativamente la velocidad de particionado
uni-escal y además, en caso de tener que trabajar con particionados en
multiples escalas reduce la complejidad del problema, ya que el número de
episodios a procesar  no crece multiplicativamente, si no solo
linealmente con la inclusión de nuevas escalas. 

El objetivo final del particionado uni o multi-escala es construir una
nueva tabla de sub-episodios cuyo tamaño sera el resultado de
multiplicar el tamaño de la tabla original por el número de medio
sub-episodios que cada escala de partición genera, tal como se ha
mostrado anteriormente la tabla "[Split by age and period](#org241a805)". El paquete
**choopepi** divide el proceso de particionado en varios sub-procesos
intermedios que realizan cuatro funciones: *choop()*, *combine2()*,
*meltEpi()* y *addCXst()* y cuyos resultados intermedios se procesan
sucesivamente hasta obtener el resultado buscado.

Dado que una de las partes mas más costosos en memoria y tiempo de
proceso es la generación de multiples registros de subepisodios por
cada uno de los episodios originales partida, y su coste crece mas que
linealmente cuando aumenta el número de episodios, no es recomendable
obtener particionados multiescala a partir de la aplicación sucesivas,
de funciones del tipo *survSplit()*. Resulta menos oneroso en memoria
y tiempo de proceso realizar particiones unidimensionales
independientes de cada escala temporal para combinarlas
posteriormente. Este es una de las estrategia de optimización que usa
**chopepi** usar una combinación de funciones, en lugar de una única
función para conseguir su particionado.  La más importante de estas
funciones es **chop()**, la cual realiza un pre-particionado en una
escala subdivisión de la duración cada episodio sobre un vector con la
sucesión de tiempos de ocupación en cada categoría discreta de la
escala que estemos procesando (grupos de edad, años calendario ..), la
cual se almacenará en forma de lista de vectores en una columna una
tabla auxiliar con los resultados intermedios de la
pre-particionada. A modo de ejemplo, un pre-particionar en la escala
de edad de la [tabla de episodios original](#org088368b) produciría este resultado
intermedio:

<table id="orgd31a55c" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 5</span> Chop: duration by age</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">age</th>
<th scope="col" class="org-left">durations.age</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">0.000</td>
<td class="org-left">c(15, 5, 3.169)</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">23.169</td>
<td class="org-left">c(1.831, 1.804)</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">0.000</td>
<td class="org-left">c(15, 5, 1.079)</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">21.079</td>
<td class="org-left">c(3.921, 0.887)</td>
</tr>


<tr>
<td class="org-right">203</td>
<td class="org-right">25.887</td>
<td class="org-left">3.591</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">0.000</td>
<td class="org-left">c(15, 3.997)</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">18.997</td>
<td class="org-left">c(1.003, 4.838)</td>
</tr>
</tbody>
</table>

Esta tabla intermedia de episodios preparticionado se puede convertir
en una tabla de sub-episodios individuales, por medio de dos funciones
*chopepi::meltEpi* y *chopepi::addCXst*, que aplicadas secuencialmente
producen una tabla, donde cada sub-episodios es una fila, tal como se
muestra en la tabla anterior ["Split by age"](#orgd31a55c). Esta tabla podría volver
a sub-particionar aplicando de nuevo *chop()* sobre otra escala
temporal. Pero, como se ha comentado, para obtener un particionado en
múltiples escala, esta estrategia no es eficiente, ya que el primer
particionado multiplica los episodios originales por el número de
particiones por episodio de la segunda escala de tiempo empleada, lo
que puede incrementar su número lo suficiente para reducir
significativamente el rendimiento del segundo particionado. Resulta
más adecuado pre-particionar con *chop()* los episodios originales
sobre todas las escalas temporales a estudiar y tras ello combinar
estos en una nueva pre-partición multi-escala, a partir de la que
derivar posteriomente la tabla de subepisodios definitiva. Con esta
estrategia la complejidad del proceso crece linealmente por cada nueva
partición agregada en lugar de hacerlo multiplicativamete sin
aplicáramos el particionado secuencial.

Por ejemplo para conseguir una particionado múltiple en la escala edad
y calendario, aplicaremos *chop()* de nuevo sobre los episodios
originales para obtener este 2º preparticionado:

<table id="orgfdc45fd" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 6</span> Chop: duration by period</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">period</th>
<th scope="col" class="org-left">durations.period</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">1958.194</td>
<td class="org-left">c(16.806, 5, 1.363)</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">1981.364</td>
<td class="org-left">3.634</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">1955.520</td>
<td class="org-left">c(19.48, 1.599)</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">1976.598</td>
<td class="org-left">c(3.402, 1.405)</td>
</tr>


<tr>
<td class="org-right">203</td>
<td class="org-right">1981.408</td>
<td class="org-left">3.590</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">1960.161</td>
<td class="org-left">c(14.839, 4.158)</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">1979.158</td>
<td class="org-left">c(0.842, 4.999)</td>
</tr>
</tbody>
</table>

Para a continuación obtener el particionado en las dos escala de
tiempo combinamos los dos particionados unidimensionales en un nuevo
particionado multidimensional usando la función *combine2c* sobre las
tablas pre-particionadas: "[by age](#orgd31a55c)" y "[by period](#orgfdc45fd)", lo que producirá
el siguiente  resultado:

<table id="orgd753b96" border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
<caption class="t-above"><span class="table-number">Tabla 7</span> Chop: duration by age and period</caption>

<colgroup>
<col  class="org-right" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-right">kid</th>
<th scope="col" class="org-right">age</th>
<th scope="col" class="org-right">period</th>
<th scope="col" class="org-left">durations.age.period</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-right">101</td>
<td class="org-right">0.000</td>
<td class="org-right">1958.194</td>
<td class="org-left">c(15, 1.8, 3.2, 1.8, 1.4)</td>
</tr>


<tr>
<td class="org-right">102</td>
<td class="org-right">23.169</td>
<td class="org-right">1981.364</td>
<td class="org-left">c(1.831, 1.8)</td>
</tr>


<tr>
<td class="org-right">201</td>
<td class="org-right">0.000</td>
<td class="org-right">1955.520</td>
<td class="org-left">c(15, 4.5, 0.5, 1.1)</td>
</tr>


<tr>
<td class="org-right">202</td>
<td class="org-right">21.079</td>
<td class="org-right">1976.598</td>
<td class="org-left">c(3.402, 0.5, 0.9)</td>
</tr>


<tr>
<td class="org-right">203</td>
<td class="org-right">25.887</td>
<td class="org-right">1981.408</td>
<td class="org-left">3.599</td>
</tr>


<tr>
<td class="org-right">301</td>
<td class="org-right">0.000</td>
<td class="org-right">1960.161</td>
<td class="org-left">c(14.839, 0.199, 4)</td>
</tr>


<tr>
<td class="org-right">302</td>
<td class="org-right">18.997</td>
<td class="org-right">1979.158</td>
<td class="org-left">c(0.842, 0.2, 4.8)</td>
</tr>
</tbody>
</table>

A partir de esta tabla de pre-particionado multidimensional, mediante
la posterior aplicación de las funciones *meltEpi()* y *addCXst()* se
optiene una tabla con registros individuales por cada sub-episodios,
como la mostrada individuales "[Split by age and period](#org241a805)" mostrada
anteriormente y que representa el objetivo finalmente buscado.


<a id="org3a0c912"></a>

# Código de ejemplo de particionado multiples con *chopepi*

A continuación mostramos el código de R que se ha empleado para
generar el ejemplo mostrado en el apartado anterior.

```{r eval = FALSE}

    require(knitr)
    require(data.table)
    require(chopepi)
    
    ### Crea tabla fuentes para ejemplo
    ###
    data.table(ikey=c(1L,1L,2L,2L,2L,3L,3L),
    	   seq.epi=c(1L,2L,1L,2L,3L,1L,2L),
    	   date.entry=as.Date(c("1958/03/13","1981/05/14","1955/07/10",
    			       "1976/08/07","1981/05/30",
    			       "1960/02/29","1979/02/28"),"%Y/%m/%d"),
    	   Cst.par=c(0L,1L,0L,1L,2L,0L,1L),
    	   Xst.par=c(1L,1L,1L,2L,3L,1L,1L)
    	   )-> epi.raw
    
    end.tracking <-  as.Date(c("1985/01/01"), "%Y/%m/%d")
    
    epi.raw[,':='(span.days  = as.integer(c(date.entry[-1],end.tracking) - date.entry),
    	   span.years = cal.age2(date.entry,c(date.entry[-1],end.tracking) ),
    	   age.entry  = cal.age2(date.entry[1],date.entry))
    	,ikey]
    
    epi.raw[, ':='(kepi=ikey*100L+seq.epi,year.entry=  cal.yr2(date.entry)) ]
    
    epi.raw[,c(1:2,9,3,10,8,7,6,4:5)]  -> epi.raw
    
    
    
    ## particiona por  edad ##############################
    chop(start.times =  age.entry,
         durations = span.years,
         breaks =  c(0,seq(15,100,by=5)),
         kid    = kepi,
         timedim = 'age',
         data = epi.raw) -> cepi.age
    
    meltEpi(cepi.age) -> epi.chop.age
    
    addCXst(epi.chop.age,epi.raw, Cst = 'Cst.par',
    	Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.age
    
    epi.chop.age[,sum(duration)] - epi.raw[,sum(span.days/365.25)] 
    
    ## particiona por periodo ##############################
    chop(start.times =  year.entry,
         durations = span.years,
         breaks =  c(1950,seq(1975,1990,by=5)),
         kid    = kepi,
         timedim = 'period',
         data = epi.raw) -> cepi.period
    
    meltEpi(cepi.period) -> epi.chop.period
    
    addCXst(epi.chop.period,epi.raw, Cst = 'Cst.par',
    	Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.period
    
    epi.chop.period[,sum(duration)] - epi.raw[,sum(span.days/365.25)]  
    
    ## combina particionado de edad y periodo.
    
    combine2c(cepi.age, cepi.period, dec.precision = 1) ->  cepi.age.period
    
    
    meltEpi(cepi.age.period) -> epi.chop.age.period
    
    addCXst(epi.chop.age.period,epi.raw, Cst = 'Cst.par',
    	Xst = 'Xst.par', id.original = 'kepi') -> epi.chop.age.period
    
    epi.chop.age.period[,sum(duration)] - epi.raw[,sum(span.days/365.25)]  
    
    ## Muestra resultados:
    
    knitr::kable(epi.raw)
    knitr::kable(epi.chop.age)
    knitr::kable(epi.chop.period)
    knitr::kable(epi.chop.age.period)
    
    knitr::kable(cepi.age)
    knitr::kable(cepi.period)
    knitr::kable(cepi.age.period)

```
