class Text
    def initialize txt=""
        @text = txt
    end

    def << txt
        @text << "\n#{txt}"
    end

    def to_tex
        @text
    end
end