module Huffman
  module Static
    class Node
      attr_accessor :parent, :left, :right
      attr_reader :value, :code

      def initialize(value: nil, code: nil, parent: nil, left: NilNode.new,
                                                         right: NilNode.new)
        @value  = value
        @code   = code
        @parent = parent
        @left   = left
        @right  = right
      end

      def leaf?
        !!@code
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
        paths_map = {}

        if @left.leaf?
          paths_map[@left.code] = current_path.concat(0)
        else
          paths_map.merge!(@left.paths(current_path: current_path.concat(0)))
        end

        if @right.leaf?
          paths_map[@right.code] = current_path.concat(1)
        else
          paths_map.merge!(@right.paths(current_path: current_path.concat(1)))
        end

        paths_map
      end
    end
  end
end
