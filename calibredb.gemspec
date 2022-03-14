# frozen_string_literal: true

require_relative "lib/calibredb/version"

Gem::Specification.new do |spec|
  spec.name = "calibredb"
  spec.version = Calibredb::VERSION
  spec.authors = ["ohzqq"]
  spec.email = ["ozhqq@riseup.net"]

  spec.summary = "A library using Sequel to interact with a Calibre database."
  spec.description = "The library comes with audiobook support built-in."
  spec.homepage = "https://github.com/ohzqq/calibredb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = "https://github.com/ohzqq/calibredb"
  spec.metadata["source_code_uri"] = "https://github.com/ohzqq/calibredb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'sequel', '~> 5.52.0'
  spec.add_dependency 'sqlite3', '~> 1.4.2'
  spec.add_dependency 'yaml', '~> 0.2.0'
  spec.add_dependency 'json', '~> 2.6.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
