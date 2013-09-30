require 'spec_helper'

describe Huffman::Static::Encoder do
  describe '#encode!' do
    let(:data) { 'abcd' }
    let(:input) { StringIO.new(data) }
    let(:output) { StringIO.new }
    subject { output.string }

    before do
      Huffman::Static::Encoder.new(input, output).encode!
    end

    it 'encodes, duh!' do
      dec = [4, 97, 3, 98, 3, 99, 2, 100, 1, 103, 71]

      lol = subject
      lol.force_encoding 'ASCII-8BIT'
      expect(lol.codepoints).to eq dec
    end
  end
end
