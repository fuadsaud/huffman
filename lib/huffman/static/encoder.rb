require 'bis'
require 'powerpack'
require 'pqueue'
require 'huffman/static/node'
require 'huffman/static/link_node'
require 'huffman/static/leaf_node'

module Huffman
  module Static
    class Encoder
      def initialize(input, output)
        @input_stream = input
        @output_stream = output
      end

      def encode!
        codes = @input_stream.read.chars.map(&:ord)

        lengths = build_tree(codes.frequencies).paths.each_with_object({}) do |(code, path),  lengths|
          lengths[code] = path.size - 1
        end

        paths = build_tree2(lengths).paths

        @output_stream.write lengths.size.chr
        @output_stream.write lengths.map { |code, lenght| "#{ code.chr } #{ lengths[code].chr }" }.join

        bitset = codes.inject(Bis.new(0)) do |bitset, code|
          bitset.concat(paths[code])
        end

        bitset.each_byte do |byte|
          @output_stream.write byte.to_i.chr
        end
      end

      private

      def build_tree2(lengths)
        old_array = []
        lengths.max_by { |code| lengths[code] }.last.downto(0).each do |i|
          new_array = lengths.select { |_code, length| length == i }
                             .map { |code, _lenght| LeafNode.new(1, code) }

          old_array.each_slice(2) do |i, j|
            new_array << LinkNode.new(i.value + j.value, left: i, right: j)
          end

          old_array = new_array
        end

        old_array.pop
      end

      def build_tree(frequencies)
        nodes = nodes_for_frequencies(frequencies).tap { |nodes|
          until nodes.size == 1
            nodes << combine_nodes(nodes.pop, nodes.pop)
          end
        }.pop
      end

      def nodes_for_frequencies(frequencies)
        frequencies.each.each_with_object(PQueue.new { |a, b| a.value > b.value }) do |(code, frequency), queue|
          queue << LeafNode.new(frequency, code)
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
