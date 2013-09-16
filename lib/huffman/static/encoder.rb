require 'bis'
require 'powerpack'
require 'huffman/static/node'
require 'huffman/static/nil_node'

module Huffman
  module Static
    class Encoder
      def initialize(input, output)
        @input_stream = input
        @output_stream = output
      end

      def encode!
        input = @input_stream.read
        tree = build_tree(input.chars.frequencies)
        paths = tree.paths

        @output_stream.puts paths
        # @output_stream.puts(input.each_char.map { |c| paths[c] + "\n" })
      end

      private

      def build_tree(frequencies)
        nodes = frequencies.each.each_with_object([]) do |(code, frequency), list|
          list << Node.new(value: frequency, code: code)
        end

        until nodes.size == 1
          smallest = nodes.min_by { |node| node.value }
          nodes.delete(smallest)

          second_smallest = nodes.min_by { |node| node.value }
          nodes.delete(second_smallest)

          combined = Node.new(value: smallest.value + second_smallest.value,
                              left: smallest, right: second_smallest)
          smallest.parent = combined
          second_smallest.parent = combined

          nodes << combined
        end

        nodes.pop
      end
    end
  end
end
