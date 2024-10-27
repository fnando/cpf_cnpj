# frozen_string_literal: true

class CPF
  require "cpf_cnpj"
  require "cpf/formatter"
  require "cpf/verifier_digit"

  attr_reader :number, :strict

  REGEX = /\A\d{3}\.\d{3}\.\d{3}-\d{2}\Z/.freeze
  VALIDATION_SIZE_REGEX = /^\d{11}$/.freeze
  NUMBER_SIZE = 9

  DENYLIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
  ].freeze

  def self.format(number)
    new(number).formatted
  end

  def self.valid?(number, strict: false)
    new(number, strict).valid?
  end

  def self.generate(formatted = false)
    numbers = Array(0..9)
    digits = Array.new(NUMBER_SIZE) { numbers.sample }
    digits << VerifierDigit.generate(digits)
    digits << VerifierDigit.generate(digits)

    cpf = new(digits.join)
    formatted ? cpf.formatted : cpf.stripped
  end

  def initialize(number, strict = false)
    @number = number.to_s
    @strict = strict
  end

  def number=(number)
    @stripped = nil
    @formatted = nil
    @numbers = nil
    @number = number
  end

  def stripped
    @stripped ||= Formatter.strip(number, strict)
  end

  def formatted
    @formatted ||= Formatter.format(number)
  end

  def valid?
    if strict && !(number.match?(REGEX) || number.match?(VALIDATION_SIZE_REGEX))
      return false
    end

    return false unless stripped.match?(VALIDATION_SIZE_REGEX)
    return false if DENYLIST.include?(stripped)

    digits = numbers[0...NUMBER_SIZE]
    digits << VerifierDigit.generate(digits)
    digits << VerifierDigit.generate(digits)

    digits[-2, 2] == numbers[-2, 2]
  end

  def number_without_verifier
    numbers[0...NUMBER_SIZE].join
  end

  def ==(other)
    super || (other.instance_of?(self.class) && other.stripped == stripped)
  end
  alias eql? ==

  private def numbers
    @numbers ||= stripped.each_char.to_a.map(&:to_i)
  end
end
