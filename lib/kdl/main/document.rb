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
        name = @buffer.scan_until(/ /)
        content = @buffer.scan_until(/\n/)

        nodes[name.strip] = content.strip.gsub('"', '')
      end
    end
  end
end
