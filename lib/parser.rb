require "optparse"

module Rpack
   class Parser
      attr_accessor  :parser, :options, :basedir, :inflections
      attr_reader    :full_options

      def initialize(argv)
         @options = []
         @parser  = nil
         @valid   = true
         @unpack  = false
         @full_options = %w(controller model view helper mailer migration 
                            unit functional integration performance fixture route)
         begin
            OptionParser.new do |opts|
               @parser = opts

               opts.banner = "Usage: rpack <name> [options]"
               opts.on("-a","--all")         { @options = @full_options  }
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

               opts.on("-k","--unpack") do 
                  @unpack = true
               end

               opts.on("-t","--inflections FILE") do |file|
                  @inflections = File.expand_path(file.strip)
               end

               opts.on("-d","--dir DIR") do |dir|
                  @basedir = dir.strip
               end
            end.parse! argv
            @options = @full_options if @options.size<1
         rescue => e
            puts "Error: #{e}"
            puts @parser
            @valid = false
         end
      end

      def valid?
         @valid
      end

      def unpack?
         @unpack
      end
   end
end
