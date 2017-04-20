$ast = [
    [:Program, [:@objects], []],
    [:Use, [:@names, :@argv], []],
    [:Instance, [:@id, :@cl, :@argv], []],
    [:Reopen, [:@id, :@argv], []],
    [:MethodCall, [:@lhs, :@rhs], []],
    [:CommandCall, [:@id, :@args], []],
    [:Insert, [:@lhs, :@rhs], []],
    [:PInsert, [:@lhs, :@rhs], []],
    [:Export, [:@lhs, :@rhs], []],
    [:QuotedString, [:@qs], []],
    [:Size, [:@digit, :@unit], []],
    [:Paper, [:@paper], []],
    [:Font, [:@size], []],
    [:Align, [:@direction], []],
    [:Identifier, [:@id], []],
    [:SingletonArg, [:@id, :@exp], []],
    [:Expression, [], [
        [:ExpressionB, [:@operand1, :@operand2], [
            [:Division,[],[]],
            [:Equal,[],[]],
            [:Greater,[],[]],
            [:GreaterEq,[],[]],
            [:Less,[],[]],
            [:LessEq,[],[]],
            [:LogicAnd,[],[]],
            [:LogicOr,[],[]],
            [:Minus,[],[]],
            [:Mod,[],[]],
            [:Plus,[],[]],
            [:Product,[],[]],
            [:Unequal,[],[]]
        ]],
        [:ExpressionU, [:@operand], [
            [:Negate,[],[]],
            [:UnaryMinus,[],[]]
        ]]
    ]]
]

def create_class superclass, name, attributes
    new_class = Class::new superclass do
        class << self
            attr_reader :attr
        end

        if superclass.eql? Object; @attr = attributes
        else @attr = attributes + superclass.attr; end

        @attr.each do |a|
            define_method("#{a[1..-1]}=".to_sym) { |v| instance_variable_set a, v }
            define_method(a[1..-1].to_sym) { instance_variable_get a }
        end

        def self.class
            Object::const_get(name)
        end

        def initialize(*attr)
            if self.class.attr.length != attr.length
                raise ArgumentError::new(
                    "wrong number of arguments " + "#{self.class.name} " +
                    "(#{attr.length} for #{self.class.attr.length})"
                )
            end
            [self.class.attr, attr].transpose.map { |a,v| instance_variable_set a, v }
        end
    end
    Object::const_set(name, new_class)
end

def create_ast superclass, tree
  tree.each do |cls|
    nc = create_class superclass, cls[0], cls[1]
    create_ast nc, cls[2]
  end
end

class AST
    class << self
        attr_reader :attr
    end

    @attr = []

    def to_rb
        to_s
    end
end

create_ast AST, $ast

class Use

    @@counter = 0

    def self.counter
        @@counter
        @@counter += 1
    end
end

class Size
    def initialize s
        s =~ /\A-?\d+/

        @digit = $&.to_i
        @unit  = $'
    end
end