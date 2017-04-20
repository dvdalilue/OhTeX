class Text

    attr_accessor :text, :size, :indent, :align, :bold, :italic

    def initialize txt=""
        @text = txt
        @size = 'normalsize'
    end

    def << txt
        @text << "\n#{txt}"
    end

    def to_tex
        tex = ""
        tex << "\\begin{#{@align}}\n" unless @align.nil?
        tex << "{\\setlength{\\parindent}{#{@indent}}\n" unless @indent.eql? nil
        tex << "{\\#{@size} "
        tex << "{\\it " if @italic
        tex << "{\\bf " if @bold
        tex << "#{@text.gsub(/(?<!\\)\\(?!(\\|\p{Alpha}))/,'\\\\\\\\')}\n}"
        tex << "}" if @bold
        tex << "}" if @italic
        tex << "\n}" unless @indent.eql? nil
        tex << "\\end{#{@align}}\n" unless @align.nil?
        tex << "\n"
        tex
    end
end