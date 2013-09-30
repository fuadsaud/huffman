require 'powerpack'
require 'huffman/static'

module Huffman
  module Static
    class Encoder
      extend Forwardable

      def_delegators :@in, :read
      def_delegators :@out, :write

      def initialize(input, output)
        @in = input
        @out = output
      end

      def encode!
        codes = read.chars.map(&:ord)

        tree = build_tree_from_frequencies(codes.frequencies)

        lengths = codeword_lengths_for_tree(tree)

        codewords = build_tree_from_codewords_lengths(lengths).codewords

        coding = coding_for(codes, codewords)

        write_header(lengths)
        write_coding(coding)
      end

      private

      def write_header(lengths)
        write lengths.size.chr
        write lengths.map { |code, length|
          "#{ code.chr }#{ length.chr }"
        }.join
      end

      def write_coding(coding)
        coding.each_byte do |byte|
          write byte.to_i.chr
        end
      end

      def codeword_lengths_for_tree(tree)
        tree.codewords.each_with_object({}) do |(code, path), lengths|
          lengths[code] = path.size - 1
        end
      end

      def build_tree_from_frequencies(frequencies)
        Static.from_frequencies(frequencies)
      end

      def build_tree_from_codewords_lengths(lengths)
        Static.from_codewords_lengths(lengths)
      end

      def coding_for(codes, codewords)
        codes.inject(Bis.new(0)) do |bitset, code|
          bitset.concat(codewords[code])
        end
      end
    end
  end
end
