require "rubygems"
require "yaml"
require "fileutils"
require "optparse"
require "active_support"
require "active_support/inflector"

class Rpack
   def initialize
      @pattern = ARGV[0]
      @options_parser, @options = parse_options
      if @pattern.nil? || @pattern.size<1
         puts "No name given"
         puts @options_parser
         exit
      end
      load_inflections
      @singular   = @pattern.singularize
      @plural     = @singular.pluralize
      @config     = YAML.load(File.open(File.dirname(__FILE__)+"/../config/config.yml"))
      @list       = filelist
   end

   def parse_options 
      options = []
      parser  = nil
      full_options = %w(controller model view helper mailer migration 
                        unit functional integration performance fixture 
                        route)
      begin
         OptionParser.new do |opts|
            parser = opts
            opts.banner = "Usage: rpack <name> [options]"
            opts.on("-a","--all")         { options = full_options  }
            opts.on("-c","--controller")  { options << "controller" }
            opts.on("-m","--model")       { options << "model"      }
            opts.on("-v","--view")        { options << "view"       }
            opts.on("-h","--helper")      { options << "helper"     }      
            opts.on("-l","--mailer")      { options << "mailer"     }
            opts.on("-g","--migration")   { options << "migration"  }
            opts.on("-u","--unit")        { options << "unit"       }
            opts.on("-f","--functional")  { options << "functional" }
            opts.on("-i","--integration") { options << "integration"}
            opts.on("-p","--performance") { options << "performance"}
            opts.on("-x","--fixture")     { options << "fixture"    }
            opts.on("-r","--route")       { options << "route"      }
         end.parse!
         options = full_options if options.size<1
      rescue => e
         puts "Error: #{e}"
         puts parser
         exit
      end
      [parser,options]
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
