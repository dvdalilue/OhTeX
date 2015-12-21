class Object
    def to_tex ident=""
        self.to_s
    end
end

# Abstract class Document. Every documentclass in latex must inherit from this class
class Document

    attr_accessor :fontsize,  # Sets the size of the main font in the document. 10pt, 11pt, 12pt
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

    attr_accessor :packages, # List of packages used in the document
                  :preamble,
                  :document  # List of elements of the document

    def initialize
        @fontsize  = 10
        @paper     = 'letter'
        @fleqn     = false
        @leqno     = false
        @titlepage = false
        @twocolunm = false
        @sided     = 1
        @layout    = 'portrait'
        @draft     = false
    end

    def add_package p
        @packages << p
    end
end