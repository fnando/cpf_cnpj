module CpfCnpj
  class CLI
    attr_reader :document_class, :arguments, :stdin, :stdout, :stderr

    def initialize(document_class, arguments, stdin, stdout, stderr)
      @document_class = document_class
      @arguments = arguments
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
    end

    def bin_name
      document_name.downcase
    end

    def document_name
      document_class.name
    end

    def start
      options = {}

      opts.banner = "Usage: #{bin_name} [options] [#{document_name} number]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-c", "--check", "Check if #{document_name} is valid") do
        options[:check] = true
      end

      opts.on("-g", "--generate", "Generate a new #{document_name}") do
        options[:generate] = true
      end

      opts.on("-f", "--format", "Format #{document_name} with separators") do
        options[:format] = true
      end

      opts.on("-s", "--strip", "Remove #{document_name} separators") do
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
      input = stdin.tty? ? arguments.first : stdin.read
      document = document_class.new(input)
      validate(document)
      format(document) if options[:format]
      strip(document) if options[:strip]
      check(document) if options[:check]
    end

    def validate(document)
      return if document.valid?
      stderr << "Error: Invalid number\n"
      exit 1
    end

    # No-op method. CPF is always validated on CpfCnpj::CLI#start.
    def check(_document)
      exit
    end

    def generate(options)
      document = document_class.new(document_class.generate)

      if options[:strip]
        stdout << document.stripped
      else
        stdout << document.formatted
      end

      exit
    end

    def format(document)
      stdout << document.formatted
      exit
    end

    def strip(document)
      stdout << document.stripped
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
