require "test/unit"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/parser.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rpack.rb"

class RpackTest < Test::Unit::TestCase
   def setup
      @parser  = Rpack::Parser.new(["-t","./#{File.dirname(__FILE__)}/../test/inflections.rb"])
      @rpack   = Rpack::Rpack.new("acao",@parser,".")
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
