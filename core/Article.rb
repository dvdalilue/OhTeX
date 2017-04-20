require_relative "Document"

class Article < Document
    def << e
        @document << e
    end

    def addlength l, v
        if v =~ /\A-?\d+/
            @preamble << "\n\\addtolength{\\#{l}}{#{v}}\n"
        else
            @preamble << "\n\\addtolength{\\#{l}}{\\#{v}}\n"
        end
    end
end