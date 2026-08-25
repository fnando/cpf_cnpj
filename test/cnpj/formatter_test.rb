# frozen_string_literal: true

require "test_helper"

class CNPJFormatterTest < Minitest::Test
  test "formats numeric strings without separators" do
    number = "12345678901234"

    assert_equal "12.345.678/9012-34", CNPJ::Formatter.format(number)
  end

  test "formats alphanumeric strings without separators" do
    number = "12ABC34501DE35"

    assert_equal "12.ABC.345/01DE-35", CNPJ::Formatter.format(number)
  end

  test "formats lowercase alphanumeric strings" do
    number = "12abc34501de35"

    assert_equal "12.ABC.345/01DE-35", CNPJ::Formatter.format(number)
  end

  test "removes any non-alphanumeric characters" do
    number = "\n12$345[678/9012-34"

    assert_equal "12345678901234", CNPJ::Formatter.strip(number)
  end

  test "removes non-alphanumeric characters from alphanumeric input" do
    number = "\n12$ABC[345/01DE-35"

    assert_equal "12ABC34501DE35", CNPJ::Formatter.strip(number)
  end

  test "upcases and strips lowercase alphanumeric input" do
    number = "12.abc.345/01de-35"

    assert_equal "12ABC34501DE35", CNPJ::Formatter.strip(number)
  end

  test "strips separators only in strict mode" do
    number = "12.ABC.345/01DE-35"

    assert_equal "12ABC34501DE35", CNPJ::Formatter.strip(number, true)
  end
end
