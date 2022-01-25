# frozen_string_literal: true

module CpfCnpj
  class Generator
    NUMBERS = Array(0..9).freeze

    def self.generate(size, verifier_digit_generator)
      numbers = Array.new(size) { NUMBERS.sample }
      numbers << verifier_digit_generator.generate(numbers)
      numbers << verifier_digit_generator.generate(numbers)
      numbers.join
    end
  end
end
