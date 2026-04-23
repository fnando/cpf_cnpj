# frozen_string_literal: true

require "test_helper"

class CpfCnpjTest < Minitest::Test
  test "detects valid cpf" do
    cpf = CPF.generate(formatted: true)

    assert_instance_of CPF, CpfCnpj.which(cpf.to_s)
    assert_instance_of CPF, CPF_CNPJ.which(cpf.to_s)
  end

  test "detects valid cnpj" do
    cnpj = CNPJ.generate(formatted: true)

    assert_instance_of CNPJ, CpfCnpj.which(cnpj.to_s)
    assert_instance_of CNPJ, CPF_CNPJ.which(cnpj.to_s)
  end

  test "detects invalid cpf/cnpj" do
    assert_nil CpfCnpj.which("invalid")
    assert_nil CPF_CNPJ.which("invalid")
  end
end
