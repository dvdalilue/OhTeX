require_relative "classes"

# $&  # Depends on $~. The string matched by the last successful match.
# $`  # Depends on $~. The string to the left of the last successful match.
# $'  # Depends on $~. The string to the right of the last successful match.
# $+  # Depends on $~. The highest group matched by the last successful match.
# $1  # Depends on $~. The Nth group of the last successful match. May be > 1.
# $~  # The MatchData instance of the last match. Thread and scope local. MAGIC

class Lexer

    attr_accessor :input,
                  :line,
                  :column,
                  :tokens,
                  :errors

    # Constructor
    def initialize input_file
        @line    = 1
        @column  = 1
        @input   = input_file.gsub(/\t/, '    ')
        @tokens  = []
        @errors  = []
    end

    def ignore_blanks
        if @input =~ /\A[ \t\r\f]+/
            @input = $'
            @column += $&.length
        end
    end

    def ignore_comment
        ignored = false
        if @input =~ /\A\.\.\.[\p{Graph} \t]*\n/
            @line   += 1
            @column  = 1
            @input = $'
            ignored = true
        elsif @input =~ /\A\.\.{(.|\n)*}\.\./
            @input = $'
            cm = $&
            @line += $&.scan(/\n/).length
            if cm =~ /\n.*}\.\./
                @column += ($&.length - 1)
            end
            ignored = true
        elsif @input =~ /\A\.\.[\p{Graph} \t]*/
            @input = $'
        end
        ignored
    end

    def update_l_c match, sym
        if sym.eql? :new_line
            @line += 1; @column = 1
        elsif sym.eql? :string
            ls = match.scan(/\n/)
            if ls.length > 0
                @line   += ls.length
                match   =~ /\n.*\'/
                @column += ($&.length - 1)
            else
                @column += match.length
            end 
        else
            @column += match.length
        end
    end

    def next
        return if @input.empty?

        ignore_blanks

        while ignore_comment; end
        tk = nil
        $tokens_class.each do |sym,cl|
            if cl.regex.match @input
                @input = $'
                return if $&.empty?
                tk = cl.new $&.clone, @line, @column
                if TkAny.eql? cl
                    @errors << tk
                else
                    @tokens << tk
                end
                update_l_c $&.clone, sym
                ignore_blanks
                break
            end
        end
        return tk
    end

    def run
        while self.next; end
    end
end
