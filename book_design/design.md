ohtex es un lenguaje de programacion de dominio especifico, imperativo, para la composicion tipografica y orientado a objetos. En el diseño del lenguaje se tienen elementos comumente usados en los lenguajes de programacion, asi como estructuras de datos, estructuras de control, funciones, procediemientos, etc. 
Ohtex es un lenguaje de dominio especifico (DSL) externo, es decir, que tiene su propia sintaxis, implementado en Ruby. Esta desicion fue tomada porque Ruby es un lenguaje orientado a objetos y asi, realiza todo el trabajo que conlleva el manejo de objetos en el lenguaje. Ademas, Ruby crea un ambiente propicio para creacion de DSLs, haciendolo el mejor candidato para la implementacion de ohtex.
Ahora, considerando la composicion tipografica, se tomo en cuenta a Latex como herramienta para la generacion y estructuracion del texto de lo que seria el producto final, es decir, un documento. Por lo tanto, ohtex es un traductor (compilador) de Ruby a Latex, demostrando que un documento puede ser abtraido a un nivel mas alto y mantener una filosofia de generar documentos bonitos y al mismo tiempo poseer una estructura compresible.
El proceso de traduccion seria asi:

OhTeX    ->    Ruby    ->    Latex    ->    PDF

Estructura de un programa ohtex

use <paquete>

<objeto> :: <clase> {
    <atributo> : <valor> 
}

<objeto>.to_tex >> "doc1.tex"

Todo el archivo permite crear objetos, ya sean que vayan en un documento o no. Las palabra clave use es usada para indicarle a lenguaje cuales de los paquetes de latex se deseean usar en cualquiera de los documentos que se vayan a generar. Algunos de los paquetes exigen uno, mas parametros o son opcionales, en cualquiera de los casos, la sintaxis para el pase de parametros es por nombre, como se muestra a continuacion:

    use babel {lang : english}
    use microtype {potrusion : true; expasion : true}

Por otro lado, se pueden especificar varios paquetes en una misma linea, eso solo si ninguno de los paquetes necesita parametros, asi:
    use amsmath amsfonts amsthm
Esto es, porque en ciertas ocaciones existen paquetes que viene en conjunto o tienen un proposito similar, ademas de la flexibilidad en cuanto a escribir repetidamente la palabra reservada use.
Ahora, el programa comienza  leyendo de arriba a abajo, interpretando, creando objetos, intereactuando con los mismo y al final puede o no generar uno o mas documentos. Crear un objeto no implica que el mismo estara en un documento.
Tomando en cuenta la estructura basica de un programa en ohtex, en especifico los dos-puntos dobles ("::"), representa el constructor de las clases, nos indica que una clase es instanciado y la referencia a esa instancia es dada por el nombre (objeto) del lado izquierdo. Por ejemplo:

doc1 :: Book {
    ...
}

Si bien al construir un objeto, el mismo debe inicializarse (ciertos atributos, que son obligatorios). Y para ello, se usan las llaves, donde encierran una lista (no vacia) del nombre de los atributos del objeto, cada nombre es seguido del simbolo dos-puntos (":") y luego el valor que inicializara el atributo. Como se muestra a continuacion:
                    font : 10pt
Siguiendo lo anterior, cual seria el significado semantico de la expresion anterior? Los candidatos para denotar esta "asignacion" o "inicializacion" fueron:

=
:=
:
<-

Y al final, se decidio por ":", tomando en cuenta las siguientes consideraciones:
El simbolo se escribira muy seguido, por lo tanto debe poseer la menor cantidad de caracteres posible, es decir, uno.
El simbolo debe asociarse facilmente a la asocion de un atributo con un valor, como lo hace CSS (un lenguaje de markup) y JSON (un lenguaje de serializacion de datos)
El simbolo debe poseer una semantica acorde a lo que se desea expresar. Por lo tanto, el simbolo ":" representa una pausa para hacer un llamado de atencion en lo que sigue y que siempre esta relacionado con el texto precedente. 
El lenguaje manejara tipos enteros, booleanos, clases, instancias de clases, metodos, funciones y comandos

Instrucciones
A pesar de que el simbolo ":" representa la inicializacion de un atributo de un objeto al momento de su construccion, el simbolo de asignacion es "=". Ya construido el objeto, se puede acceder y settear cada uno de su atributos (publicos). Como por ejemplo:

                    doc1.font = 11pt

Lexicografía
============

Identificadores
---------------

Cada identificador es un nombre que se usa para referir a una varible, metodo,
clase, comando, o paquete. 

De igual manera a como se permite en Ruby y la mayoria de los lenguajes, los
identificadores constan de caracteres alphanumericos (A-Za-z0-9) y underscores
(_), pero sin que comience por numero. Tambien esta permitido, que los
identificadores de los metodos puedan terminar en interrogacion (?), exclamacion
(!) o igual (=). Sin restricciones en la longitud del identificador.

Por otro lado, existen ciertas palabras reservadas que no podran ser usadas como
identificar en ningun caso.

