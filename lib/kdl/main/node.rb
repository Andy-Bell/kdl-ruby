module Kdl
  module Main
    class Node
      attr_reader :name

      def initialize(raw_name, raw_arguments, raw_properties)
        @name = raw_name

        @arguments = raw_arguments
        @properties = raw_properties
      end

      def to_h
        output = {}

        output[:properties] = properties if properties
        output[:arguments] = arguments if arguments
        output
      end

      def arguments
        case @arguments.length
        when 0
          nil
        when 1
          @arguments[0]
        else
          @arguments
        end
      end

      def properties
        case @properties.length
        when 0
          nil
        when 1
          @properties[0]
        else
          @properties
        end
      end
    end
  end
end
