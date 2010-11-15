module Rpack
   module Utils
      def pattern_positions(contents,begin_pattern,end_pattern)
         begin_e  = Regexp.new(begin_pattern)
         end_e    = Regexp.new(end_pattern)
         begin_p  = contents.find_index {|e| e =~ begin_e}
         end_p    = contents.find_index {|e| e =~ end_e}
         [begin_p,end_p]
      end

      def extract_contents(contents,key,begin_pattern=nil,end_pattern=nil)
         regexp   = Regexp.new(":\\b#{key}\\b")
         if begin_pattern && end_pattern
            begin_p, end_p = pattern_positions(contents,begin_pattern,end_pattern)
            return [] if !begin_p || !end_p
            contents = contents[begin_p..end_p]
         end            
         contents.select { |line| line =~ regexp }
      end

      def find_config_by_path(path)
         for key,value in @config
            paths = value["paths"].map { |e| Regexp.new("^#{e}") }
            found = paths.any? {|e| e =~ path}
            return @config[key] if found
         end          
         nil
      end
   end
end
