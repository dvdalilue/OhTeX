#!/bin/ruby

require_relative "../parser/parser"

def lexer_rutex input
    file = File::open(input, "r:utf-8")
    input = file.read
    lexer = Lexer.new input
    lexer
end

def parser_rutex lexer
    parser = Parser::new
    return parser.parse lexer
end

def main file
    actual_lexer = lexer_rutex file
    actual_lexer.run

    unless actual_lexer.errors.empty?
        actual_lexer.errors.each { |t| puts "Unknow phrase: '#{t.text}'. Go to (#{t.line},#{t.column})" }
        puts "Bye, Bye!"
        return
    end

    begin
        ast = parser_rutex(lexer_rutex file)
    rescue SyntacticError => e
        p e.to_s
    end
end

main ARGV[0]