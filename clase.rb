require_relative "ohtex"

doc1 = Article.new

doc1.fontsize = 11

pack1 = Package.new("t1enc"             )
pack2 = Package.new("inputenc", "utf8")
pack3 = Package.new("enumerate"         )
pack4 = Package.new("hyperref"          )

doc1.add_package pack1
doc1.add_package pack2
doc1.add_package pack3
doc1.add_package pack4
doc1.add_package Package.new("babel", "spanish")

text1 = Text.new 'Este documento proporciona enlaces a guías y parciales con ejercicios relacionados al tema de \emph{Conceptos Básicos}:'

list1 = List.new '',
                 [
                    'Láminas de \href{http://ldc.usb.ve/~rmonascal/cursos/ci3725_aj12/archivos/clase0.pdf}{Conceptos Básicos} de Carlos Pérez y \href{http://ldc.usb.ve/~rmonascal/}{Ricardo Monascal}.',
                    'Secciones 2.1 y 2.2 del \href{http://www.amazon.com/Languages-Machines-Introduction-Computer-Science/dp/0321322215}{Sudkamp}.',
                    'Capítulo 1 del \href{http://www.amazon.com/Compilers-Principles-Techniques-Alfred-Aho/dp/0201100886}{Compilers}.'
                 ],
                 false

list21 = List.new 'En el \href{http://ldc.usb.ve/~rmonascal/cursos/ci3725\_aj12/archivos/e1\_sol.pdf}{1er parcial} de \href{http://ldc.usb.ve/~rmonascal/cursos/ci3725\_aj12/index.html}{Abril-Julio 2012}:',
                  [
                    'Pregunta 0.g.'
                  ],
                  false

list22 = List.new 'En el \href{http://ldc.usb.ve/~emhn/cursos/ci3725/201304/P1-Soluci\%C3\%B3n.pdf}{1er parcial} de \href{http://ldc.usb.ve/~emhn/cursos/ci3725/201304/}{Abril-Julio 2013}:',
                  [
                    'Pregunta 1.3.'
                  ],
                  false

list2 = List.new '',
                 [
                    list21,
                    list22
                 ],
                 false

doc1.preamble = '
\setlength{\textwidth}{42eM}
\addtolength{\oddsidemargin}{-5eM}
\setlength{\textheight}{145ex}
\setlength{\topmargin}{-16ex}
\addtolength{\parskip}{\baselineskip}
\newcommand{\hreff}[1]{\href{#1}{#1}}
\renewcommand{\thesection}{\arabic{section}.}
\setcounter{section}{-1}
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}.}
'

doc1.document = [
    '
    \noindent
    {\footnotesize
    Universidad Simón Bolívar \\\\
    Departamento de Computación y Tecnología de la Información \\\\
    CI3725 -- Traductores e Interpretadores \\\\
    Octubre 2013 -- Enero 2014
    }
    ',
    '
    \bigskip
    \begin{center}
    {\Large {\bf
        Guía de Estudio - Clase 00
        
        Conceptos Básicos
    }}
    \end{center}
    ',
    text1,
    '
    \section{Lecturas adicionales:}
    ',
    list1,
    '
    \section{Ejercicios sugeridos de Parciales:}
    ',
    list2,
    '
    \vfill
    \noindent
    \mbox{$ \overline{
        \raisebox{-0.5ex}[1.5ex]{\footnotesize Ricardo Monascal / Octubre 2013 - Enero 2014}
        \hspace{5ex}
    } $}
    '
]

puts doc1.to_tex