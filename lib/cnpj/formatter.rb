class CNPJ
  class Formatter
    def self.format(number)
      strip(number).gsub(/\A(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})\Z/, "\\1.\\2.\\3/\\4-\\5")
    end

    def self.strip(number)
      number.to_s.gsub(/[^\d]/, "")
    end
  end
end
