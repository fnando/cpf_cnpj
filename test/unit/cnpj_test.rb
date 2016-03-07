require "test_helper"

class CnpjTest < Minitest::Test
  test "blacklists common numbers" do
    refute CNPJ.valid?("11111111111111")
    refute CNPJ.valid?("22222222222222")
    refute CNPJ.valid?("33333333333333")
    refute CNPJ.valid?("44444444444444")
    refute CNPJ.valid?("55555555555555")
    refute CNPJ.valid?("66666666666666")
    refute CNPJ.valid?("77777777777777")
    refute CNPJ.valid?("88888888888888")
    refute CNPJ.valid?("99999999999999")
  end

  test "rejects blank strings" do
    refute CNPJ.valid?("")
  end

  test "rejects nil values" do
    refute CNPJ.valid?(nil)
  end

  test "validates formatted strings" do
    number = "54.550.752/0001-55"
    assert CNPJ.valid?(number)
  end

  test "validates unformatted strings" do
    number = "54550752000155"
    assert CNPJ.valid?(number)
  end

  test "validates messed strings" do
    number = "54550[752#0001..$55"
    assert CNPJ.valid?(number)
  end

  test "generates formatted number" do
    assert_match %r[\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z], CNPJ.generate(true)
  end

  test "generates stripped number" do
    assert_match /\A\d{14}\z/, CNPJ.generate
  end
end
