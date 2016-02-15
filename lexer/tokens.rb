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
    :open_curly    => /\A\{/                           ,
    :close_curly   => /\A\}/                           ,
    :open_bracket  => /\A\[/                           ,
    :close_bracket => /\A\]/                           ,
    :open_curved   => /\A\(/                           ,
    :close_curved  => /\A\)/                           ,
    :period        => /\A\./                           ,
    :double_colon  => /\A\:\:/                         ,
    :colon         => /\A\:/                           ,
    :semi_colon    => /\A\;/                           ,
    :comma         => /\A\,/                           ,
    :plus          => /\A\+/                           ,
    :minus         => /\A\-/                           ,
    :asterisk      => /\A\*/                           ,
    :slash         => /\A\//                           ,
    :percent       => /\A\%/                           ,
    :assign        => /\A\=/                           ,
    :insert        => /\A\<\</                         ,
    :negate        => /\A\!(?!=)/                      ,
    :equal         => /\A\=\=/                         ,
    :not_equal     => /\A\!\=/                         ,
    :less          => /\A\<(?!=)/                      ,
    :less_eq       => /\A\<\=/                         ,
    :greater       => /\A\>(?!=)/                      ,
    :greater_eq    => /\A\>\=/                         ,
    :new_line      => /\A\n/                           ,
    :num           => /\A\d+/                          ,
    :string        => /\A\'[^\']*\'/                   ,
    :num_size      => /\A\p{Digit}+[^\p{Punct} ]+/     ,   
    :identifier    => /\A\p{Lower}[[^\p{Punct} \n]_]*/ ,   
    :constant      => /\A\p{Upper}[[^\p{Punct} \n]_]*/ ,   
    :any           => /\A\S*/
}

$reserved_words.each do |s|
    temp_hash = {}

    temp_hash[s] = /\A#{s.to_s}\b/
    temp_hash.merge!($tokens)
    $tokens = temp_hash
end