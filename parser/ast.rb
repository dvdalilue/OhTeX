class AST

end

class Program < AST
    attr_accessor :objects

    def initialize os
        @objects = os
    end
end

class Packages < AST
    attr_accessor :ps

    def initialize ps
        @ps = ps
    end
end

class Use < AST
    attr_accessor :name,
                  :argv

    def initialize name, as
        @name = name
        @argv = as
    end
end

class Instance < AST
    attr_accessor :id,
                  :class,
                  :argv

    def initialize id, cl, args
        @id    = id
        @class = cl
        @argv  = args
    end
end

class Reopen < AST
    attr_accessor :id,
                  :argv

    def initialize id, args
        @id    = id
        @argv  = args
    end
end

class SingletonArg < AST
    attr_accessor :id,
                  :exp

    def initialize id, exp
        @id  = id
        @exp = exp
    end
end

class Division < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2= op1
        @operand2 = op2
    end
end

class Equal < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Greater < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class GreaterEq < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Less < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class LessEq < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class LogicAnd < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class LogicOr < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Minus < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Mod < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Plus < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Product < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Unequal < AST
    attr_accessor :operand1,
                  :operand2

    def initialize op1, op2
        @operand1 = op1
        @operand2 = op2
    end
end

class Negate < AST
    attr_accessor :operand

    def initialize op
        @operand = op
    end
end

class UnaryMinus < AST
    attr_accessor :operand

    def initialize op
        @operand = op
    end
end