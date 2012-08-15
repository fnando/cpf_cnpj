class CNPJ
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

      opts.banner = "Usage: cnpj [options] [CNPJ number]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-c", "--check", "Check if CNPJ is valid") do
        options[:check] = true
      end

      opts.on("-g", "--generate", "Generate a new CNPJ") do
        options[:generate] = true
      end

      opts.on("-f", "--format", "Format CNPJ with separators") do
        options[:format] = true
      end

      opts.on("-s", "--strip", "Remove CNPJ separators") do
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

      help and exit(1) if options.empty?
      generate(options) if options[:generate]

      cnpj = CNPJ.new(arguments.first || stdin.read)
      validate(cnpj)
      format(cnpj) if options[:format]
      strip(cnpj) if options[:strip]
      check(cnpj) if options[:check]
    end

    def validate(cnpj)
      return if cnpj.valid?
      stderr << "Error: Invalid number\n"
      exit 1
    end

    def check(cnpj)
      exit
    end

    def generate(options)
      cnpj = CNPJ.new(Generator.generate)

      if options[:strip]
        stdout << cnpj.stripped
      else
        stdout << cnpj.formatted
      end

      exit
    end

    def format(cnpj)
      stdout << cnpj.formatted
      exit
    end

    def strip(cnpj)
      stdout << cnpj.stripped
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
