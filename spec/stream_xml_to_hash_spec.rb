#coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe StreamXMLToHash do
  describe '#convert' do
    context '1階層のXMLである' do
      before do
        @xml = StringIO.new(xml_nesting_of_one_tier)
        @hash = hash_nesting_of_one_tier
      end

      it 'return Hash' do
        subject.convert(@xml, [:book]) do |row|
          row.should eq(@hash.shift)
        end
      end
    end

    context '2階層以上のXMLである' do
      before do
        @xml = StringIO.new(xml_nesting_of_two_tier)
      end

      it 'raise error' do
        expect { subject.convert(@xml, [:book]){} }.to raise_error
      end
    end

    context '同名のタグがネストしている' do
      before do
        @xml = StringIO.new(xml_nesting_of_same_tag)
      end

      it 'raise error' do
        expect { subject.convert(@xml, [:book]){} }.to raise_error
      end
    end
  end
end