class Section
    attr_accessor :name, :elements

    def initialize
        @elements = []
    end

    def << e
        @elements << e
    end

    def to_tex
        tex = "\n\\section{#{@name}}\n"
        @elements.each { |e| tex << "#{e.to_tex}\n" }
        tex
    end
end