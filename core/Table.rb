class Table

    attr_writer :header

    def initialize name, n, m, header=nil, tb=[]
        @name   = name
        @n      = n
        @m      = m
        @header = header
        @tb     = tb
    end

    def add_row r
        raise "Row and Table dosen't have the same size" if r.length != @m
        @tb << r
    end

    def << r
        add_row r
    end

    def to_tex
        tex = "\n\\begin{tabular}{#{"|" + (" c " * @m) + "|"}}\n\\hline\n"
        if @header
            @header.each { |h| tex << "#{h.to_s} & " }
            tex = tex[0..-4] << "\\\\\n\\hline\n"
        end
        @tb.each do |r|
            r.each { |e| tex << "#{e.to_s} & " }
            tex = tex[0..-4] << "\\\\\n\\hline\n"
        end
        tex << "\\end{tabular}\n"
        tex
    end
end