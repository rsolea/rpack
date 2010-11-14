require "rubygems"
require "yaml"
require "fileutils"
require "active_support"
require "active_support/inflector"

module Rpack
   class Rpack
      attr_reader :plural, :singular, :config, :pack_list

      def initialize(pattern,parser,basedir=".")
         # check for pattern and options
         @pattern = pattern
         @parser  = parser
         @basedir = @parser.basedir || basedir
         exit if !@parser.valid?

         if @pattern.nil? || @pattern.size<1
            puts "No name given #{@parser.parser}"
            exit
         end

         # plural and singular forms
         load_inflections(@parser.inflections)
         @singular   = @pattern.singularize
         @plural     = @singular.pluralize

         # load the configs and get the file list
         @config     = YAML.load(File.open(File.expand_path("#{File.dirname(__FILE__)}/../config/config.yml")))
         @unpack     = @parser.unpack?
      end

      def run
         unpack if  @unpack
         pack   if !@unpack
      end

      def pack
         puts "Packing ..."
         puts "Using basedir #{@basedir}"
         @pack_list = get_pack_list
      end

      def unpack
         puts "Unpacking ..."
         #
      end

      def load_inflections(file=nil)
         file = "./config/initializers/inflections.rb" if file.nil?
         require file if !file.nil? && File.exist?(file)
      end

      def get_pack_list(verbose=true)
         list = {}
         for option in @parser.options
            config   = @config[option]
            paths    = config["paths"]
            key      = config["plural"] ? @plural : @singular
            suffix   = config["suffix"]
            dir      = config["dir"] 

            puts "checking '#{key}' #{option.pluralize} ..." if verbose
            list[option] = []

            for path in paths
               file  = File.expand_path("#{@basedir}#{path}#{key}#{suffix}")
               flist = dir ? Dir.glob(File.expand_path("#{file}/**")) : [file]
               for f in flist
                  next if !File.exist?(f)
                  list[option] << f
               end
            end
         end
         list
      end
   end
end
