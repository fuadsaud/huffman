require 'huffman/static'

module Huffman
  module Static
    class Decoder
      extend Forwardable

      def initialize(input: STDIN, output: STDOUT, logger: nil)
        @in = input
        @out = output
        @logger = logger || Logger.new(STDERR).tap { |l|
          l.formatter = ->(severity, datetime, progname, msg) { "\t#{ msg }\n" }
        }
      end

      def decode!
        info "Reading data..."

        data = read.bytes

        info "Input has #{ data.size } bytes."

        header_size = data.shift + 1

        info "Found #{ header_size } codes."

        codewords_lenghts = header_size.times.with_object({}) do |_i, lengths|
          lengths[data.shift] = data.shift
        end

        info "Building tree..."

        tree = Static.from_codewords_lengths(codewords_lenghts)
        codewords = tree.codewords

        info "Done."

        fail 'No encoded data' if data.empty?

        info "Decoding..."

        coding = concat_bytes(data)

        decoded = translate(Bis.new(data.size * 8, value: coding), codewords)

        info "Done."

        info "Writing data..."

        write decoded

        info "Done."
      end

      private

      def_delegators :@in, :read, :readbyte, :each_byte
      def_delegators :@out, :write
      def_delegators :@logger, :debug, :info, :warn, :error

      def translate(bitset, codewords)
        bitset.inject(['', Bis.new(0)]) { |(decoded, current_path), bit|
          if (found_code = code_for_path(codewords, current_path))
            [decoded << found_code.chr, Bis.new(1, value: bit)]
          else
            [decoded, current_path.concat(bit)]
          end
        }.first
      end

      def code_for_path(codewords, path)
        codewords
          .detect(->{ [nil] }) { |_code, codeword|
            codeword.size == path.size && codewords == path
          }.first
      end

      def concat_bytes(bytes)
        bytes.reduce(Bis.new(bytes.size * 8)) { |bitset, byte|
          (bitset << 8) | byte
        }
      end
    end
  end
end
