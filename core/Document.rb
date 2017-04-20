class Object
    def to_tex ident=""
        self.to_s
    end
end

# Abstract class Document. Every documentclass in latex must inherit from this class
class Document

    attr_accessor :font,      # Sets the size of the main font in the document. 10pt, 11pt, 12pt
                  :paper,     # a4paper, letterpaper, a5paper, b5paper, executivepaper & legalpaper
                  :fleqn,     # Typesets displayed formulas left-aligned instead of centered.
                  :leqno,     # Places the numbering of formulas on the left hand side instead of the right.
                  :titlepage, # Specifies whether a new page should be started after the document title or not.
                  :twocolunm, # Instructs LaTeX to typeset the document in two columns instead of one.
                  :sided,     # twoside, oneside # Specifies whether double or single sided output should be generated.
                              # The classes article and report are single sided and the book class is double sided by default.
                              # Note that this option concerns the style of the document only.
                              # The option twoside does not tell the printer you use that it should actually make a two-sided printout.
                  :layout,    # Changes the layout of the document to print in landscape mode.
                  :draft

    # openright, openany

    # Makes chapters begin either only on right hand pages or on the next page
    # available. This does not work with the article class, as it does not know about
    # chapters. The report class by default starts chapters on the next page
    # available and the book class starts them on right hand pages.

    attr_accessor :hoffset,
                  :voffset,
                  :oddsidemargin,
                  :topmargin,
                  :headheight,
                  :headsep,
                  :textwidth,
                  :textheight,
                  :marginparsep,
                  :marginparwidth,
                  :footskip

    attr_accessor :section_counter,
                  :subsection_counter,
                  :subsubsection_counter,
                  :paragraph_counter,
                  :subparagraph_counter,
                  :page_counter,
                  :figure_counter,
                  :table_counter,
                  :footnote_counter,
                  :mpfootnote_counter

    attr_accessor :baselineskip,
                  :baselinestretch,
                  :columnsep,
                  :columnwidth,
                  :evensidemargin,
                  :linewidth,
                  :parindent,
                  :parskip,
                  :tabcolsep

    attr_accessor :packages, # List of packages used in the document
                  :preamble,
                  :document  # List of elements of the document

    def initialize
        @font      = '10pt'
        @paper     = 'letterpaper'
        @fleqn     = false
        @leqno     = false
        @titlepage = false
        @twocolunm = false
        @sided     = 1
        @layout    = 'portrait'
        @draft     = false

        @packages = []
        @preamble = ''
        @document = []
    end

    def add_package p
        @packages << p
    end

    def to_tex
        tex = "\\documentclass[#{@font},#{@paper},#{'draft,' if @draft}#{if @twocolunm; 'twocolunm'; else; 'onecolunm'; end},#{'fleqn,' if @fleqn}#{'leqno,' if @leqno}#{if @sided.eql? 1 then 'oneside' else 'twoside' end},#{if @titlepage then 'titlepage' else 'notitlepage' end}]{#{self.class.name.downcase}}\n"
        tex << "\\usepackage[landscape]{geometry}\n" if @layout.eql? 'landscape'
        @packages.each { |p| tex << "#{p.to_tex}\n" }
        tex << "\n"
        tex << '
        \newcommand{\OhTeX}{%
        \makebox[0.76em][c]{O}%
        \makebox[0.25em][c]{%
        \raisebox{0.14em}[0em][0em]{%
            \fontsize{0.5em}{0cm}%
                \selectfont H%
            }%
        }%
        \makebox[1.35em][c]{\TeX}%
        }
        '
        tex << "\\setlength{\\hoffset}{#{@hoffset}}\n" unless @hoffset.nil?
        tex << "\\setlength{\\voffset}{#{@voffset}}\n" unless @voffset.nil?
        tex << "\\setlength{\\oddsidemargin}{#{@oddsidemargin}}\n" unless @oddsidemargin.nil?
        tex << "\\setlength{\\topmargin}{#{@topmargin}}\n" unless @topmargin.nil?
        tex << "\\setlength{\\headheight}{#{@headheight}}\n" unless @headheight.nil?
        tex << "\\setlength{\\headsep}{#{@headsep}}\n" unless @headsep.nil?
        tex << "\\setlength{\\textheight}{#{@textheight}}\n" unless @textheight.nil?
        tex << "\\setlength{\\textwidth}{#{@textwidth}}\n" unless @textwidth.nil?
        tex << "\\setlength{\\marginparsep}{#{@marginparsep}}\n" unless @marginparsep.nil?
        tex << "\\setlength{\\marginparwidth}{#{@marginparwidth}}\n" unless @marginparwidth.nil?
        tex << "\\setlength{\\footskip}{#{@footskip}}\n" unless @footskip.nil?

        tex << "\\setlength{\\baselineskip}{#{@baselineskip}}\n" unless @baselineskip.nil? 
        tex << "\\setlength{\\baselinestretch}{#{@baselinestretch}}\n" unless @baselinestretch.nil? 
        tex << "\\setlength{\\columnsep}{#{@columnsep}}\n" unless @columnsep.nil? 
        tex << "\\setlength{\\columnwidth}{#{@columnwidth}}\n" unless @columnwidth.nil? 
        tex << "\\setlength{\\evensidemargin}{#{@evensidemargin}}\n" unless @evensidemargin.nil? 
        tex << "\\setlength{\\linewidth}{#{@linewidth}}\n" unless @linewidth.nil? 
        tex << "\\setlength{\\parindent}{#{@parindent}}\n" unless @parindent.nil? 
        tex << "\\setlength{\\parskip}{#{@parskip}}\n" unless @parskip.nil? 
        tex << "\\setlength{\\tabcolsep}{#{@tabcolsep}}\n" unless @tabcolsep.nil?

        tex << "\\setcounter{section}{#{@section_counter}}\n" unless @section_counter.nil?
        tex << "\\setcounter{subsection}{#{@subsection_counter}}\n" unless @subsection_counter.nil?
        tex << "\\setcounter{subsubsection}{#{@subsubsection_counter}}\n" unless @subsubsection_counter.nil?
        tex << "\\setcounter{paragraph}{#{@paragraph_counter}}\n" unless @paragraph_counter.nil?
        tex << "\\setcounter{subparagraph}{#{@subparagraph_counter}}\n" unless @subparagraph_counter.nil?
        tex << "\\setcounter{page}{#{@page_counter}}\n" unless @page_counter.nil?
        tex << "\\setcounter{figure}{#{@figure_counter}}\n" unless @figure_counter.nil?
        tex << "\\setcounter{table}{#{@table_counter}}\n" unless @table_counter.nil?
        tex << "\\setcounter{footnote}{#{@footnote_counter}}\n" unless @footnote_counter.nil?
        tex << "\\setcounter{mpfootnote}{#{@mpfootnote_counter}}\n" unless @mpfootnote_counter.nil?

        tex << "#{@preamble}\n"
        tex << "\\begin\{document\}\n"
        @document.each { |d| tex << "#{d.to_tex}\n" }
        tex << "\\end\{document\}\n"
        tex
    end
end