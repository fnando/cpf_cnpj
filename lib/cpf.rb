class CPF
  require "cpf/cli"
  require "cpf/formatter"
  require "cpf/generator"
  require "cpf/verifier_digit"

  attr_reader :number

  REGEX = /\A\d{3}\.\d{3}\.\d{3}-\d{2}\Z/

  BLACKLIST = [
    "00000000000",
    "11111111111",
    "22222222222",
    "33333333333",
    "44444444444",
    "55555555555",
    "66666666666",
    "77777777777",
    "88888888888",
    "99999999999",
    "12345678909"
  ]

  def self.valid?(number)
    new(number).valid?
  end

  def self.generate(formatted = false)
    cpf = new(Generator.generate)
    formatted ? cpf.formatted : cpf.stripped
  end

  def initialize(number)
    @number = number.to_s
  end

  def number=(number)
    @stripped = nil
    @formatted = nil
    @numbers = nil
    @number = number
  end

  def stripped
    @stripped ||= Formatter.strip(number)
  end

  def formatted
    @formatted ||= Formatter.format(number)
  end

  def valid?
    return unless stripped.size == 11
    return if BLACKLIST.include?(stripped)

    _numbers = numbers[0...9]
    _numbers << VerifierDigit.generate(_numbers)
    _numbers << VerifierDigit.generate(_numbers)

    _numbers[-2, 2] == numbers[-2, 2]
  end

  private
  def numbers
    @numbers ||= stripped.each_char.to_a.map(&:to_i)
  end
end
