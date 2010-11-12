require "rubygems"
require "yaml"
require "fileutils"
require "active_support"
require "active_support/inflector"

module Rpack
   class Rpack
      attr_reader :plural, :singular, :config

      def initialize(pattern,parser,basedir=".",inflections=nil)
         # check for pattern and options
         @pattern = pattern
         @options_parser, @options = parser.parser, parser.options
         @basedir = @options_parser.basedir || basedir
         exit if @options_parser.nil?
         if @pattern.nil? || @pattern.size<1
            puts "No name given #{@options_parser}"
            exit
         end
         puts "Using basedir #{@basedir}"

         # plural and singular forms
         load_inflections(inflections)
         @singular   = @pattern.singularize
         @plural     = @singular.pluralize

         # load the configs and get the file list
         @configs    = YAML.load(File.open(File.dirname(__FILE__)+"/../config/config.yml"))
         @list       = filelist
         p @list
      end

      def load_inflections(file=nil)
         file = "./config/initializers/inflections.rb" if file.nil?
         require file if !file.nil? && File.exist?(file)
      end

      def filelist
         list = {}
         for option in @options
            puts "checking #{option.pluralize} ..."
            configs  = @configs[option]
            paths    = configs["paths"]

            list[option] = []

            for path in paths
               key      = configs["plural"] ? @plural : @singular
               suffix   = configs["suffix"]
               file     = File.absolute_path("#{@basedir}#{path}#{key}#{suffix}")

               next if !File.exist?(file)
               list[option] << file
            end
         end
         list
      end
   end
end
