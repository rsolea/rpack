require "rubygems"
require "yaml"
require "fileutils"

class Rpack
   def initialize
      @config  = YAML.load(File.open(File.dirname(__FILE__)+"/../config/config.yml"))
      @pattern = nil
      @list    = filelist
      p @config
   end

   def filelist
   end
end
