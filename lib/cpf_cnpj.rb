# frozen_string_literal: true

require "English"
require "optparse"
require "cpf_cnpj/cli"
require "cpf_cnpj/version"
require "cpf"
require "cnpj"

module CPF_CNPJ
  def self.which(input)
    if CPF.valid?(input)
      CPF.new(input)
    elsif CNPJ.valid?(input)
      CNPJ.new(input)
    end
  end
end
