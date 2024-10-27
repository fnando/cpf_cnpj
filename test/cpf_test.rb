# frozen_string_literal: true

require "test_helper"

class CpfTest < Minitest::Test
  test "rejects common numbers" do
    refute CPF.valid?("11111111111")
    refute CPF.valid?("22222222222")
    refute CPF.valid?("33333333333")
    refute CPF.valid?("44444444444")
    refute CPF.valid?("55555555555")
    refute CPF.valid?("66666666666")
    refute CPF.valid?("77777777777")
    refute CPF.valid?("88888888888")
    refute CPF.valid?("99999999999")
    refute CPF.valid?("00000000000")
    refute CPF.valid?("12345678909")
  end

  test "rejects blank strings" do
    refute CPF.valid?("")
  end

  test "rejects strings" do
    refute CPF.valid?("aaa.bbb.ccc-dd")
  end

  test "rejects nil values" do
    refute CPF.valid?(nil)
  end

  test "validates formatted strings" do
    number = "295.379.955-93"

    assert CPF.valid?(number)
  end

  test "validates unformatted strings" do
    number = "29537995593"

    assert CPF.valid?(number)
  end

  test "validates messed strings" do
    number = "295$379\n955...93"

    assert CPF.valid?(number)
  end

  test "strictly validates strings" do
    refute CPF.valid?("295$379\n955...93", strict: true)
    refute CPF.valid?("295.......379.......955-----93", strict: true)
    assert CPF.valid?("295.379.955-93", strict: true)
    assert CPF.valid?("29537995593", strict: true)
  end

  test "rejects strings (strict)" do
    refute CPF.valid?("aaa.bbb.ccc-dd", strict: true)
  end

  test "returns stripped number" do
    cpf = CPF.new("295.379.955-93")

    assert_equal "29537995593", cpf.stripped
  end

  test "formats number" do
    cpf = CPF.new("29537995593")

    assert_equal "295.379.955-93", cpf.formatted
    assert_equal "295.379.955-93", CPF.format("29537995593")
  end

  test "generates formatted number" do
    assert_match(/\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/, CPF.generate(true))
  end

  test "generates stripped number" do
    assert_match(/\A\d{11}\z/, CPF.generate)
  end

  test "invalidates memoization cache" do
    cpf = CPF.new("29537995593")
    cpf.number = "52139989171"

    assert_equal "52139989171", cpf.stripped
    assert_equal "521.399.891-71", cpf.formatted
  end

  test "compare objects by their numeric value" do
    one = CPF.new("29537995593")
    other = CPF.new("29537995593")
    different = CPF.new("76556868310")

    assert_equal one, other

    refute_equal one, different
    refute_equal other, different
  end

  test "returns number without verifier" do
    cpf = CPF.new("29537995593")

    assert_equal "295379955", cpf.number_without_verifier
  end
end
