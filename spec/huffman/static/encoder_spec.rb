require 'spec_helper'

describe Huffman::Static::Encoder do
  describe '#encode!' do
    let(:data) { 'fuad saud' }
    let(:input) { StringIO.new(data) }
    let(:output) { StringIO.new }
    subject { output.string }

    before do
      Huffman::Static::Encoder.new(input, output).encode!
    end

    it 'encodes, duh!' do
      hex = [0x61, 0x73, 0x69, 0x64, 0x73, 0x61, 0x75, 0x64, 0x0a,
             0x04, 0x61, 0x20, 0x03, 0x62, 0x20, 0x03, 0x63, 0x20,
             0x02, 0x64, 0x20, 0x01, 0x31, 0x31, 0x0a, 0x67, 0x9f]

      lol = hex.map(&:chr).join
      expect(subject).to eq lol
    end
  end
end
