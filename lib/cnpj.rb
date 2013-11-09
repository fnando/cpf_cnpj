class CNPJ
  require "cnpj/cli"
  require "cnpj/formatter"
  require "cnpj/generator"
  require "cnpj/verifier_digit"

  attr_reader :number

  REGEX = /\A\d{2}\.\d{3}.\d{3}\/\d{4}-\d{2}\Z/

  BLACKLIST = [
    "00000000000000",
    "11111111111111",
    "22222222222222",
    "33333333333333",
    "44444444444444",
    "55555555555555",
    "66666666666666",
    "77777777777777",
    "88888888888888",
    "99999999999999"
  ]

  def self.valid?(number)
    new(number).valid?
  end

  def self.generate(formatted = false)
    cnpj = new(Generator.generate)
    formatted ? cnpj.formatted : cnpj.stripped
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
    return unless stripped.size == 14
    return if BLACKLIST.include?(stripped)

    _numbers = numbers[0...12]
    _numbers << VerifierDigit.generate(_numbers)
    _numbers << VerifierDigit.generate(_numbers)

    _numbers[-2, 2] == numbers[-2, 2]
  end

  private
  def numbers
    @numbers ||= stripped.each_char.to_a.map(&:to_i)
  end
end
