require 'huffman/static'

module Huffman
  module Static
    class Decoder
      extend Forwardable

      def_delegators :@in, :read, :readbyte, :each_byte
      def_delegators :@out, :write

      def initialize(input, output)
        @in = input
        @out = output
      end

      def decode!
        data = read.bytes
        header_size = data.shift

        codewords_lenghts = header_size.times.with_object({}) do |_i, lengths|
          lengths[data.shift] = data.shift
        end

        tree = Static.from_codewords_lengths(codewords_lenghts)
        codewords = tree.codewords

        fail 'No encoded data' if data.empty?

        coding = concat_bytes(data)

        decoded = translate(Bis.new(data.size * 8, value: coding), codewords)

        write decoded
      end

      private

      def translate(bitset, codewords)
        bitset.inject(['', Bis.new(0)]) { |(decoded, current_path), bit|
          if (found_code = code_for_path(codewords, current_path))
            p found_code
            [decoded << found_code, Bis.new(1, value: bit)]
          else
            [decoded, current_path.concat(bit)]
          end
        }.first
      end

      def code_for_path(codewords, path)
        codewords
          .detect(->{ [nil] }) { |_code, codeword| codeword.to_s == path.to_s }
          .first
      end

      def concat_bytes(bytes)
        bytes.reduce(Bis.new(bytes.size * 8)) do |bitset, byte|
          (bitset << 8) | byte
        end
      end
    end
  end
end
