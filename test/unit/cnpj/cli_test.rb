require "test_helper"

module CNPJCli
  class CheckTest < Minitest::Test
    include CaptureExit

    let(:stdin) { StringIO.new }
    let(:stdout) { "" }
    let(:stderr) { "" }

    %w[-c --check].each do |switch|
      test "checks if provided number is valid [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch, "54550752000155"], stdin, stdout, stderr).start
        end

        assert_equal stdout, ""
      end

      test "outputs error message if provided number is invalid [using #{switch}]" do
        capture_exit(1) do
          CNPJ::CLI.new([switch, "invalid"], stdin, stdout, stderr).start
        end

        assert stderr.include?("Error: Invalid number")
      end
    end
  end

  class HelpTest < Minitest::Test
    include CaptureExit

    let(:stdin) { StringIO.new }
    let(:stdout) { "" }
    let(:stderr) { "" }

    %w[-h --help].each do |switch|
      test "outputs help [using #{switch}]" do
        capture_exit(1) do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        assert stderr.include?("Usage: cnpj")
      end
    end

    test "outputs help on tail" do
      capture_exit(1) do
        CNPJ::CLI.new([], stdin, stdout, stderr).start
      end

      assert stderr.include?("Usage: cnpj")
    end
  end

  class VersionTest < Minitest::Test
    include CaptureExit

    let(:stdin) { StringIO.new }
    let(:stdout) { "" }
    let(:stderr) { "" }

    %w[-v --version].each do |switch|
      test "outputs version [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        assert stdout.include?(CNPJ::VERSION.to_s)
      end
    end
  end

  class GenerateTest < Minitest::Test
    include CaptureExit

    let(:stdin) { StringIO.new }
    let(:stdout) { "" }
    let(:stderr) { "" }

    %w[-g --generate].each do |switch|
      test "generates number [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch], stdin, stdout, stderr).start
        end

        assert_match CNPJ::REGEX, stdout
      end
    end

    test "generates stripped number" do
      capture_exit do
        CNPJ::CLI.new(["-gs"], stdin, stdout, stderr).start
      end

      assert_match /\A\d{14}\Z/, stdout
    end
  end

  class FormatTest < Minitest::Test
    include CaptureExit

    let(:stdin) { StringIO.new }
    let(:stdout) { "" }
    let(:stderr) { "" }

    %w[-f --format].each do |switch|
      test "formats argument [using #{switch}]" do
        capture_exit do
          CNPJ::CLI.new([switch, "54550752000155"], stdin, stdout, stderr).start
        end

        assert stdout.include?("54.550.752/0001-55")
      end
    end

    test "formats argument using stdin" do
      stdin = StringIO.new("54550752000155")

      capture_exit do
        CNPJ::CLI.new(["--format"], stdin, stdout, stderr).start
      end

      assert stdout.include?("54.550.752/0001-55")
    end

    test "fails when providing Invalid number" do
      capture_exit(1) do
        CNPJ::CLI.new(["--format", "invalid"], stdin, stdout, stderr).start
      end

      assert stderr.include?("Error: Invalid number")
    end

    test "fails when not providing a number" do
      capture_exit(1) do
        CNPJ::CLI.new(["--format"], stdin, stdout, stderr).start
      end

      assert stderr.include?("Error: Invalid number")
    end
  end
end
