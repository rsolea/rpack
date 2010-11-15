require "test/unit"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/parser.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rpack.rb"

class RunpackTest < Test::Unit::TestCase
   def setup
      @parser  = Rpack::Parser.new(["-t","#{File.expand_path(File.dirname(__FILE__))}/inflections.rb","--unpack"])
      @rpack   = Rpack::Rpack.new(%w(postuser.zip),@parser,"/tmp/rpack")
   end

   def test_nofile
      @rpack   = Rpack::Rpack.new(%w(foobar.zip),@parser,"/tmp/rpack")
      assert !@rpack.run
   end
end
