module Huffman
  module Static
    class LeafNode < Node
      attr_reader :code

      def initialize(value, code, parent: nil)
        @value  = value
        @code   = code
        @parent = parent
      end

      def leaf?
        true
      end

      def paths(current_path: Bis.new(0))
        { code => current_path }
      end

      def to_s
        "(code: #{ code }, value: #{ value })"
      end
    end
  end
end
