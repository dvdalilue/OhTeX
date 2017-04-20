class Package

    attr_reader :name,   # Name of the package
                :options # Options of the paackage

    def initialize name, *options
        @name    = name
        @options = options
    end

    def options
        tex = ""
        @options.each { |o| tex << "#{o.to_tex}, "} unless @options.empty?
        tex.chomp! ", "
        tex
    end

    def to_tex
        return "\\usepackage\[#{options}\]\{#{name}\}" unless @options.empty?
        "\\usepackage\{#{name}\}"
    end
end