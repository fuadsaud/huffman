module Huffman
  module Static
    class ValueNode
      attr_accessor :parent
      attr_reader :value, :code

      def initialize(value, code, parent: nil)
        @value  = value
        @code   = code
        @parent = parent
      end

      def leaf?
        true
      end

      def <=>(other)
        value <=> other.value
      end

      def +(other)
        value + other.to_i
      end

      def to_i
        value
      end

      def paths(current_path: Bis.new(0))
        { code => current_path }
      end
    end
  end
end
