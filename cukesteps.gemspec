# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cukesteps}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Doel"]
  s.date = %q{2009-06-01}
  s.description = %q{General purpose step definitions for the ruby BDD framework Cucumber}
  s.email = %q{mike@mikedoel.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "cukesteps.gemspec",
     "lib/common_steps.rb",
     "lib/cuke_association_helpers.rb",
     "lib/cukesteps.rb",
     "test/cukesteps_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/mdoel/cukesteps/tree/master}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{General purpose step definitions for Cucumber}
  s.test_files = [
    "test/cukesteps_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
