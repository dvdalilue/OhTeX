class Parser

    token  'and' 'break' 'case' 'class' 'else' 'elsif' 'false' 'for' 'cmd'
           'if' 'nil' 'nl' 'or' 'return' 'self' 'super' 'true' '<<<' '>>'
           'use' 'when' 'while' 'string' 'identifier' 'constant' 'paper' 'font' 'align'
           'size' 'number' 'method' '{' '}' '[' ']' '(' ')' '.' '::' ':' ';'
           ',' '+' '-' '*' '/' '%' '=' '!' '==' '!=' '<' '<=' '>' '>=' '<<'
           UMINUS

    prechigh
        right '!'
        nonassoc UMINUS
        left '*' '/' '%'
        left '+' '-'
        nonassoc '<' '>' '<=' '>='
        nonassoc '==' '!='
        nonassoc 'and'
        nonassoc 'or'
        nonassoc '='
    preclow

    convert
        'and'        'TkAnd'
        'break'      'TkBreak'
        'case'       'TkCase'
        'class'      'TkClass'
        'else'       'TkElse'
        'elsif'      'TkElsif'
        'false'      'TkFalse'
        'for'        'TkFor'
        'cmd'        'TkCmd'
        'if'         'TkIf'
        'nil'        'TkNil'
        'nl'         'TkNewLine'
        'or'         'TkOr'
        'return'     'TkReturn'
        'self'       'TkSelf'
        'super'      'TkSuper'
        'true'       'TkTrue'
        'use'        'TkUse'
        'when'       'TkWhen'
        'while'      'TkWhile'
        '{'          'TkOpenCurly'
        '}'          'TkCloseCurly'
        '['          'TkOpenBracket'
        ']'          'TkCloseBracket'
        '('          'TkOpenCurved'
        ')'          'TkCloseCurved'
        '.'          'TkPeriod'
        '::'         'TkDoubleColon'
        ':'          'TkColon'
        ';'          'TkSemiColon'
        ','          'TkComma'
        '+'          'TkPlus'
        '-'          'TkMinus'
        '*'          'TkAsterisk'
        '/'          'TkSlash'
        '%'          'TkPercent'
        '='          'TkAssign'
        '!'          'TkNegation'
        '=='         'TkEqual'
        '!='         'TkNotEqual'
        '<'          'TkLess'
        '<='         'TkLessEq'
        '>'          'TkGreater'
        '>='         'TkGreaterEq'
        '<<'         'TkInsert'
        '>>'         'TkExport'
        '<<<'        'TkPreInsert'
        'string'     'TkString'
        'identifier' 'TkIdentifier'
        'constant'   'TkConstant'
        'size'       'TkNumSize'
        'number'     'TkNumber'
        'method'     'TkMethodCall'
        'paper'      'TkPaperSize'
        'font'       'TkFontSize'
        'align'      'TkAlignment'
end

start Program

