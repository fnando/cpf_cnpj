class CNPJ
  class VerifierDigit
    def self.generate(numbers)
      index = 2

      sum = numbers.reverse.reduce(0) do |sum, number|
        (sum + number * index).tap do
          index = index == 9 ? 2 : index + 1
        end
      end

      mod = sum % 11
      mod < 2 ? 0 : 11 - mod
    end
  end
end
