module CpfCnpj
  class Generator
    NUMBERS = [*0..9].freeze

    def self.generate(size, verifier_digit_generator)
      numbers = size.times.map { NUMBERS.sample }
      numbers << verifier_digit_generator.generate(numbers)
      numbers << verifier_digit_generator.generate(numbers)
      numbers.join("")
    end
  end
end
