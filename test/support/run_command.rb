# frozen_string_literal: true

module RunCommand
  class TTYStringIO < StringIO
    def tty?
      true
    end
  end

  def run_command(args, input: nil)
    stdout = StringIO.new
    stderr = StringIO.new
    stdin = input ? StringIO.new(input) : TTYStringIO.new
    exit_status = 0

    mod = if self.class.name.start_with?("CPF")
            CPF
          else
            CNPJ
          end

    begin
      CpfCnpj::CLI.new(mod, args, stdin, stdout, stderr).start
    rescue SystemExit => error
      exit_status = error.status
    end

    [exit_status, stdout.tap(&:rewind).read, stderr.tap(&:rewind).read]
  end
end
