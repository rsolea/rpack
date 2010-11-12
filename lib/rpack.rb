require "rubygems"
require "yaml"
require "fileutils"
require "active_support"
require "active_support/inflector"

module Rpack
   class Rpack
      def initialize(pattern,parser)
         # check for pattern and options
         @pattern = pattern
         @options_parser, @options = parser.parser, parser.options
         if @pattern.nil? || @pattern.size<1
            puts "No name given"
            puts @options_parser
            exit
         end

         # plural and singular forms
         load_inflections
         @singular   = @pattern.singularize
         @plural     = @singular.pluralize

         # load the configs and get the file list
         @config     = YAML.load(File.open(File.dirname(__FILE__)+"/../config/config.yml"))
         @list       = filelist
      end

      def load_inflections
         file = "./config/initializers/inflections.rb"
         require file if File.exist?(file)
      end

      def filelist
         puts "packing #{@plural} ..."
         for option in @options
         end
      end
   end
end
