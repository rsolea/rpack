require "test/unit"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/parser.rb"

class ParserTest < Test::Unit::TestCase
   def test_error
      @parser = Rpack::Parser.new(%w(-y))
      assert !@parser.valid?
   end

   def test_empty
      @parser = Rpack::Parser.new([])
      assert_equal 12, @parser.options.size
   end

   def test_all
      @parser = Rpack::Parser.new(%w(-a))
      assert_equal 12, @parser.options.size, @parser.options.join(",")
      
      @parser = Rpack::Parser.new(%w(--all))
      assert_equal 12, @parser.options.size, @parser.options.join(",")
   end

   def test_controller
      @parser = Rpack::Parser.new(%w(-c))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "controller", @parser.options.first

      @parser = Rpack::Parser.new(%w(--controller))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "controller", @parser.options.first
   end

   def test_model
      @parser = Rpack::Parser.new(%w(-m))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "model", @parser.options.first

      @parser = Rpack::Parser.new(%w(--model))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "model", @parser.options.first
   end

   def test_view
      @parser = Rpack::Parser.new(%w(-v))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "view", @parser.options.first

      @parser = Rpack::Parser.new(%w(--view))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "view", @parser.options.first
   end

   def test_helper
      @parser = Rpack::Parser.new(%w(-h))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "helper", @parser.options.first

      @parser = Rpack::Parser.new(%w(--helper))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "helper", @parser.options.first
   end

   def test_mailer
      @parser = Rpack::Parser.new(%w(-l))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "mailer", @parser.options.first

      @parser = Rpack::Parser.new(%w(--mailer))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "mailer", @parser.options.first
   end

   def test_migration
      @parser = Rpack::Parser.new(%w(-g))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "migration", @parser.options.first

      @parser = Rpack::Parser.new(%w(--migration))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "migration", @parser.options.first
   end

   def test_unit
      @parser = Rpack::Parser.new(%w(-u))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "unit", @parser.options.first

      @parser = Rpack::Parser.new(%w(--unit))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "unit", @parser.options.first
   end

   def test_functional
      @parser = Rpack::Parser.new(%w(-f))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "functional", @parser.options.first

      @parser = Rpack::Parser.new(%w(--functional))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "functional", @parser.options.first
   end

   def test_integration
      @parser = Rpack::Parser.new(%w(-i))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "integration", @parser.options.first

      @parser = Rpack::Parser.new(%w(--integration))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "integration", @parser.options.first
   end

   def test_performance
      @parser = Rpack::Parser.new(%w(-o))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "performance", @parser.options.first

      @parser = Rpack::Parser.new(%w(--performance))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "performance", @parser.options.first
   end

   def test_fixture
      @parser = Rpack::Parser.new(%w(-x))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "fixture", @parser.options.first

      @parser = Rpack::Parser.new(%w(--fixture))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "fixture", @parser.options.first
   end

   def test_route
      @parser = Rpack::Parser.new(%w(-r))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "route", @parser.options.first

      @parser = Rpack::Parser.new(%w(--route))
      assert_equal 1, @parser.options.size, @parser.options.join(",")
      assert_equal "route", @parser.options.first
   end

   def test_mixed
      @parser = Rpack::Parser.new(%w(-c -m -v))
      assert_equal 3, @parser.options.size, @parser.options.join(",")
      assert @parser.options.include?("controller")
      assert @parser.options.include?("model")
      assert @parser.options.include?("view")
   end

   def test_basedir
      basedir = "/tmp/test"
      @parser = Rpack::Parser.new(["-d",basedir])
      assert_equal basedir, @parser.basedir

      @parser = Rpack::Parser.new(["--dir",basedir])
      assert_equal basedir, @parser.basedir
   end

   def test_package
      file = "/tmp/foo.zip"
      @parser = Rpack::Parser.new(["-p",file])
      assert_equal file, @parser.package

      @parser = Rpack::Parser.new(["--package",file])
      assert_equal file, @parser.package
   end
end
