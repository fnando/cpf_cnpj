# frozen_string_literal: true

class CNPJ
  class Formatter
    STRICT_REGEX = %r{[/.-]}.freeze
    LOOSE_REGEX = /[^A-Z\d]/.freeze
    REPLACE_REGEX = /
      \A([A-Z\d]{2})([A-Z\d]{3})([A-Z\d]{3})([A-Z\d]{4})([A-Z\d]{2})\Z
    /x.freeze

    def self.format(number)
      strip(number).gsub(REPLACE_REGEX, "\\1.\\2.\\3/\\4-\\5")
    end

    def self.strip(number, strict = false)
      number.to_s.gsub(strict ? STRICT_REGEX : LOOSE_REGEX, "")
    end
  end
end
