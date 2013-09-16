module Huffman
  module Static
    class NilNode
      attr_accessor :parent, :left, :right
      attr_reader :value, :code

      def initialize(value: nil, code: nil, parent: nil, left: nil, right: nil)
        @value  = nil
        @code   = code
        @parent = parent
        @left   = nil
        @right  = nil
      end

      def leaf?
        true
      end

      def paths(current_path: '', paths_map: {})
        {}
      end
    end
  end
end
