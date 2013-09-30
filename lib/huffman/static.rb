require 'bis'
require 'pqueue'
require 'huffman/static/node'
require 'huffman/static/link_node'
require 'huffman/static/leaf_node'

module Huffman
  module Static
    def self.from_codewords_lengths(lengths)
      lengths.values.max.downto(0).inject([]) { |nodes, current_length|
        new_nodes = lengths
                      .select { |_code, length| length == current_length }
                      .map { |code, _lenght| LeafNode.new(1, code) }

        nodes.each_slice(2) do |i, j|
          new_nodes << combine_nodes(i, j)
        end

        new_nodes
      }.pop
    end

    def self.from_frequencies(frequencies)
      nodes_for_frequencies(frequencies).tap { |nodes|
        until nodes.size == 1
          nodes << combine_nodes(nodes.pop, nodes.pop)
        end
      }.pop
    end

    private

    def self.nodes_for_frequencies(frequencies)
      frequencies
        .each
        .with_object(new_node_priority_queue) do |(code, frequency), queue|
        queue << LeafNode.new(frequency, code)
      end
    end

    def self.combine_nodes(node_a, node_b)
      LinkNode.new(node_a + node_b, left: node_a, right: node_b).tap { |p|
        node_a.parent = p
        node_b.parent = p
      }
    end

    def self.new_node_priority_queue
      PQueue.new { |a, b| a.value > b.value }
    end
  end
end
