require 'kdl/main/node'
require 'byebug'
require 'strscan'

module Kdl
  module Main
    class Document
      attr_reader :nodes

      def initialize(file, name: "default")
        @buffer = StringScanner.new(file)
        @nodes = {}
        @name = name

        create_nodes
      end

      def create_nodes
        until @buffer.eos?
          find_node
        end
      end

      def find_node
        @buffer.skip(/\{/) if @buffer.peek(1) == "{"
        @buffer.skip(/\}/) if @buffer.peek(1) == "}"

        start = @buffer.scan_until(/\S/)
        name = @buffer.scan_until(/ /)
        name = "#{start}#{name}"

        if name.strip.length > 0
          content = find_content(name.strip)

          nodes[name.strip] = content
        else
          @buffer.skip(/\s/)
        end
      end

      def find_content(name)
        string = @buffer.scan_until(/\n|\Z/)
        if string.include?("{")
          @buffer.unscan
          string = @buffer.scan_until(/\}/)
        end

        @scanner = StringScanner.new(string)

        content = []
        while @scanner.peek(1) != "\n" && !@scanner.eos?
          if @scanner.peek(1) == " "
            @scanner.skip(/\s+/)
          elsif @scanner.peek(1) == "}"
            @scanner.skip(/\}/)
          else
            value = content_loop(name)
            content.concat(value) 
          end
        end

        content.length > 1 ? content : content[0]
      end

      def content_loop(name)
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
