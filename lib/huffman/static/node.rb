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

      def paths(current_path: '', paths_map: {})
        p @left.left.class
        if @left.leaf?
          paths_map[@left.code] = current_path + '0'
        else
          @left.paths(current_path: current_path + '0', paths_map: paths_map)
        end

        if @right.leaf?
          paths_map[@right.code] = current_path + '1'
        else
          @right.paths(current_path: current_path + '1', paths_map: paths_map)
        end

        paths_map
      end
    end
  end
end
