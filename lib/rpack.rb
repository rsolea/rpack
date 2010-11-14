require "rubygems"
require "yaml"
require "fileutils"
require "zip/zip"
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
         filename = "#{@plural}.zip"
         puts "Packing #{@plural} to #{filename} ..."
         puts "Using basedir #{@basedir}"
         list, extracted = get_pack_list

         zip = Zip::ZipOutputStream.open(filename)
         
         for key,value in list 
            for file in value.sort
               puts "processing #{file}"
               content  = extracted[file]
               entry    = file.gsub(@basedir,"").gsub(/^\//,"")
               zip.put_next_entry(entry)
               zip.write content.join
            end
         end
         zip.close
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
         extracted = {}
         for option in @parser.options
            config   = @config[option]
            paths    = config["paths"]
            key      = config["plural"] ? @plural : @singular
            suffix   = config["suffix"]
            dir      = config["dir"] 
            extract  = config["extract"]

            puts "checking '#{key}' #{option.pluralize} ..." if verbose
            list[option] = []

            for path in paths
               file     = File.expand_path("#{@basedir}#{path}#{extract ? '' : key}#{suffix}")
               flist    = dir ? Dir.glob(File.expand_path("#{file}/**")) : Dir.glob(file)
               for f in flist
                  incfile = true
                  next if !File.exist?(f)
                  contents = File.readlines(f)
                  if extract
                     contents = extract_contents(contents,key)
                     incfile  = contents.size>0
                  end
                  extracted[f] = contents
                  list[option] << f if incfile
               end
            end
         end
         [list,extracted]
      end

      def extract_contents(contents,key)
         regexp = Regexp.new(":\\b#{key}\\b")
         contents.select { |line| line =~ regexp }
      end
   end
end
