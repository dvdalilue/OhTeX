# Reserved word in OhTeX
$reserved_words = %i(
    and
    break
    case
    class
    else
    elsif
    false
    for
    in
    cmd
    if
    nil
    or
    return
    self
    super
    true
    use
    when
    while
)

$tokens = {
    string:        /\A\'((?<=\\)\p{Punct}|[^\'])*\'/                             ,
    method_call:   /\A\p{Lower}[[^\p{Punct} \n]_]*\.\p{Lower}[[^\p{Punct} \n]_]*/,
    num_size:      /\A-?\p{Digit}+[^\p{Punct} \n]+/                                ,
    paper_size:    /\A(a0|a1|a2|a3|a4|a5|a6|b0|b1|b2|b3|b4|b5|b6|c0|c1|c2|c3|c4|c5|c6|b0j|b1j|b2j|b3j|b4j|b5j|b6j|ansia|ansib|ansic|ansid|ansie|letter|executive|legal)\b/,
    font_size:     /\A(tiny|script|footnote|small|normal|large|Large|LARGE|huge|Huge)\b/,
    alignment:     /\A(center|left|right)\b/,
    identifier:    /\A\p{Lower}[[^\p{Punct} \n]_]*/                              ,
    constant:      /\A\p{Upper}[[^\p{Punct} \n]_]*/                              ,
    open_curly:    /\A\{/                                                        ,
    close_curly:   /\A\}/                                                        ,
    open_bracket:  /\A\[/                                                        ,
    close_bracket: /\A\]/                                                        ,
    open_curved:   /\A\(/                                                        ,
    close_curved:  /\A\)/                                                        ,
    period:        /\A\./                                                        ,
    double_colon:  /\A\:\:/                                                      ,
    colon:         /\A\:/                                                        ,
    semi_colon:    /\A\;/                                                        ,
    comma:         /\A\,/                                                        ,
    plus:          /\A\+/                                                        ,
    minus:         /\A\-/                                                        ,
    asterisk:      /\A\*/                                                        ,
    slash:         /\A\//                                                        ,
    percent:       /\A\%/                                                        ,
    assign:        /\A\=/                                                        ,
    pre_insert:    /\A\<\<\</                                                    ,
    insert:        /\A\<\</                                                      ,
    export:        /\A\>\>/                                                      ,
    negation:      /\A\!(?!=)/                                                   ,
    equal:         /\A\=\=/                                                      ,
    not_equal:     /\A\!\=/                                                      ,
    less:          /\A\<(?!=)/                                                   ,
    less_eq:       /\A\<\=/                                                      ,
    greater:       /\A\>(?!=)/                                                   ,
    greater_eq:    /\A\>\=/                                                      ,
    new_line:      /\A\n/                                                        ,
    number:        /\A\d+/                                                       ,
    any:           /\A\S*/
}

$reserved_words.each do |s|
    temp_hash = {}
    temp_hash[s] = /\A#{s.to_s}\b/
    temp_hash.merge!($tokens)
    $tokens = temp_hash
end