Stream XML to Hash
==================

REXML::StreamListener を使用して、XML を Hash に変換するモジュールです。


使い方
------

下記の様にして使用します。

    source = File.new('data.xml')
    StreamXMLToHash.convert source, [:Tag1, :Tag2] do |row|
      p row #=> {:name=>"Tag1", :text=>"Content", :attrs=>{"attr"=>"value"} :children=>[:name=>"ChildTagName", :text=>"Content"}, ...]}
    end


Copyright
---------

Copyright (c) 2012 hazi.
Licensed under the Apache License, Version 2.0.

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
