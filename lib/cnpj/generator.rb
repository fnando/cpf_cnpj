class CNPJ
  class Generator
    NUMBERS = [*0..9].freeze

    def self.generate
      numbers = 12.times.map { NUMBERS.sample }
      numbers << VerifierDigit.generate(numbers)
      numbers << VerifierDigit.generate(numbers)
      numbers.join("")
    end
  end
end
