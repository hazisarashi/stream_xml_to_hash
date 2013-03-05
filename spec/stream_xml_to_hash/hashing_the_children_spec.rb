#coding: utf-8
require File.join(File.dirname(__FILE__), '../spec_helper')

describe StreamXMLToHash::HashingTheChildren do
  describe '#children_to_hash' do
    context 'タグが重複している' do
      before do
        @hash = {
          :children=>[
            { :name=>"author", :text=>"高橋 征義" },
            { :name=>"author", :text=>"後藤 裕蔵" },
          ]
        }.extend StreamXMLToHash::HashingTheChildren
      end
      it 'raise error' do
        expect{ @hash.children_to_hash }.to raise_error
      end
    end

    context 'タグが重複していない' do
      before do
        @hash = {
          :children=>[
            {:name=>"title", :text=>"プログラミング言語 Ruby"},
            {:name=>"author", :text=>"まつもと ゆきひろ"},
          ]
        }.extend StreamXMLToHash::HashingTheChildren
      end
      it 'return Converted Hash' do
        @hash.children_to_hash.should eq({title: "プログラミング言語 Ruby", author: "まつもと ゆきひろ"})
      end
    end
  end
end