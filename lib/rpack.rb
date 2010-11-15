require "rubygems"
require "yaml"
require "fileutils"
require "zip/zip"
require "active_support"
require "active_support/inflector"
require "#{File.expand_path(File.dirname(__FILE__))}/packer.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/unpacker.rb"

module Rpack
   class Rpack
      include Packer
      include Unpacker
      attr_reader :plural, :singular, :config, :pack_list

      def initialize(patterns,parser,basedir=".")
         # check for pattern and options
         @patterns   = patterns
         @parser     = parser
         @basedir    = @parser.basedir || basedir
         exit if !@parser.valid?

         if @patterns.nil? || @patterns.size<1
            puts "No name given #{@parser.parser}"
            exit
         end

         # plural and singular forms
         load_inflections(@parser.inflections)

         # load the configs and get the file list
         @config     = YAML.load(File.open(File.expand_path("#{File.dirname(__FILE__)}/../config/config.yml")))
         @unpack     = @parser.unpack?
      end

      def run
         return unpack if  @unpack
         return pack   if !@unpack
      end

      def load_inflections(file=nil)
         file = "./config/initializers/inflections.rb" if file.nil?
         require file if !file.nil? && File.exist?(file)
      end

      def find_config_by_path(path)
         for key,value in @config
            paths = value["paths"].map { |e| Regexp.new("^#{e}") }
            found = paths.any? {|e| e =~ path}
            return @config[key] if found
         end          
         nil
      end
   end
end
