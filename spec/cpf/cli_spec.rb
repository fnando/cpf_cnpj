require "spec_helper"

describe CPF::CLI do
  let(:stdout) { "" }
  let(:stderr) { "" }
  let(:stdin) { StringIO.new }

  context "check" do
    %w[-c --check].each do |switch|
      it "checks if provided number is valid [using #{switch}]" do
        capture_exit do
          CPF::CLI.new([switch, "77673736578"], stdin, stdout, stderr).start
        end

        expect(stdout).to eql("")
      end

      it "outputs error message if provided number is invalid [using #{switch}]" do
        capture_exit(1) do
          CPF::CLI.new([switch, "invalid"], stdin, stdout, stderr).start
        end

        expect(stderr).to include("Error: Invalid number")
      end
    end
  end

  context "help" do
    %w[-h --help].each do |switch|
      it "outputs help [using #{switch}]" do
        capture_exit(1) do
          CPF::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stderr).to include("Usage: cpf")
      end
    end

    it "outputs help on tail" do
      capture_exit(1) do
        CPF::CLI.new([], stdin, stdout, stderr).start
      end

      expect(stderr).to include("Usage: cpf")
    end
  end

  context "version" do
    %w[-v --version].each do |switch|
      it "outputs version [using #{switch}]" do
        capture_exit do
          CPF::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stdout).to include(CPF::VERSION.to_s)
      end
    end
  end

  context "generate" do
    %w[-g --generate].each do |switch|
      it "generates number [using -#{switch}]" do
        capture_exit do
          CPF::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stdout).to match(CPF::REGEX)
      end
    end

    it "generates stripped number" do
      capture_exit do
        CPF::CLI.new(["-gs"], stdin, stdout, stderr).start
      end

      expect(stdout).to match(/\A\d{11}\Z/)
    end
  end

  context "format" do
    %w[-f --format].each do |switch|
      it "formats argument [using #{switch}]" do
        capture_exit do
          CPF::CLI.new([switch, "77673736578"], stdin, stdout, stderr).start
        end

        expect(stdout).to include("776.737.365-78")
      end
    end

    it "formats argument using stdin" do
      stdin = StringIO.new("77673736578")

      capture_exit do
        CPF::CLI.new(["--format"], stdin, stdout, stderr).start
      end

      expect(stdout).to include("776.737.365-78")
    end

    let(:switch) { "--format" }
    it_behaves_like "validation"
  end

  context "strip" do
    %w[-s --strip].each do |switch|
      it "strips argument [using #{switch}]" do
        capture_exit do
          CPF::CLI.new([switch, "776.737.365-78"], stdin, stdout, stderr).start
        end

        expect(stdout).to include("77673736578")
      end
    end

    let(:switch) { "--strip" }
    it_behaves_like "validation"
  end
end
