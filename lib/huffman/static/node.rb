module Huffman
  module Static
    class Node
      include Comparable

      attr_accessor :parent
      attr_reader :value

      def <=>(other)
        value <=> other.value
      end

      def +(other)
        value + other.to_i
      end

      def to_i
        value
      end
    end
  end
end
