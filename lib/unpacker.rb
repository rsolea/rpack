require "fileutils"

module Rpack   
   module Unpacker
      def unpack
         file = File.expand_path(@patterns.first)
         puts "Unpacking #{file} ..."
         if !File.exist?(file) || !File.file?(file)
            puts "File #{file} does not exist."
            return false
         end
         Zip::ZipFile.open(file) do |zip|
            zip.each do |file|
               dir      = File.dirname(file.to_s)
               config   = find_config_by_path(file.to_s)
               verb     = "Extracting"
               next if !config

               extract     = config["extract"]
               update      = config["update_filename"]
               begin_p     = config["begin_pattern"]
               end_p       = config["end_pattern"]
               begin_str   = config["begin_string"]
               end_str     = config["end_string"]
               contents    = file.get_input_stream.readlines

               FileUtils.mkpath(dir) if !File.directory?(dir)

               if extract
                  if !File.exist?(file.to_s)
                     contents = "# you MUST check this\n#{begin_str}\n#{contents}#{end_str}\n"
                  else
                     newcontent     = []
                     fcontents      = File.readlines(file.to_s)
                     begin_p, end_p = pattern_positions(fcontents,begin_p,end_p)
                     if begin_p && end_p
                        start_range = fcontents[0..begin_p]
                        mid_range   = fcontents[(begin_p+1)...end_p]
                        end_range   = fcontents[end_p..-1]
                        for lcontent in contents
                           newcontent << lcontent if !fcontents.any? {|e| e.chomp.strip==lcontent.chomp.strip}
                        end
                        contents = start_range+mid_range+newcontent+end_range
                        verb     = "Merging"
                     end
                  end
               end

               newfile  = file.to_s
               newfile  = newfile.sub(/[0-9]{14}/,Time.now.strftime("%Y%m%d%H%M%s")) if update
               newfile  = "#{newfile}.rpack" if File.exist?(newfile) && !extract
               puts "#{verb}:\n#{file} to #{newfile}\n\n"
               File.open(newfile,"w") do |handle|
                  handle << contents
               end
            end
         end
         return true
      end
   end
end
