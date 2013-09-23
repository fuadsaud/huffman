require 'bis'
require 'powerpack'
require 'pqueue'
require 'huffman/static/link_node'
require 'huffman/static/value_node'

module Huffman
  module Static
    class Encoder
      def initialize(input, output)
        @input_stream = input
        @output_stream = output
      end

      def encode!
        codes = @input_stream.read.chars.map(&:to_sym)
        tree = build_tree(codes.frequencies)
        paths = tree.paths

        @output_stream.puts paths
        @output_stream.puts(codes.map { |c| paths[c] }.join)
      end

      private

      def build_tree(frequencies)
        nodes = nodes_for_frequencies(frequencies).tap { |nodes|
          nodes << combine_nodes(nodes.pop, nodes.pop) until nodes.size == 1
        }.pop
      end

      def nodes_for_frequencies(frequencies)
        frequencies.each.each_with_object(PQueue.new { |a, b| a.value < b.value }) do |(code, frequency), queue|
          queue << ValueNode.new(frequency, code)
        end
      end

      def combine_nodes(node_a, node_b)
        LinkNode.new(node_a + node_b, left: node_a, right: node_b).tap { |p|
          node_a.parent = p
          node_b.parent = p
        }
      end
    end
  end
end
