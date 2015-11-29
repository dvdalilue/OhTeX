OhTeX
=====

Documento
-------------

En primer lugar se necsita una manera de especificar el tipo de documento, para ello
existen las distintas clases de documentos que provee Latex.

Lo que se escribiria en Latex como `documentclass[options]{class}`, en Ohtex seria
algo de este estilo: `doc1 :: <Class>`, donde *Class* seria:

>- Article
- Book
- Letter
- Report
- Beamer
- ...

Todas estas clases son sub-clases de la clase `Document`.

Cuando de desee especificar distinta opciones a las que hay por defecto, simplemente
se abre la instancia de la clase:

```
doc1 :: Article {
    font : 11pt
    paper : letter 
}

doc1 {
    paper : a4
    typeset : twocolumn
}

doc1 { sided : one; layout : portrait }

doc1.paper = legal
```

Paquetes
--------

Latex-style:

```
\usepackage{lipsum}
\usepackage[english]{babel}
\usepackage[protrusion=true,expansion=true]{microtype}
\usepackage{amsmath,amsfonts,amsthm}
\usepackage[svgnames]{xcolor}
\usepackage{booktabs}
\usepackage{fix-cm}
```

Ohtex-style:

```
use lipsum
use babel {lang : english}
use microtype {potrusion : true; expasion : true}
use amsmath amsfonts amsthm
use xcolor {spectrum : svgnames}
use booktabs
use fix-cm
```
***
Paquetes comunes:
>- amsmath
>- geometry
>- graphicx
>- nag
>- microtype
>- siunitx
>- cleveref
>- hyperref
>- booktabs

***