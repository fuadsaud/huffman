require 'spec_helper'

describe Huffman::Static::Decoder do
  describe '#encode!' do
    let(:encoded) { [4, 97, 3, 98, 3, 99, 2, 100, 1, 103, 71].map(&:chr).join }
    let(:decoded) { 'abcd' }
    let(:input) { StringIO.new(encoded) }
    let(:output) { StringIO.new }
    subject { output.string }

    before do
      Huffman::Static::Decoder.new(input, output).decode!
    end

    it 'decodes, duh!' do
      expect(subject).to eq decoded
    end
  end
end