Por ejemplo:
```
foo
bar
baz
this_is_my_4er_id

```

Comentarios
-----------

Los comentarios de linea seran a partir de dos puntos seguidos ".." hasta el
salto de linea (sin incluirlo). En caso de que desee incluir el salto de linea
en el comentario se deben usar tres puntos seguidos "..."

Por ejemplo:

```
.. esta linea no hace nada
a = 5 .. "a" es una variable local inicializada como un numero, con valor 5

a = 2 + ... esto es mas util con expresiones largas, o no
	3

```

Los comentarios de bloque son a partir de dos puntos y una llave que abre "..{"
hasta una llave que cierra seguida de dos puntos "}.."

Por ejemplo:

```

..{
	Todo lo que se encuentre dentro de este bloque sera ignorado. El uso de
	comentarios de bloques anidados es considerado un mala practica pero
	sucedera de igual forma, ..{ asi que es posible hacerlo. }..
}..

```

Palabras reservadas
-------------------

La siguientes palabras estan reservadas en OhTeX:

```

and
break
case
class
do
else
elsif
false
for
fun
if
loop
nil
or
reopen
rescue
return
self
super
true
try
until
use
when
while

```

Expresiones
-----------

Al igual que en Ruby (dado que es un lenguaje embedido), todo es una expresion.
La secuenciacion es dada por los saltos de linea y el punto-y-coma (";").

Variables y Literales
=====================

Ohtex, al ser un lenguaje embedido en Ruby, mantiene un simil en ciertos
aspectos de su sintaxis, asi como su alcance y declaracion de variables. De
alguna manera, es predecible, pero eso ayuda a reducir el tiempo de aprendizaje
y brinda la posiblidad de generar programas intuitivamente, efocandose
escencialmente en la objetivo final, generar un documento con una excelente
composicion tipografica de manera estructural.

Variables globales
------------------

Toda variable que comience con dolar "$" tiene alcance global, dicha variable
puede ser accesada en cualquier momento de la ejecucion desde cualquier lugar.

Por ejemplo:

```
$foo
```

Variables locales
-----------------

Una variable local es aquella que comienza con un letra en minusculas (a-z) o
underscore (_). O una llamada a un metodo. Ademas dicha variable sera asequible
en el alcance donde fue declarada, exclusivamente.

Variables de instancia
----------------------

```
.. Falta definir sintaxis para la definicion de clases
```

Variables de clase
------------------

```
.. Falta definir sintaxis para la definicion de clases
```

Pseudo variables
----------------

Siendo un lenguaje orientado a objetos, debe existir una variable que refiera al
objeto actual, y para ello, tenemos `self`.

Formato de texto
==============

En esta sección se describen varios aspectos para darle un formato especifico al texto, se podrá ver que existe una similitud con `Markdown` y eso es para brindar facilidad cuando se genera un programa.

Tamaño de Fuente
----------------

```
Command             10pt    11pt    12pt
\tiny               5       6       6
\scriptsize         7       8       8
\footnotesize       8       9       10
\small              9       10      10.95
\normalsize         10      10.95   12
\large              12      12      14.4
\Large              14.4    14.4    17.28
\LARGE              17.28   17.28   20.74
\huge               20.74   20.74   24.88
\Huge               24.88   24.88   24.88
```

Cursiva
--------

Para cambiar el formato de algún texto en especifico, el mismo debe estar entre dos asteriscos `*`, sin espacio al principio y sin saltos de linea.

Siguiendo la siguiente expresión regular en `ruby`:

    /(\*\p{Graph}+\*|\*\p{Graph}+[\p{Graph} ]*\*)/

Negrita
--------

Similar a la sección anterior, se debe agrupar el texto, pero dentro de cuatro asteriscos `*`, dos de cada lado del texto y siguiendo las mismas restricciones.

    /(\*\*\p{Graph}+\*\*|\*\*\p{Graph}+[\p{Graph} ]*\*\*)/

Literales
=======

Numeros
----------

Booleanos
------------

Strings
--------

Arreglos
----------

Tabla de Hash
-----------------

Rangos
---------

Verbatim
-----------

En ciertas ocasiones se desea hacer uso explicito de una expresión que sea literal en `ruby` o `latex` y para ello se hace uso de la siguiente sintaxis:

Ruby:

Cualquier código que sea escrito dentro de las llaves podrá usar los objetos de archivo definidos en `ohtex` u otro verbatim de `ruby` .

```
&ruby {
    ... código ruby ...
}
```

LaTeX:

En el caso de `latex` es mas simple, solamente se debe incorporar el código entre comillas simples al documento, haciendo uso del operador `<<`. Haciendo distinción entre el preambulo y los elementos dentro del documento.

```
doc1 :: Article {
    ...
}

.. texto ohtex

doc1.preamble << '
    \newcommand{cmd}[1]{Comando numero #1}
'

doc1.document << '
    \noindent
    Example paragraph...
'
```