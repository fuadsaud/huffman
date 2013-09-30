module Huffman
  module Static
    class LinkNode < Node
      attr_accessor :left, :right

      def initialize(value, parent: nil, left: nil, right: nil)
        @value  = value
        @parent = parent
        @left   = left
        @right  = right
      end

      def leaf?
        false
      end

      def codewords(current_path: Bis.new(1))
        left.codewords(current_path: current_path.concat(0)).merge(
          right.codewords(current_path: current_path.concat(1))
        )
      end

      def walk(&block)
        (yield(self).zero? ? left : right).walk(&block)
      end
    end
  end
end
