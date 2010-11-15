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
               puts "Unzipping #{file}"
               dir      = File.dirname(file.to_s)
               config   = find_config_by_path(file.to_s)
               next if !config

               extract     = config["extract"]
               update      = config["update_filename"]
               begin_str   = config["begin_string"]
               end_str     = config["end_string"]
               contents    = file.get_input_stream.read

               FileUtils.mkpath(dir) if !File.directory?(dir)

               if extract
                  puts "extracted ..."
                  if !File.exist?(file.to_s)
                     File.open(file.to_s,"w") do |handle|
                        handle << "# you MUST check this\n"
                        handle << "#{begin_str}\n"
                        handle << contents
                        handle << "#{end_str}\n"
                     end
                  else

                  end
               else
                  newfile  = file.to_s
                  newfile  = newfile.sub(/[0-9]{14}/,Time.now.strftime("%Y%m%d%H%M%s")) if update
                  newfile  = "#{newfile}.rpack" if File.exist?(newfile)
                  File.open(newfile,"w") do |handle|
                     handle << contents
                  end
               end
               puts "Extracting #{file} to #{newfile} ..."
            end
         end
         return true
      end
   end
end
