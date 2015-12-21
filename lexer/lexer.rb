# Reserved word in OhTeX
$reserved_words = %i(
    use
)

$tokens = {
    :open_brace   => /\A\{/                   ,
    :close_brace  => /\A\}/                   ,
    :period       => /\A\./                   ,
    :double_colon => /\A\:\:/                 ,
    :colon        => /\A\:/                   ,
    :new_line     => /\A\n/                   ,
    :semi_colon   => /\A\;/                   ,
    :assign       => /\A\=/                   ,
    :string       => /\A\'.*\'/               ,
    :identifier   => /\A[a-zA-Z][0-9a-zA-Z_]*/,   
    :num          => /\A\d+/                  ,
    :any          => /\A\S*/
}

$reserved_words.each do |s|
    temp_hash = {}

    temp_hash[s] = /\A#{s.to_s}\b/
    temp_hash.merge!($tokens)
    $tokens = temp_hash
end

# $&  # Depends on $~. The string matched by the last successful match.
# $`  # Depends on $~. The string to the left of the last successful match.
# $'  # Depends on $~. The string to the right of the last successful match.
# $+  # Depends on $~. The highest group matched by the last successful match.
# $1  # Depends on $~. The Nth group of the last successful match. May be > 1.
# $~  # The MatchData instance of the last match. Thread and scope local. MAGIC

class Lexer
    # Constructor
    def initialize input_file
        @input = input_file
    end

    def next
        return if @input.empty?
        $tokens.each do |k,v|
            if @input =~ v
                puts "token encontrado #{k.to_s} - #{$&}"
                @input = $'
                @input = $' if $' =~ /\A[ \t\r\f]+/
                break
            end
        end
    end
end
