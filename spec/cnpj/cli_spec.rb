require "spec_helper"

describe CNPJ::CLI do
  let(:stdout) { "" }
  let(:stderr) { "" }
  let(:stdin) { StringIO.new }

  context "check" do
    %w[-c --check].each do |switch|
      it "checks if provided number is valid [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch, "54550752000155"], stdin, stdout, stderr).start
        end

        expect(stdout).to eql("")
      end

      it "outputs error message if provided number is invalid [using #{switch}]" do
        capture_exit(1) do
          CNPJ::CLI.new([switch, "invalid"], stdin, stdout, stderr).start
        end

        expect(stderr).to include("Error: Invalid number")
      end
    end
  end

  context "help" do
    %w[-h --help].each do |switch|
      it "outputs help [using #{switch}]" do
        capture_exit(1) do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stderr).to include("Usage: cnpj")
      end
    end

    it "outputs help on tail" do
      capture_exit(1) do
        CNPJ::CLI.new([], stdin, stdout, stderr).start
      end

      expect(stderr).to include("Usage: cnpj")
    end
  end

  context "version" do
    %w[-v --version].each do |switch|
      it "outputs version [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stdout).to include(CNPJ::VERSION.to_s)
      end
    end
  end

  context "generate" do
    %w[-g --generate].each do |switch|
      it "generates number [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        expect(stdout).to match(CNPJ::REGEX)
      end
    end

    it "generates stripped number" do
      capture_exit do
        CNPJ::CLI.new(["-gs"], stdin, stdout, stderr).start
      end

      expect(stdout).to match(/\A\d{14}\Z/)
    end
  end

  context "format" do
    %w[-f --format].each do |switch|
      it "formats argument [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch, "54550752000155"], stdin, stdout, stderr).start
        end

        expect(stdout).to include("54.550.752/0001-55")
      end
    end

    it "formats argument using stdin" do
      stdin = StringIO.new("54550752000155")

      capture_exit do
        CNPJ::CLI.new(["--format"], stdin, stdout, stderr).start
      end

      expect(stdout).to include("54.550.752/0001-55")
    end

    let(:switch) { "--format" }
    it_behaves_like "validation"
  end

  context "strip" do
    %w[-s --strip].each do |switch|
      it "strips argument [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch, "54.550.752/0001-55"], stdin, stdout, stderr).start
        end

        expect(stdout).to include("54550752000155")
      end
    end

    let(:switch) { "--strip" }
    it_behaves_like "validation"
  end
end
