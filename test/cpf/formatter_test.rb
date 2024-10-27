# frozen_string_literal: true

require "test_helper"

class CPFFormatterTest < Minitest::Test
  test "formats strings without separators" do
    number = "12345678901"

    assert_equal "123.456.789-01", CPF::Formatter.format(number)
  end

  test "removes any non-numeric characters" do
    number = "\n12$345[678/901-"

    assert_equal "12345678901", CPF::Formatter.strip(number)
  end
end
