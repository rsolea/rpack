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
         load_inflections(inflections || @options_parser.inflections)
         @singular   = @pattern.singularize
         @plural     = @singular.pluralize

         # load the configs and get the file list
         @config     = YAML.load(File.open(File.absolute_path("#{File.dirname(__FILE__)}/../config/config.yml")))
         @list       = filelist
      end

      def load_inflections(file=nil)
         file = "./config/initializers/inflections.rb" if file.nil?
         require file if !file.nil? && File.exist?(file)
      end

      def filelist
         list = {}
         for option in @options
            config   = @config[option]
            paths    = config["paths"]
            key      = config["plural"] ? @plural : @singular
            suffix   = config["suffix"]
            puts "checking '#{key}' #{option.pluralize} ..."

            list[option] = []

            for path in paths
               file     = File.absolute_path("#{@basedir}#{path}#{key}#{suffix}")

               next if !File.exist?(file)
               list[option] << file
            end
         end
         list
      end
   end
end
