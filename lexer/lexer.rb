# Reserved word in OhTeX
$reserved_words = %i(
    and
    break
    case
    class
    do
    else
    elsif
    false
    for
    fun
    if
    in
    loop
    nil
    or
    rescue
    return
    self
    super
    true
    try
    until
    use
    when
    while
)

$tokens = {
    :open_curly   => /\A\{/                           ,
    :close_curly  => /\A\}/                           ,
    :open_brace   => /\A\[/                           ,
    :close_brace  => /\A\]/                           ,
    :period       => /\A\./                           ,
    :double_colon => /\A\:\:/                         ,
    :colon        => /\A\:/                           ,
    :new_line     => /\A\n/                           ,
    :semi_colon   => /\A\;/                           ,
    :comma        => /\A\,/                           ,
    :plus         => /\A\+/                           ,
    :minus        => /\A\-/                           ,
    :assign       => /\A\=/                           ,
    :string       => /\A\'[^\']*\'/                   ,
    :num          => /\A\d+/                          ,
    :num_size     => /\A\p{Digit}+[^\p{Punct} ]+/     ,   
    :identifier   => /\A\p{Lower}[[^\p{Punct} \n]_]*/ ,   
    :constant     => /\A\p{Upper}[[^\p{Punct} \n]_]*/ ,   
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

    attr_accessor :input, :line, :column

    # Constructor
    def initialize input_file
        @line    = 1
        @column  = 1
        @input   = input_file
        @input   = @input.gsub(/\t/, '    ')
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
        
        $tokens.each do |k,v|
            if v.match @input
                #puts "token find ---> #{k.to_s}, \"#{$& unless k.eql? :new_line}\", line: #{@line}"
                @input = $'
                update_l_c $&.clone, k
                ignore_blanks
                break
            end
        end
        return true
    end
end
