# frozen_string_literal: true

# rubocop:disable Style/OneClassPerFile

module CpfCnpj
  VERSION = "1.0.1"
end

class CPF
  VERSION = CpfCnpj::VERSION
end

class CNPJ
  VERSION = CpfCnpj::VERSION
end
# rubocop:enable Style/OneClassPerFile
