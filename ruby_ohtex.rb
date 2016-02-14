#!/bin/ruby

require_relative "lexer/lexer"

require_relative "core/Article"
require_relative "core/Package"
require_relative "core/List"
require_relative "core/Text"
require_relative "core/Table"

file = File::open(ARGV[0], "r:utf-8")

input = file.read

#file
#  .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

#file = file.encode('iso-8859-1')
#input.force_encoding('cp1252')

lexer = Lexer.new input

while lexer.next; end