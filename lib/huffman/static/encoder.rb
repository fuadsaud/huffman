require 'powerpack/enumerable/frequencies'
require 'huffman/static'

module Huffman
  module Static
    class Encoder
      extend Forwardable

      def initialize(input: STDIN, output: STDOUT, logger: nil)
        @in = input
        @out = output
        @logger = logger || Logger.new(STDERR).tap { |l|
          l.formatter = ->(severity, datetime, progname, msg) { "\t#{ msg }\n" }
        }
      end

      def encode!
        info "Reading data."
        codes = read.bytes

        fail 'No data to encode.' if codes.empty?

        info "Input has #{ codes.size } bytes."

        info "Building tree..."

        tree = build_tree_from_frequencies(codes.frequencies)

        lengths = codeword_lengths_for_tree(tree)

        info "#{ lengths.size } leaves."

        codewords = build_tree_from_codewords_lengths(lengths).codewords

        info "Encoding..."

        coding = coding_for(codes, codewords)

        info "Done. Output has " +
             "#{ 1 + lengths.size  * 2 + coding.size.fdiv(8.0).ceil } bytes."

        info "Writing data."

        write_header(lengths)
        write_coding(coding)

        info "Done."
      end

      private

      def_delegators :@in, :read
      def_delegators :@out, :write
      def_delegators :@logger, :debug, :info, :warn, :error

      def write_header(lengths)
        write lengths.size.-(1).chr
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
