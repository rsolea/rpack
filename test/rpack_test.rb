require "test/unit"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/parser.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rpack.rb"

class RpackTest < Test::Unit::TestCase
   def setup
      @parser  = Rpack::Parser.new(["-t","#{File.expand_path(File.dirname(__FILE__))}/inflections.rb"])
      @rpack   = Rpack::Rpack.new(%w(user),@parser,"/tmp/rpack")
   end

   def test_pluralize
      @rpack   = Rpack::Rpack.new(%w(acao),@parser,"/tmp/rpack")
      @rpack.get_pack_list(false)
      assert_equal "acoes", @rpack.plural
   end

   def test_singularize
      @rpack   = Rpack::Rpack.new(%w(acao),@parser,"/tmp/rpack")
      @rpack.get_pack_list(false)
      assert_equal "acao", @rpack.singular
   end

   def test_config
      %w(controller model view helper mailer migration unit functional integration performance fixture route).each do |mod|
         assert @rpack.config.include?(mod)
      end
   end

   def test_controller
      list = @rpack.get_pack_list(false)[0]
      list = list["controller"]
      assert list.size==1
      assert list[0] =~ /users_controller.rb$/, "no controller found"
   end

   def test_model
      list = @rpack.get_pack_list(false)[0]["model"]
      assert list.size==1
      assert list[0] =~ /user.rb$/, "no model found"
   end

   def test_view
      list = @rpack.get_pack_list(false)[0]["view"]
      assert (4..5).include?(list.size), "view listing size is not ok"
      assert list.any? { |e| e =~ /app\/views\/users\/edit.html.erb/  }, "no edit view"
      assert list.any? { |e| e =~ /app\/views\/users\/index.html.erb/ }, "no index view"
      assert list.any? { |e| e =~ /app\/views\/users\/new.html.erb/   }, "no new view"
      assert list.any? { |e| e =~ /app\/views\/users\/show.html.erb/  }, "no show view"
   end

   def test_helper
      list = @rpack.get_pack_list(false)[0]["helper"]
      assert list.size==1
      assert list[0] =~ /users_helper.rb$/, "no helper found"
   end

   def test_migration
      list = @rpack.get_pack_list(false)[0]["migration"]
      assert list.any? {|e| e =~ /create_users.rb$/}, "no migration found"
   end

   def test_unit
      list = @rpack.get_pack_list(false)[0]["unit"]
      assert list.size==2, "only #{list.size} files found on unit test"
      assert list[0] =~ /user_test.rb$/, "no unit test found"
      assert list[1] =~ /users_helper_test.rb$/, "no unit test helper found"
   end

   def test_functional
      list = @rpack.get_pack_list(false)[0]["functional"]
      assert list.size==1
      assert list[0] =~ /users_controller_test.rb$/, "no functional test found"
   end

   def test_fixture
      list = @rpack.get_pack_list(false)[0]["fixture"]
      assert list.size==1
      assert list[0] =~ /users.yml$/, "no fixture found"
   end

   def test_route
      list, extracted = @rpack.get_pack_list(false)
      list        = list["route"] 
      extracted   = extracted[list[0]]
      assert list.size==1
      assert list[0] =~ /routes.rb/, "no routes found"
      assert extracted.first =~ /resources :users/
   end

   def test_same_content
      list, extracted   = @rpack.get_pack_list(false)
      controller        = list["controller"].first
      extracted         = extracted[controller]
      content           = File.readlines(controller)
      assert_equal extracted.to_s, content.to_s
   end
end
