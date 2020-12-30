require 'kdl/main/node'
require 'kdl/main/node_builder'
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
          content = build_node(name.strip)

          nodes[name.strip] = content
        else
          @buffer.skip(/\s/)
        end
      end

      def build_node(name)
        string = @buffer.scan_until(/\n|\Z/)
        if string.include?("{")
          @buffer.unscan
          string = @buffer.scan_until(/\}/)
        end

        node = NodeBuilder.new(name, string).node

        node.to_h[:arguments]
      end
    end
  end
end
