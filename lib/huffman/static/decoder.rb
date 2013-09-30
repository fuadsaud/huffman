require 'huffman/static'

module Huffman
  module Static
    class Decoder
      def initialize(input, output)
        @input_stream = input
        @output_stream = output
      end

      def decode!
        header_size = @input_stream.readbyte

        codewords_lenghts = header_size.times.with_object({}) do |lenghts|
          lengths[@input_stream.readbyte] = @input_stream.readbyte
        end

        puts codewords_lenghts
        puts Static.from_codewrods_lengths
      end
    end
  end
end
