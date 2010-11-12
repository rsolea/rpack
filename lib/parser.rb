require "optparse"

module Rpack
   class Parser
      attr_accessor :parser, :options
      def initialize(argv)
         @options = []
         @parser  = nil
         full_options = %w(controller model view helper mailer migration 
                        unit functional integration performance fixture 
                        route)
         begin
            OptionParser.new do |opts|
               @parser = opts
               opts.banner = "Usage: rpack <name> [options]"
               opts.on("-a","--all")         { @options = full_options  }
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
            end.parse! argv
            @options = full_options if @options.size<1
         rescue => e
            puts "Error: #{e}"
            puts @parser
            exit
         end
         [@parser,@options]
      end
   end
end
