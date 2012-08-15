class CPF
  class Formatter
    def self.format(number)
      strip(number).gsub(/\A(\d{3})(\d{3})(\d{3})(\d{2})\Z/, "\\1.\\2.\\3-\\4")
    end

    def self.strip(number)
      number.to_s.gsub(/[^\d]/, "")
    end
  end
end
