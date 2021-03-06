#coding: utf-8

# = Stream XML To Hash
# REXML::StreamListener を使用して、XML を Hash に変換するモジュールです。
# 
# 下記の様にして使用します。
# 
#   source = File.new('data.xml')
#   StreamXMLToHash.convert source, [:Tag1, :Tag2] do |row|
#     p row #=> {:name=>"Tag1", :text=>"Content", :attrs=>{"attr"=>"value"} :children=>[:name=>"ChildTagName", :text=>"Content"}, ...]}
#   end

require "rexml/document"
require "rexml/streamlistener"

module StreamXMLToHash 

  # *source* を REXML::StreamListener で読み、*capture_tag* で指定した
  # タグの開始から終わりまでのデータをハッシュ化します。
  # 
  # ハッシュ化したデータは、タグが終わり次第  *row* として *block* で受け取ることが出来ます。
  def convert(source, capture_tag, &block)
    REXML::Document.parse_stream(source, Listener.new(capture_tag.map{|tag|tag.to_sym }){|row| yield(row)})
  end

  module_function :convert

  # StreamListtener
  class Listener
    include REXML::StreamListener

    # 引数の *capture_tag* を捕捉したら、そのタグの内の情報をハッシュ化を開始。
    # タグが終了した時、そのハッシュした情報を *block* に渡します。
    #
    # 注意事項
    # - *capture_tag* 内に孫タグが存在する場合はエラーになります。
    # - *capture_tag* の処理中に *capture_tag* に含まれるタグが出現した場合もエラーになります。
    # 
    # *TODO:* *capture_tag* を適切なオブジェクトにし、孫タグなども問題なく捕捉出来るようにする。
    def initialize(capture_tag, &block)
      # キャプチャするタグ一覧
      @capture_tag = capture_tag

      @block = block;

      # 現在キャプチャ中のタグの情報
      # {name:name, attrs:attrs, children:[@now_tag, @now_tag...] }
      @capture_data = {}

      # 現在のタグの情報。@capture_dataの children にpushされるデータ。
      # {name:name, attrs:attrs, text:text}
      @now_tag = {}
    end

    def tag_start(name, attrs)
      debug_line "<#{name}>"
      
      if during_capture?
        require "#{@now_tag[:name]}のタグが終わる前に新しいタグ(#{name})が出現しました。" unless @now_tag.empty?
        @now_tag = {name:name}
        @now_tag[:attrs] = attrs unless attrs.empty?

        return
      end

      start_capture(name, attrs) if @capture_tag.include?(name.to_sym)
    end

    def tag_end name
      debug_line "<#{name}>"

      if @now_tag[:name] == name
        @capture_data[:children] = [] unless @capture_data.has_key? :children

        @capture_data[:children] << @now_tag
        @now_tag = {}
      end

      end_capture(name) if @capture_data[:name] == name
    end

    def text text
      return if text =~ /^\s+$/ or text.empty?

      debug_line "text : #{text}"

      if !@now_tag.empty? and during_capture?
        @now_tag[:text] = text
        @capture_data[:text] = "" unless @capture_data.has_key? :text
        return
      end

      @capture_data[:text] = text if during_capture? and !@capture_data.has_key? :text
    end

    def start_capture(name, attrs)
      require "#{@capture_data[:name]}のタグが終わる前に同名のタグが開始されました。" if @capture_data[:name] == name

      @capture_data = {name:name}
      @capture_data[:attrs] = attrs unless attrs.empty?

      debug_line "start_capture: #{name}"
    end

    def end_capture name
      @block.call(@capture_data.extend HashingTheChildren)
      @capture_data = {}
    end

    def during_capture?
      !@capture_data.empty?
    end
    
    protected

    def debug_line info
      puts info if $DEBUG
    end
  end

  module HashingTheChildren
    def children_to_hash
      self[:children].inject(Hash.new) do |new_hash,child|
        require "タグ名が重複している為、変換できませんでした。" if new_hash.has_key? child[:name].to_sym
        new_hash[child[:name].to_sym] = child[:text]
        new_hash
      end
    end
  end
end
