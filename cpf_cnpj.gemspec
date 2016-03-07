# -*- encoding: utf-8 -*-
require File.expand_path("../lib/cpf_cnpj/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nando Vieira"]
  gem.email         = ["fnando.vieira@gmail.com"]
  gem.description   = "Validate, generate and format CPF/CNPJ numbers. Include command-line tools."
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cpf_cnpj"
  gem.require_paths = ["lib"]
  gem.version       = CPF::VERSION

  gem.add_development_dependency "pry-meta"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest-utils"
end
