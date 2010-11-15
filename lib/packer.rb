module Rpack   
   module Packer
      def pack
         filename = "#{@patterns.sort.join}.zip"
         puts "Using basedir #{@basedir}"
         puts "Packing to #{filename} ..."

         zip = Zip::ZipOutputStream.open(filename)
         list, extracted = get_pack_list

         for key,value in list 
            for file in value.sort
               content  = extracted[file]
               entry    = file.gsub(@basedir,"").gsub(/^\//,"")
               zip.put_next_entry(entry)
               zip.write content.join
            end
         end
         zip.close
      end

      def get_pack_list(verbose=true)
         list = {}
         extracted = {}

         for pattern in @patterns
            @singular   = pattern.singularize
            @plural     = singular.pluralize
            puts "processing #{@plural} ..." if verbose

            for option in @parser.options
               config   = @config[option]
               paths    = config["paths"]
               key      = config["plural"] ? @plural : @singular
               suffix   = config["suffix"]
               dir      = config["dir"] 
               inside   = config["inside"]
               extract  = config["extract"]
               begin_p  = config["begin_pattern"]
               end_p    = config["end_pattern"]

               list[option] ||= []

               for path in paths
                  file     = File.expand_path("#{@basedir}#{path}#{inside ? '' : key}#{suffix}")
                  flist    = dir ? Dir.glob(File.expand_path("#{file}/**")) : Dir.glob(file)
                  for f in flist
                     incfile = true
                     next if !File.exist?(f)
                     contents = File.readlines(f)
                     if extract
                        contents = extract_contents(contents,key,begin_p,end_p)
                        incfile  = contents.size>0
                        if incfile && extracted[f]
                           contents = extracted[f]+contents
                        end
                     end
                     extracted[f] = contents
                     list[option] << f if incfile
                  end
               end
            end
         end
         [list,extracted]
      end

      def extract_contents(contents,key,begin_pattern=nil,end_pattern=nil)
         regexp   = Regexp.new(":\\b#{key}\\b")
         if begin_pattern && end_pattern
            begin_e  = Regexp.new(begin_pattern)
            end_e    = Regexp.new(end_pattern)
            begin_p  = contents.find_index {|e| e =~ begin_e}
            end_p    = contents.find_index {|e| e =~ end_e}
            return [] if !begin_p || !end_p
            contents = contents[begin_p..end_p]
         end            
         contents.select { |line| line =~ regexp }
      end
   end
end
