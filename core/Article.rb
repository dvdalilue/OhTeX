require_relative "Document"

class Article < Document

    def initialize pks=[], docs=[]
        super()
        @packages = pks
        @document = docs
    end

    def to_tex
        tex = "\\documentclass[#{@fontsize}pt]{article}\n"
        @packages.each { |p| tex << "#{p.to_tex}\n" }
        tex << "\n#{@preamble}\n"
        tex << "\\begin\{document\}\n"
        @document.each { |d| tex << "#{d.to_tex}\n" }
        tex << "\\end\{document\}\n"
        tex
    end
end