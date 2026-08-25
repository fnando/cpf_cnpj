# frozen_string_literal: true

require "test_helper"

class CNPJGeneratorTest < Minitest::Test
  test "generates valid numbers" do
    10.times { assert CNPJ.valid?(CNPJ.generate) }
  end

  test "generates valid formatted numbers" do
    10.times { assert CNPJ.valid?(CNPJ.generate(true)) }
  end

  test "generates random numbers" do
    10.times { refute_equal CNPJ.generate, CNPJ.generate }
  end

  test "generated stripped number matches expected format" do
    assert_match(/\A[A-Z\d]{14}\z/, CNPJ.generate)
  end

  test "generated formatted number matches expected format" do
    assert_match CNPJ::REGEX, CNPJ.generate(true)
  end

  test "generator produces alphanumeric CNPJs" do
    # With a pool of 36 chars (0-9, A-Z) over 12 positions, the probability
    # of all-numeric in 100 tries is negligible (~10^-9)
    generated = Array.new(100) { CNPJ.generate }
    assert generated.any? { |cnpj| cnpj.match?(/[A-Z]/) },
           "Expected at least one alphanumeric CNPJ to be generated in 100 tries"
  end
end
