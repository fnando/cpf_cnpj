require "test_helper"

class CPFGeneratorTest < Minitest::Test
  test "generates valid numbers" do
    100.times { assert CNPJ.valid?(CNPJ::Generator.generate) }
  end

  test "generates random numbers" do
    100.times { refute_equal CNPJ::Generator.generate, CNPJ::Generator.generate }
  end
end
