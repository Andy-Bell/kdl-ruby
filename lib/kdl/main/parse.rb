require 'strscan'
require 'kdl/main/document'
require 'kdl/main/node'
require 'byebug'

module Kdl
  module Main
    class Parse
      def self.to_h(file)
        if file.length > 0
          document = Document.new(file)

          document.nodes
        end
      end
    end
  end
end
