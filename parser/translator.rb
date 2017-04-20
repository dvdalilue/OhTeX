require_relative "ast"

class Program
    def to_rb
        rb = "require_relative \"../bin/ohtex\"\n\n"
        @objects.reverse_each { |o| rb << "#{o.to_rb}\n" }
        rb
    end
end

class Use
    def to_rb
        rb = "pack#{Use.counter} = Package.new("
        if @argv.empty?
            rb << "\"#{@names.join(",")}\")"
        else
            rb << "\"#{@names[0]}\",\"#{(@argv.map { |a| a.exp.to_rb }).join(",")}\")"
        end
        rb
    end
end

class Instance
    def to_rb
        rb = "\n#{@id} = #{@cl}.new()"
        #if @cl 
        if @cl =~ /\b(Article|Report|Book|Letter|Slides|Beamer)\b/
            $global_packages.each_with_index { |p,i| rb << "\n#{@id}.add_package pack#{i+1}" }
        end
        @argv.each do |sa|
            rb += "\n#{@id}.#{sa.id} = #{sa.exp.to_rb}"
        end
        rb
    end
end

class Reopen
    def to_rb
        rb = "\n"
        @argv.each do |sa|
            rb += "#{@id}.#{sa.id.to_rb} = #{sa.exp.to_rb}\n"
        end
        rb
    end
end

class MethodCall
    def to_rb
        rb = "#{@lhs} = #{@rhs.to_rb}"
        rb
    end
end

class CommandCall
    def to_rb
        rb = "#{@id}(#{(@args.reverse.map { |e| e.to_rb }).join(',')})"
        rb
    end
end

class Insert
    def to_rb
        "\n#{@lhs.to_rb} << #{@rhs.to_rb}"
    end
end

class PInsert
    def to_rb
        "\n#{@lhs.to_rb}.preamble << #{@rhs.to_rb}"
    end
end

class Export
    def to_rb
        #"\nputs #{@lhs.to_rb}.to_tex"
        "\nopen(\'#{@rhs.to_rb[1..-2]}.tex\', 'w') { |f|\n f.puts #{@lhs.to_rb}.to_tex\n}"
    end
end

class QuotedString
    def to_rb
        @qs
    end
end

class Size
    def to_rb
        "\'#{@digit}#{unit}\'"
    end
end

class Paper
    def to_rb
        if @paper =~ /(b0j|b1j|b2j|b3j|b4j|b5j|b6j)/
            return "\'#{@paper}\'"
        else
            return "\'#{@paper}paper\'"
        end
    end
end

class Font
    def to_rb
        if @size =~ /(script|footnote|normal)/
            return "\'#{@size}size\'"
        else
            return "\'#{@size}\'"
        end
    end
end

class Align
    def to_rb
        return "\'#{if !@direction.eql? 'center' then 'flush' end}#{@direction}\'"
    end
end



class Identifier
    def to_rb
        @id
    end
end

class Array
    def to_rb
        rb = "[\n"
        self.each { |e| rb << "#{e.to_rb},\n" }
        rb << "\n]"
    end
end

class Fixnum
    def to_rb
        "#{self}"
    end
end

class TrueClass
    def to_rb
        "#{self}"
    end
end

class FalseClass
    def to_rb
        "#{self}"
    end
end

class String; def to_rb; self; end; end

class Division; def to_rb; "(#{@operand1.to_rb} / #{@operand2.to_rb})"; end; end
class Equal; def to_rb; "(#{@operand1.to_rb} == #{@operand2.to_rb})"; end; end
class Greater; def to_rb; "(#{@operand1.to_rb} > #{@operand2.to_rb})"; end; end
class GreaterEq; def to_rb; "(#{@operand1.to_rb} >= #{@operand2.to_rb})"; end; end
class Less; def to_rb; "(#{@operand1.to_rb} < #{@operand2.to_rb})"; end; end
class LessEq; def to_rb; "(#{@operand1.to_rb} <= #{@operand2.to_rb})"; end; end
class LogicAnd; def to_rb; "(#{@operand1.to_rb} && #{@operand2.to_rb})"; end; end
class LogicOr; def to_rb; "(#{@operand1.to_rb} || #{@operand2.to_rb})"; end; end
class Minus; def to_rb; "(#{@operand1.to_rb} - #{@operand2.to_rb})"; end; end
class Mod; def to_rb; "(#{@operand1.to_rb} % #{@operand2.to_rb})"; end; end
class Plus; def to_rb; "(#{@operand1.to_rb} + #{@operand2.to_rb})"; end; end
class Product; def to_rb; "(#{@operand1.to_rb} * #{@operand2.to_rb})"; end; end
class Unequal; def to_rb; "(#{@operand1.to_rb} != #{@operand2.to_rb})"; end; end
class Negate; def to_rb; "!#{@operand.to_rb}"; end; end
class UnaryMinus; def to_rb; "-#{@operand.to_rb}"; end; end