require 'bis'
require 'powerpack'
require 'pqueue'
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
        nodes = frequencies.each.each_with_object(PQueue.new { |a, b| a.value < b.value }) do |(code, frequency), queue|
          queue << Node.new(value: frequency, code: code)
        end

        until nodes.size == 1
          low = [nodes.pop, nodes.pop]
          parent = Node.new value: low.reduce(0) { |a, e| a + e.value },
                            left: low.first,
                            right: low.last

          low.each { |n| n.parent = parent }

          nodes << parent
        end

        nodes.pop
      end
    end
  end
end
