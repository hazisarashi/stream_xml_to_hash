#coding: utf-8
require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplecov'; SimpleCov.start
require 'rspec'

require "stream_xml_to_hash"

def xml_nesting_of_one_tier
  <<-END
  <?xml version="1.0"?>
  <catalog>
    <book id="01" status="true">
      <title>たのしいRuby 第3版</title>
      <author>高橋 征義</author>
      <author>後藤 裕蔵</author>
      <ISBN type="10">4797357401</ISBN>
      <ISBN type="13">978-4797357400</ISBN>
    </book>
    <book id="02" status="true">
      <title>プログラミング言語 Ruby</title>
      <author>まつもと ゆきひろ</author>
      <author>David Flanagan</author>
      <ISBN type="10">4873113946</ISBN>
      <ISBN type="13">978-4873113944</ISBN>
    </book>
    <book id="03" status="false">削除されました</book>
  </catalog>
  END
end

def hash_nesting_of_one_tier
  [
    {
      :name=>"book",
      :attrs=>{"id"=>"01", "status"=>"true"},
      :text=>"",
      :children=>[
        { :name=>"title", :text=>"たのしいRuby 第3版" },
        { :name=>"author", :text=>"高橋 征義" },
        { :name=>"author", :text=>"後藤 裕蔵" },
        { :name=>"ISBN", :attrs=>{"type"=>"10"},
          :text=>"4797357401"},
        { :name=>"ISBN",:attrs=>{"type"=>"13"},
          :text=>"978-4797357400"}
      ]
    },
    {
      :name=>"book",
      :attrs=>{"id"=>"02", "status"=>"true"},
      :text=>"",
      :children=>[
        {:name=>"title", :text=>"プログラミング言語 Ruby"},
        {:name=>"author", :text=>"まつもと ゆきひろ"},
        {:name=>"author", :text=>"David Flanagan"},
        {:name=>"ISBN", :attrs=>{"type"=>"10"},
          :text=>"4873113946"},
        {:name=>"ISBN", :attrs=>{"type"=>"13"},
          :text=>"978-4873113944"}
      ]
    },
    {
      :name=>"book",
      :attrs=>{"id"=>"03", "status"=>"false"},
      :text=>"削除されました"
    }
  ]
end

def xml_nesting_of_two_tier
  <<-END
  <?xml version="1.0"?>
  <catalog>
    <book id="01">
      <authors>
        <author>高橋 征義</author>
        <author>後藤 裕蔵</author>
      </authors>
    </book>
  </catalog>
  END
end

def xml_nesting_of_same_tag
  <<-END
  <?xml version="1.0"?>
  <catalog>
    <book id="01"><book></book>
  </catalog>
  END
end