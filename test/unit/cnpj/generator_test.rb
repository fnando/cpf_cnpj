require "test_helper"

class CNPJGeneratorTest < Minitest::Test
  test "generates valid numbers" do
    10.times { assert CNPJ.valid?(CNPJ.generate) }
  end

  test "generates random numbers" do
    10.times { refute_equal CNPJ.generate, CNPJ.generate }
  end
end
