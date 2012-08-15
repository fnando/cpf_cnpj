class CPF
  class CLI
    attr_accessor :arguments
    attr_accessor :stdin
    attr_accessor :stdout
    attr_accessor :stderr

    def initialize(arguments, stdin, stdout, stderr)
      @arguments = arguments
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
    end

    def start
      options = {}

      opts.banner = "Usage: cpf [options] [CPF number]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-c", "--check", "Check if CPF is valid") do
        options[:check] = true
      end

      opts.on("-g", "--generate", "Generate a new CPF") do
        options[:generate] = true
      end

      opts.on("-f", "--format", "Format CPF with separators") do
        options[:format] = true
      end

      opts.on("-s", "--strip", "Remove CPF separators") do
        options[:strip] = true
      end

      opts.on("-v", "--version", "Show version") do
        stdout << VERSION
        exit
      end

      opts.on_tail("-h", "--help", "Show help") do
        help
        exit
      end

      opts.parse!(arguments)
      opts.permute!(arguments)

      help if options.empty?
      generate(options) if options[:generate]

      cpf = CPF.new(arguments.first || stdin.read)

      validate(cpf)
      format(cpf) if options[:format]
      strip(cpf) if options[:strip]
      check(cpf) if options[:check]
    end

    def validate(cpf)
      return if cpf.valid?
      stderr << "Error: Invalid number\n"
      exit 1
    end

    def check(cpf)
      exit
    end

    def generate(options)
      cpf = CPF.new(Generator.generate)

      if options[:strip]
        stdout << cpf.stripped
      else
        stdout << cpf.formatted
      end

      exit
    end

    def format(cpf)
      stdout << cpf.formatted
      exit
    end

    def strip(cpf)
      stdout << cpf.stripped
      exit
    end

    def help
      stderr << opts.to_s
      exit 1
    end

    def opts
      @opts ||= OptionParser.new
    end
  end
end
