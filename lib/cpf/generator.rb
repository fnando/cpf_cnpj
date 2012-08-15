class CPF
  class Generator
    NUMBERS = [*0..9].freeze

    def self.generate
      numbers = 9.times.map { NUMBERS.sample }
      numbers << VerifierDigit.generate(numbers)
      numbers << VerifierDigit.generate(numbers)
      numbers.join("")
    end
  end
end
