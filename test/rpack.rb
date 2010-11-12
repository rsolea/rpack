require "test/unit"
require "./#{File.dirname(__FILE__)}/../lib/parser.rb"
require "./#{File.dirname(__FILE__)}/../lib/rpack.rb"

class RpackTest < Test::Unit::TestCase
   def setup
      @parser  = Rpack::Parser.new([])
      @rpack   = Rpack::Rpack.new("acao",@parser,".",Dir.pwd+"/test/inflections.rb")
   end

   def test_pluralize
      assert_equal "acoes", @rpack.plural
   end

   def test_singularize
      assert_equal "acao", @rpack.singular
   end

   def test_config
      %w(controller model view helper mailer migration unit functional integration performance fixture route).each do |mod|
         assert @rpack.config.include?(mod)
      end
   end
end
