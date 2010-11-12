require "rubygems"
require "yaml"
require "fileutils"
require "optparse"

class Rpack
   def initialize
      parse_options

      @config  = YAML.load(File.open(File.dirname(__FILE__)+"/../config/config.yml"))
      @pattern = ARGV[0]
      @list    = filelist
      p @pattern
      p @config
      p @options
   end

   def parse_options 
      @options = []
      OptionParser.new do |opts|
         opts.banner = "Usage: rpack <name> [options]"
         opts.on("-a","--all")         { @options = %w(controller model view helper mailer migration 
                                                       unit functional integration performance fixture 
                                                       route)}

         opts.on("-c","--controller")  { @options << "controller" }
         opts.on("-m","--model")       { @options << "model"      }
         opts.on("-v","--view")        { @options << "view"       }
         opts.on("-h","--helper")      { @options << "helper"     }      
         opts.on("-l","--mailer")      { @options << "mailer"     }
         opts.on("-g","--migration")   { @options << "migration"  }
         opts.on("-u","--unit")        { @options << "unit"       }
         opts.on("-f","--functional")  { @options << "functional" }
         opts.on("-i","--integration") { @options << "integration"}
         opts.on("-p","--performance") { @options << "performance"}
         opts.on("-x","--fixture")     { @options << "fixture"    }
         opts.on("-r","--route")       { @options << "route"      }
      end.parse!
   end

   def filelist
   end
end
