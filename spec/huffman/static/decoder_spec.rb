require 'spec_helper'

# describe Huffman::Static::Decoder do
#   describe '#decoder!', pending: true do
#     let(:data) { 'fuad saud' }
#     let(:input) {
#       StringIO.new(
#         Huffman::Static::Encoder.new(StringIO.new(data), StringIO.new).encode!
#       )
#     }
#     let(:output) { StringIO.new }
#     subject { output.string }

#     before do
#       Huffman::Static::Encoder.new(input, output).decode!
#     end

#     it 'encodes, duh!' do
#       expect(subject).to eq data
#     end
#   end
# end
