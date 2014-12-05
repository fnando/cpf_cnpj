class CPF
  class VerifierDigit
    def self.generate(numbers)
      modulus = numbers.size + 1

      multiplied = numbers.map.each_with_index do |number, index|
        number * (modulus - index)
      end

      mod = multiplied.reduce(:+) % 11
      mod < 2 ? 0 : 11 - mod
    end
  end
end
