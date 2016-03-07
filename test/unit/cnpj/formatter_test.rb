require "test_helper"

class CNPJFormatterTest < Minitest::Test
  test "formats strings without separators" do
    number = "12345678901234"
    assert_equal "12.345.678/9012-34", CNPJ::Formatter.format(number)
  end

  test "removes any non-numeric characters" do
    number = "\n12$345[678/9012-34"
    assert_equal "12345678901234", CNPJ::Formatter.strip(number)
  end
end
