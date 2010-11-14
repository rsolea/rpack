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

   def test_model
      list = @rpack.get_pack_list(false)["model"]
      assert list.size==1
      assert list[0] =~ /user.rb$/, "no model found"
   end

   def test_view
      list = @rpack.get_pack_list(false)["view"]
      assert (4..5).include?(list.size), "view listing size is not ok"
      assert list.any? { |e| e =~ /app\/views\/users\/edit.html.erb/  }, "no edit view"
      assert list.any? { |e| e =~ /app\/views\/users\/index.html.erb/ }, "no index view"
      assert list.any? { |e| e =~ /app\/views\/users\/new.html.erb/   }, "no new view"
      assert list.any? { |e| e =~ /app\/views\/users\/show.html.erb/  }, "no show view"
   end

   def test_helper
      list = @rpack.get_pack_list(false)["helper"]
      assert list.size==1
      assert list[0] =~ /users_helper.rb$/, "no helper found"
   end

   def test_migration
      list = @rpack.get_pack_list(false)["migration"]
      assert list.size==1
      assert list[0] =~ /create_users.rb$/, "no migration found"
   end

   def test_unit
      list = @rpack.get_pack_list(false)["unit"]
      assert list.size==2, "only #{list.size} files found on unit test"
      assert list[0] =~ /user_test.rb$/, "no unit test found"
      assert list[1] =~ /users_helper_test.rb$/, "no unit test helper found"
   end
end
