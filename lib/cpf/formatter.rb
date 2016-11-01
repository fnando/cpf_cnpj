class CPF
  class Formatter
    STRICT_REGEX = /[.-]/
    LOOSE_REGEX = /[^\d]/

    def self.format(number)
      strip(number).gsub(/\A(\d{3})(\d{3})(\d{3})(\d{2})\Z/, "\\1.\\2.\\3-\\4")
    end

    def self.strip(number, strict = false)
      number.to_s.gsub(strict ? STRICT_REGEX : LOOSE_REGEX, "")
    end
  end
end
