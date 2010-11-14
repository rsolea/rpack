require "test/unit"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/parser.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rpack.rb"

class RpackTest < Test::Unit::TestCase
   def setup
      @parser  = Rpack::Parser.new(["-t","./#{File.dirname(__FILE__)}/../test/inflections.rb"])
      @rpack   = Rpack::Rpack.new("user",@parser,"/tmp/rpack")
   end

   def test_pluralize
      @rpack   = Rpack::Rpack.new("acao",@parser,"/tmp/rpack")
      assert_equal "acoes", @rpack.plural
   end

   def test_singularize
      @rpack   = Rpack::Rpack.new("acao",@parser,"/tmp/rpack")
      assert_equal "acao", @rpack.singular
   end

   def test_config
      %w(controller model view helper mailer migration unit functional integration performance fixture route).each do |mod|
         assert @rpack.config.include?(mod)
      end
   end

   def test_controller
      list = @rpack.get_pack_list(false)["controller"]
      assert list.size==1
      assert list[0] =~ /users_controller.rb$/, "no controller found"
   end
end
