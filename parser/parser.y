class Parser

    token  'and' 'break' 'case' 'class' 'do' 'else' 'elsif' 'false' 'for' 'fun'
           'if' 'in' 'let' 'loop' 'nil' 'nl' 'or' 'rescue' 'return' 'self' 'super'
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
        'in'         'TkIn'
        'let'        'TkLet'
        'loop'       'TkLoop'
        'nil'        'TkNil'
        'nl '        'TkNewLine'
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
        '*'          'TkArterisk'
        '/'          'TkSlash'
        '%'          'TkPercent'
        '='          'TkAssign'
        '!'          'TkNegation'
        '=='         'TkEqual'
        '!='         'TkNotEqual'
        '<'          'TkLess'
        '<='         'TkLessEqual'
        '>'          'TkGreater'
        '>='         'TkGreaterEqual'
        '<<'         'TkInsert'
        'string'     'TkString'
        'identifier' 'TkIdentifier'
        'constant'   'TkConstant'
        'size'       'TkSize'
        'number'     'TkNumber'
end

start Program

rule

    Program: LinesPlus Packages Elements
           | Packages Elements
           ;

    Packages: Packages 'use' PackList LinesPlus
            | 'use' PackList LinesPlus
            ;

    PackList: PackList ',' 'identifier'
            | 'identifier'
            ;

    Elements: Elements Object
            | Elements LinesPlus Object
            | Object
            ;

    Object: 'identifier' '::' 'constant' Args
          #| 'identifier' '::' 'constant' # shift-reduce
          ;

    Args: LinesPlus '{' LinesPlus ArgList LinesPlus '}'
        | LinesPlus '{' ArgList LinesPlus '}'
        | LinesPlus '{' LinesPlus ArgList '}'
        | '{' LinesPlus ArgList LinesPlus '}'
        | '{' ArgList LinesPlus '}'
        | '{' LinesPlus ArgList '}'
        | '{' ArgList '}'
        | '{' '}' #'nl'
        ;

    ArgList: ArgList LinesPlus SingletonArg
           | SingletonArg
           ;

    SingletonArg: 'identifier' ':' Expression
                ;

    Expression: 'string'
              | 'size'
              | 'number'
              | 'true'
              | 'false'
              | 'identifier'
              | Array
              | '-' Expression =UMINUS
              | '!' Expression
              | Expression '+' Expression
              | Expression '-' Expression
              | Expression '*' Expression
              | Expression '/' Expression
              | Expression '%' Expression
              | Expression 'and' Expression
              | Expression 'or' Expression
              | Expression '==' Expression
              | Expression '!=' Expression
              | Expression '<' Expression
              | Expression '<=' Expression
              | Expression '>' Expression
              | Expression '>=' Expression
              | '(' Expression ')'
              ;

    Array: '[' LinesPlus ArrayList LinesPlus ']'
         | '[' ArrayList LinesPlus ']'
         | '[' LinesPlus ArrayList ']'
         | '[' ArrayList ']'
         ;

    ArrayList: ArrayList ',' Expression  
             | ArrayList ',' LinesPlus Expression
             | Expression
             ;

    LinesPlus: LinesPlus 'nl'
             | 'nl'
             ;

---- header ----

require_relative '../lexer/lexer'
#require_relative 'Interpreter2'

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error '#{@token.to_s}' -- line: #{@token.line} -- column: #{@token.column}."   
    end
end

---- inner ----

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end
   
def next_token
    token = @lexer.next
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