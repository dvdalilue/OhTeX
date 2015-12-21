class List
    def initialize txt="", arg=[], enum=false
        @text      = txt
        @elements  = arg
        @enumerate = enum
    end

    def add e
        @elements << e
    end

    def enumerate
        @enumerate = true
    end

    def itemize
        @enumerate = false
    end

    def to_tex ident=""
        tex = @text.clone
        list_type = 'itemize'
        list_type = 'enumerate' if @enumerate
        tex << "\n#{ident}\\begin{#{list_type}}\n"
        @elements.each { |e| tex << "#{ident + "\t"}\\item #{e.to_tex(ident + "\t")}\n" }
        tex << "#{ident}\\end{#{list_type}}\n"
        tex
    end
end