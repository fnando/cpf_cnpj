# frozen_string_literal: true

require "test_helper"

class CnpjTest < Minitest::Test
  test "rejects common numbers" do
    refute CNPJ.valid?("00000000000000")
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

  test "validates formatted strings with letters" do
    number = "12.ABC.345/01DE-35"

    assert CNPJ.valid?(number)
  end

  test "validates formatted strings with letters (lowercase)" do
    number = "12.abc.345/01de-35"

    assert CNPJ.valid?(number)
  end

  test "formats number" do
    cnpj = CNPJ.new("54550752000155")

    assert_equal "54.550.752/0001-55", cnpj.formatted
    assert_equal "54.550.752/0001-55", CNPJ.format("54550752000155")
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
    assert_match(
      %r[\A[A-Z\d]{2}\.[A-Z\d]{3}\.[A-Z\d]{3}/[A-Z\d]{4}-[A-Z\d]{2}\z],
      CNPJ.generate(true)
    )
  end

  test "generates stripped number" do
    assert_match(/\A[A-Z\d]{14}\z/, CNPJ.generate)
  end

  test "rejects invalid strings" do
    refute CNPJ.valid?("aa.bb.ccc/dddd-ee")
  end

  test "strictly validates strings" do
    refute CNPJ.valid?("aa.bb.ccc/dddd-ee", strict: true)
    refute CNPJ.valid?("54....550....752///0001---55", strict: true)
    assert CNPJ.valid?("54.550.752/0001-55", strict: true)
    assert CNPJ.valid?("54550752000155", strict: true)
    assert CNPJ.valid?("12.ABC.345/01DE-35", strict: true)
    assert CNPJ.valid?("12ABC34501DE35", strict: true)
  end

  test "compare objects by their numeric value" do
    one = CNPJ.new("54550752000155")
    other = CNPJ.new("54550752000155")
    different = CNPJ.new("32228235377")

    assert_equal one, other

    refute_equal one, different
    refute_equal other, different
  end

  test "returns number without verifier" do
    assert_equal "545507520001",
                 CNPJ.new("54550752000155").number_without_verifier
    assert_equal "12ABC34501DE",
                 CNPJ.new("12.ABC.345/01DE-35").number_without_verifier
  end
end
