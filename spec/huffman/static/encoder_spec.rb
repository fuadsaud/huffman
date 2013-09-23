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
      expect(subject).to eq %({:u=><<00000>> 0, :a=><<00001>> 1,) +
                            %( :d=><<0001>> 1, :f=><<001>> 1, :" ") +
                            %(=><<01>> 1, :s=><<1>> 1}\n001000000) +
                            %(0001000101100001000000001\n)
    end
  end
end