rule

    Program: ObjectList           { result = Program::new(val[0]) }
           | LinesPlus ObjectList { result = Program::new(val[1]) }
           ;

    ObjectList: /* empty rule */            { result = []                 }
              | Object                      { result = [val[0]]           }
              | Object LinesPlus ObjectList { result = (val[2] << val[0]) }
              ;

    Object: Package  { result = val[0] }
          | PackArgs { result = val[0] }
          | Instance { result = val[0] }
          | Reopen   { result = val[0] }
          | Method   { result = val[0] }
          | Insert   { result = val[0] }
          | PInsert  { result = val[0] }
          | Export   { result = val[0] }
          ;

    Package: 'use' PackList { pack = Use::new(val[1],[]); $global_packages << pack; result = pack }
           ;

    PackList: 'identifier'          { result = [val[0].text]           }
            | 'identifier' PackList { result = (val[1] << val[0].text) }
            ;

    PackArgs: 'use' 'identifier' '{' ArgB '}' { pack = Use::new([val[1].text],val[3]); $global_packages << pack; result = pack }

    Instance: 'identifier' '::' 'constant' Args { result = Instance::new(val[0].text,val[2].text,val[3]) }
            ;

    Reopen: 'identifier' Args { result = Reopen::new(val[0].text,val[1]) }
          ;

    Method: 'method' '=' Expression     { result = MethodCall::new(val[0].text,val[2])  }
          | 'method' '(' MethodArgs ')' { result = CommandCall::new(val[0].text,val[2]) }
          ;

    MethodArgs: Expression                { result = [val[0]]}
              | Expression ',' MethodArgs { result = val[2] << val[0]}

    Insert: 'identifier' '<<' Insertrhs { result = Insert::new(val[0].text,val[2].text) }
          | Insert '<<' Insertrhs       { result = Insert::new(val[0],val[2].text) }
          ;

    PInsert: 'identifier' '<<<' 'string' { result = PInsert::new(val[0].text,val[2].text) }
           #| Insert '<<<' Insertrhs     { result = Insert::new(val[0],val[2].text) }
           ;

    Export: 'identifier' '>>' 'string' { result = Export::new(val[0].text,val[2].text) }

    Insertrhs: 'identifier'
             | 'string'
             | Instance
             ;

    Args: '{' ArgB '}'           { result = val[1] }
        | LinesPlus '{' ArgB '}' { result = val[2] }
        ;

    ArgB: ArgList           { result = val[0] }
        | LinesPlus ArgList { result = val[1] }
        ;

    ArgList: /* empty rule */            { result = []                 }
           | SingleArg                   { result = [val[0]]           }
           | SingleArg LinesPlus ArgList { result = (val[2] << val[0]) }
           ;

    SingleArg: 'identifier' ':' Expression { result = SingletonArg::new(val[0].text,val[2]) }
             ;

    Expression: 'string'                    { result = QuotedString::new(val[0].text) }
              | 'size'                      { result = Size::new(val[0].text)         }
              | 'number'                    { result = val[0].text.to_i               }
              | 'true'                      { result = true                           }
              | 'paper'                     { result = Paper::new(val[0])             }
              | 'font'                      { result = Font::new(val[0].text)         }
              | 'align'                     { result = Align::new(val[0].text)        }
              | 'false'                     { result = false                          }
              | 'identifier'                { result = Identifier::new(val[0].text)   }
              | Array                       { result = Array::new(val[0])             }
              | '-' Expression =UMINUS      { result = UnaryMinus::new(val[1])        }
              | '!' Expression              { result = Negate::new(val[1])            }
              | Expression '+' Expression   { result = Plus::new(val[0], val[2]);     }
              | Expression '-' Expression   { result = Minus::new(val[0], val[2])     }
              | Expression '*' Expression   { result = Product::new(val[0], val[2])   }
              | Expression '/' Expression   { result = Division::new(val[0], val[2])  }
              | Expression '%' Expression   { result = Mod::new(val[0], val[2])       }
              | Expression 'and' Expression { result = LogicAnd::new(val[0], val[2])  }
              | Expression 'or' Expression  { result = LogicOr::new(val[0], val[2])   }
              | Expression '==' Expression  { result = Equal::new(val[0], val[2])     }
              | Expression '!=' Expression  { result = Unequal::new(val[0], val[2])   }
              | Expression '<' Expression   { result = Less::new(val[0], val[2])      }
              | Expression '<=' Expression  { result = LessEq::new(val[0], val[2])    }
              | Expression '>' Expression   { result = Greater::new(val[0], val[2])   }
              | Expression '>=' Expression  { result = GreaterEq::new(val[0], val[2]) }
              | '(' Expression ')'          { result = val[1]                         }
              ;

    Array: '[' LinesPlus ArrayList LinesPlus ']' { result = val[2] }
         | '[' ArrayList LinesPlus ']'           { result = val[1] }
         | '[' LinesPlus ArrayList ']'           { result = val[2] }
         | '[' ArrayList ']'                     { result = val[1] }
         ;

    ArrayList: ArrayList ',' Expression           { result = (val[0] << val[2]) }
             | ArrayList ',' LinesPlus Expression { result = (val[0] << val[3]) }
             | Expression                         { result = [val[0]]           }
             ;

    LinesPlus: 'nl'           
             | 'nl' LinesPlus
             | ';'            
             | ';' LinesPlus 
             ;

---- header ----

require_relative "../lexer/lexer"
require_relative "translator"

class SyntacticError < RuntimeError
    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error: #{@token} line: #{@token.line} -- column: #{@token.column}"   
    end
end

$global_packages = []

---- inner ----

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end
   
def next_token
    token = @lexer.next
    #p token.name
    return [false,false] unless token
    return [token.class,token]
end
   
def parse(lexer)
    @yydebug = true
    @lexer = lexer
    @tokens = []
    ast = do_parse
    return ast
end