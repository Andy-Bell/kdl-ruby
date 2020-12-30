require 'kdl/main/node'
require 'byebug'
require 'strscan'

module Kdl
  module Main
    class NodeBuilder
      attr_reader :node, :name

      def initialize(raw_name, raw_content)
        @name = raw_name

        @arguments = []
        @properties = []

        @scanner = StringScanner.new(raw_content)

        find_content
        
        @node = Node.new(@name, @arguments, @properties)
      end

      def find_content
        content = []
        while @scanner.peek(1) != "\n" && !@scanner.eos?
          if @scanner.peek(1) == " "
            @scanner.skip(/\s+/)
          else
            value = content_loop
            content.concat(value) 
          end
        end

        @arguments = content
      end

      def content_loop
        if @scanner.peek(1) == '"'
          strings = @scanner.scan_until(/(".+")/)
          strings.split('" "').map{|value| value.gsub('"', '').strip}
        elsif @scanner.peek(1) == '{'
          nested = @scanner.scan_until(/\}/)
          content = Document.new(nested, name: name).nodes

          [content]
        else
          []
        end
      end
    end
  end
end
