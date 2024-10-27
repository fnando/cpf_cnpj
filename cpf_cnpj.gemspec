# frozen_string_literal: true

require "./lib/cpf_cnpj/version"

Gem::Specification.new do |spec|
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = "Validate, generate and format CPF/CNPJ numbers. " \
                       "Include command-line tools."
  spec.summary       = spec.description
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
  spec.homepage = "https://github.com/fnando/cpf_cnpj"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}).map {|f| File.basename(f) }
  spec.name          = "cpf_cnpj"
  spec.require_paths = ["lib"]
  spec.version       = CPF::VERSION

  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
end
