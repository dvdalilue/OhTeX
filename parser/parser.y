class Parser

    token  'and' 'break' 'case' 'class' 'do' 'else' 'elsif' 'false' 'for' 'fun'
           'if' 'loop' 'nil' 'nl' 'or' 'rescue' 'return' 'self' 'super'
           'true' 'try' 'until' 'use' 'when' 'while' 'string' 'identifier'
           'constant' 'size' 'number' '{' '}' '[' ']' '(' ')' '.' '::' ':' ';'
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
        'do'         'TkDo'
        'else'       'TkElse'
        'elsif'      'TkElsif'
        'false'      'TkFalse'
        'for'        'TkFor'
        'fun'        'TkFun'
        'if'         'TkIf'
        'loop'       'TkLoop'
        'nil'        'TkNil'
        'nl'         'TkNewLine'
        'or'         'TkOr'
        'rescue'     'TkRescue'
        'return'     'TkReturn'
        'self'       'TkSelf'
        'super'      'TkSuper'
        'true'       'TkTrue'
        'try'        'TkTry'
        'until'      'TkUntil'
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
        'string'     'TkString'
        'identifier' 'TkIdentifier'
        'constant'   'TkConstant'
        'size'       'TkNumSize'
        'number'     'TkNumber'
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
          | Instance { result = val[0] }
          | Reopen   { result = val[0] }
          ;

    Package: 'use' PackList { result = Use::new(val[1],[]) }
           #| 'use' PackList Args { result = Use::new(val[1],val[2]) }
           ;

    PackList: 'identifier'              { result = [val[0]]           }
            | 'identifier' ',' PackList { result = (val[2] << val[0]) }
            ;

    Instance: 'identifier' '::' 'constant' Args { result = Instance::new(val[0],val[2],val[3]) }
            ;

    Reopen: 'identifier' Args { result = Reopen::new(val[0],val[1]) }
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

    SingleArg: 'identifier' ':' Expression { result = SingletonArg::new(val[0],val[2]) }
             ;

    Expression: 'string'                    { result = val[0]                         }
              | 'size'                      { result = val[0]                         }
              | 'number'                    { result = val[0]                         }
              | 'true'                      { result = val[0]                         }
              | 'false'                     { result = val[0]                         }
              | 'identifier'                { result = val[0]                         }
              | Array                       { result = val[0]                         }
              | '-' Expression =UMINUS      { result = UnaryMinus::new(val[1])        }
              | '!' Expression              { result = Negate::new(val[1])            }
              | Expression '+' Expression   { result = Plus::new(val[0], val[2])      }
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

    Array: '[' LinesPlus ArrayList LinesPlus ']' { result = Array::new(val[2]) }
         | '[' ArrayList LinesPlus ']'           { result = Array::new(val[1]) }
         | '[' LinesPlus ArrayList ']'           { result = Array::new(val[2]) }
         | '[' ArrayList ']'                     { result = Array::new(val[1]) }
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
require_relative "ast"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error: #{@token.to_s_error} line: #{@token.line} -- column: #{@token.column}"   
    end
end

---- inner ----

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end
   
def next_token
    token = @lexer.next
    #puts token.name
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