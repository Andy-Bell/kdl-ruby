require 'kdl/main/node'
require 'byebug'
require 'strscan'

module Kdl
  module Main
    class Document
      attr_reader :nodes

      def initialize(file)
        @buffer = StringScanner.new(file)
        @nodes = {}

        create_nodes
      end

      def create_nodes
        until @buffer.eos?
          find_node
        end
      end

      def find_node
        start = @buffer.scan_until(/\S/)
        name = @buffer.scan_until(/ /)
        name = "#{start}#{name}"

        if @buffer.peek(1) == '"'
          raw = @buffer.scan_until(/\n|\Z/)
          content = raw.strip.gsub('"', '')

          nodes[name.strip] = content
        elsif @buffer.peek(1) == '{'
          nested = @buffer.scan_until(/\}/)
          content = Document.new(nested).nodes

          nodes[name.strip] = content
        else
          @buffer.skip(/\s+/)
        end
      end
    end
  end
end
