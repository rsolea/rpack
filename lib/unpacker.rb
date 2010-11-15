require "fileutils"

module Rpack   
   module Unpacker
      def unpack
         file  = File.expand_path(@patterns.first)
         count = 0
         puts "Unpacking #{file} to #{@basedir} ..."
         if !File.exist?(file) || !File.file?(file)
            puts "File #{file} does not exist."
            return false
         end
         Zip::ZipFile.open(file) do |zip|
            zip.each do |zfile|
               file     = File.expand_path("#{@basedir}/#{zfile.to_s}")
               dir      = File.dirname(file.to_s)
               config   = find_config_by_path(zfile.to_s)
               verb     = "Extracting"
               next if !config

               extract     = config["extract"]
               update      = config["update_filename"]
               begin_p     = config["begin_pattern"]
               end_p       = config["end_pattern"]
               begin_str   = config["begin_string"]
               end_str     = config["end_string"]
               contents    = zfile.get_input_stream.readlines

               FileUtils.mkpath(dir) if !File.directory?(dir)

               if extract
                  if !File.exist?(file)
                     contents = ["# you MUST check this\n","#{begin_str}\n",contents,"#{end_str}\n"]
                  else
                     newcontent     = []
                     fcontents      = File.readlines(file)
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

               if update
                  mtime = Time.now.strftime("%Y%m%d%H%M%S").to_i+count
                  file  = file.sub(/[0-9]{14}/,mtime.to_s)
                  count += 1
               end
               file  = "#{file}.rpack" if File.exist?(file) && !extract
               puts "#{verb}:\n#{zfile.to_s} to\n#{file}\n\n"
               File.open(file,"w") do |handle|
                  handle << contents.join
               end
            end
         end
         return true
      end
   end
end
