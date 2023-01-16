# frozen_string_literal: true

class CNPJ
  require "cpf_cnpj"
  require "cnpj/formatter"
  require "cnpj/verifier_digit"

  attr_reader :number, :strict

  REGEX = %r[\A\d{2}\.\d{3}.\d{3}/\d{4}-\d{2}\Z].freeze
  VALIDATION_SIZE_REGEX = /^\d{14}$/.freeze
  NUMBER_SIZE = 12

  DENYLIST = %w[
    00000000000000
    11111111111111
    22222222222222
    33333333333333
    44444444444444
    55555555555555
    66666666666666
    77777777777777
    88888888888888
    99999999999999
  ].freeze

  def self.valid?(number, strict: false)
    new(number, strict).valid?
  end

  def self.generate(formatted = false)
    number = CpfCnpj::Generator.generate(NUMBER_SIZE, VerifierDigit)
    cnpj = new(number)
    formatted ? cnpj.formatted : cnpj.stripped
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
      return
    end

    return unless stripped.match?(VALIDATION_SIZE_REGEX)
    return if DENYLIST.include?(stripped)

    digits = numbers[0...12]
    digits << VerifierDigit.generate(digits)
    digits << VerifierDigit.generate(digits)

    digits[-2, 2] == numbers[-2, 2]
  end

  def basic_digits
    @basic_digits ||= stripped[0..7]
  end

  def ==(other)
    super || (other.instance_of?(self.class) && other.stripped == stripped)
  end
  alias eql? ==

  private def numbers
    @numbers ||= stripped.each_char.to_a.map(&:to_i)
  end
end
