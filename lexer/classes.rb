require_relative "tokens"

class TkToken
    attr_accessor :text,
                  :line,
                  :column

    class << self
        attr_accessor :regex
    end

    def initialize t, l, c
        @text   = t
        @line   = l
        @column = c
    end

    def self.name
        super[2..-1]
    end

    def name
        @text
    end

    def to_s_error
        "a #{self.class.name}:'#{name.downcase}' does not go here -->"
    end
end

def class_name sym
    (sym.to_s.split(/\_/).map { |w| w.capitalize }).insert(0,"Tk").join.to_sym
end

$tokens_class = Hash::new

$tokens.each do |s,r|
    new_class       = Class::new TkToken
    new_class.regex = r
    Object::const_set((class_name s), new_class)
    $tokens_class[s] = new_class
end