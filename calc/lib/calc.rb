require "calc/version"

module Calc
  class Calculation
    attr_reader :tokens, :parse_tree

    @@patterns  = {
      :integer  => /^(\d+)(.*)/,
      :operator => /^([\+\-\*\/])(.*)/
    }

    def initialize(calculation_string)
      @calculation_string = calculation_string
      @tokens             = []
      @parse_tree         = []

      tokenize
      @parse_tree = parse(@tokens)
    end
  
    def tokenize
      remainder = @calculation_string.gsub(/\s/, "")

      until remainder.empty?
        if @@patterns.values.any?{|p| remainder =~ p }
          @tokens << $1
          remainder = $2
        else
          raise RuntimeError, "Fucked String"
        end
      end

      self
    end

    def parse(tokens)
      if tokens.length == 1
        tokens[0]
      elsif tokens.length > 2
        [
          tokens[1],
          [ tokens[0], parse(tokens[2..-1]) ]
        ]
      else
        raise RuntimeError, "Fucked Tokens"
      end
    end

    def solve
      eval(@parse_tree)
    end

    def eval(expression)
      if expression.is_a? Array
        operation, children = expression

        case operation
          when "+" then eval(children[0]) + eval(children[1])
          when "-" then eval(children[0]) - eval(children[1])
          when "*" then eval(children[0]) * eval(children[1])
          when "/" then eval(children[0]) / eval(children[1])
          else raise RuntimeError, "Unknown Operation"
        end
      elsif expression =~ /\d+/
        expression.to_i
      else
        raise RuntimeError, "Unknown Expression"
      end
    end
  end
end
