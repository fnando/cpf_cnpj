# frozen_string_literal: true

require "test_helper"

module CNPJCli
  class CheckTest < Minitest::Test
    include RunCommand

    %w[-c --check].each do |switch|
      test "checks if provided number is valid [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch, "54550752000155"])

        assert_equal "", stdout
        assert_equal "", stderr
        assert_equal 0, exit_status
      end

      test "outputs error if provided number is invalid [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch, "invalid"])

        assert_equal "", stdout
        assert_equal 1, exit_status
        assert stderr.include?("Error: Invalid number")
      end
    end
  end

  class HelpTest < Minitest::Test
    include RunCommand

    %w[-h --help].each do |switch|
      test "outputs help [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch])

        assert_equal "", stdout
        assert stderr.include?("Usage: cnpj")
        assert_equal 1, exit_status
      end
    end

    test "outputs help on tail" do
      exit_status, stdout, stderr = run_command([])

      assert_equal "", stdout
      assert stderr.include?("Usage: cnpj")
      assert_equal 1, exit_status
    end
  end

  class VersionTest < Minitest::Test
    include RunCommand

    %w[-v --version].each do |switch|
      test "outputs version [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch])

        assert stdout.include?(CNPJ::VERSION.to_s)
        assert_equal "", stderr
        assert_equal 0, exit_status
      end
    end
  end

  class GenerateTest < Minitest::Test
    include RunCommand

    %w[-g --generate].each do |switch|
      test "generates number [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch])

        assert_match CNPJ::REGEX, stdout
        assert_equal "", stderr
        assert_equal 0, exit_status
      end
    end

    test "generates stripped number" do
      exit_status, stdout, stderr = run_command(["-gs"])

      assert_match(/\A\d{14}\Z/, stdout)
      assert_equal "", stderr
      assert_equal 0, exit_status
    end
  end

  class FormatTest < Minitest::Test
    include RunCommand

    %w[-f --format].each do |switch|
      test "formats argument [using #{switch}]" do
        exit_status, stdout, stderr = run_command([switch, "54550752000155"])

        assert stdout.include?("54.550.752/0001-55")
        assert_equal "", stderr
        assert_equal 0, exit_status
      end
    end

    test "formats argument using stdin" do
      exit_status, stdout, stderr = run_command(["--format"],
                                                input: "54550752000155")

      assert stdout.include?("54.550.752/0001-55")
      assert_equal "", stderr
      assert_equal 0, exit_status
    end

    test "fails when providing invalid number" do
      exit_status, stdout, stderr = run_command(["--format", "invalid"])

      assert_equal "", stdout
      assert stderr.include?("Error: Invalid number")
      assert_equal 1, exit_status
    end

    test "fails when not providing a number" do
      exit_status, stdout, stderr = run_command(["--format"])

      assert_equal "", stdout
      assert stderr.include?("Error: Invalid number")
      assert_equal 1, exit_status
    end
  end
end
