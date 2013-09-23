module Huffman
  module Static
    class LinkNode
      attr_accessor :parent, :left, :right
      attr_reader :value

      def initialize(value, parent: nil, left: nil, right: nil)
        @value  = value
        @parent = parent
        @left   = left
        @right  = right
      end

      def leaf?
        false
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
        @left.paths(current_path: current_path.concat(0)).merge(
          @right.paths(current_path: current_path.concat(1))
        )
      end
    end
  end
end
