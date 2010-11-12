# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
   s.name = %q{rpack}
   s.version = "0.0.1"

   s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
   s.authors = ["Eustaquio 'TaQ' Rangel"]
   s.date = %q{2010-11-12}
   s.description = %q{Rails packager}
   s.email = %q{eustaquiorangel@gmail.com}
   s.bindir = "bin"
   s.executables = ["rpack"]
   s.files = ["bin/rpack", "lib/rpack.rb", "lib/parser.rb", "config/config.yml"]
   s.has_rdoc = false
   s.homepage = %q{http://github.com/taq/rpack}
   s.require_paths = ["lib"]
   s.rubygems_version = %q{1.3.7}
   s.summary = %q{Simple Rails packager}
 
   s.add_dependency("rubyzip", [">= 0"])
   s.add_dependency("activesupport", [">= 2.3.10"])
end
