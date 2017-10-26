# frozen_string_literal: true

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

    def options
      @options ||= {}
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def process_command
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
        help(true)
      end

      opts.parse!(arguments)
      opts.permute!(arguments)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def input
      stdin.tty? ? arguments.first : stdin.read
    end

    def start
      process_command
      help
      generate(options)
      document = document_class.new(input)
      validate(document)
      format(document)
      strip(document)
      check(document)
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
      return unless options[:generate]

      document = document_class.new(document_class.generate)

      output =  if options[:strip]
                  document.stripped
                else
                  document.formatted
                end

      stdout << output

      exit
    end

    def format(document)
      return unless options[:format]

      stdout << document.formatted
      exit
    end

    def strip(document)
      return unless options[:strip]

      stdout << document.stripped
      exit
    end

    def help(run = options.empty?)
      return unless run

      stderr << opts.to_s
      exit 1
    end

    def opts
      @opts ||= OptionParser.new
    end
  end
end
