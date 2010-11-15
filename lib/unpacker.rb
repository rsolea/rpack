module Rpack   
   module Unpacker
      def unpack
         file = File.expand_path(@patterns.first)
         puts "Unpacking #{file} ..."
         if !File.exist?(file) || !File.file?(file)
            puts "File #{file} does not exist."
            return false
         end
         return true
      end
   end
end
