# frozen_string_literal: true

require "test_helper"

module CPFCli
  class CheckTest < Minitest::Test
    include RunCommand

    %w[-c --check].each do |switch|
      test "checks if provided number is valid [using #{switch}]" do
        exit_status, stdout = run_command([switch, "76616598837"])

        assert_equal 0, exit_status
        assert_equal "", stdout
      end

      test "outputs error if provided number is invalid [using #{switch}]" do
        exit_status, _, stderr = run_command([switch, "invalid"])

        assert_equal 1, exit_status
        assert_includes stderr, "Error: Invalid number"
      end
    end
  end

  class HelpTest < Minitest::Test
    include RunCommand

    %w[-h --help].each do |switch|
      test "outputs help [using #{switch}]" do
        exit_status, _, stderr = run_command([switch])

        assert_equal 1, exit_status
        assert_includes stderr, "Usage: cpf"
      end
    end

    test "outputs help on tail" do
      exit_status, _, stderr = run_command([])

      assert_equal 1, exit_status
      assert_includes stderr, "Usage: cpf"
    end
  end

  class VersionTest < Minitest::Test
    include RunCommand

    %w[-v --version].each do |switch|
      test "outputs version [using #{switch}]" do
        exit_status, stdout, _stderr = run_command([switch])

        assert_equal 0, exit_status
        assert_includes stdout, CPF::VERSION.to_s
      end
    end
  end

  class GenerateTest < Minitest::Test
    include RunCommand

    %w[-g --generate].each do |switch|
      test "generates number [using #{switch}]" do
        exit_status, stdout = run_command([switch])

        assert_equal 0, exit_status
        assert_match CPF::REGEX, stdout
      end
    end

    test "generates stripped number" do
      exit_status, stdout = run_command(["-gs"])

      assert_equal 0, exit_status
      assert_match(/\A\d{11}\Z/, stdout)
    end
  end

  class FormatTest < Minitest::Test
    include RunCommand

    %w[-f --format].each do |switch|
      test "formats argument [using #{switch}]" do
        exit_status, stdout = run_command([switch, "76616598837"])

        assert_equal 0, exit_status
        assert_includes stdout, "766.165.988-37"
      end
    end

    test "formats argument using stdin" do
      exit_status, stdout = run_command(["--format"], input: "76616598837")

      assert_equal 0, exit_status
      assert_includes stdout, "766.165.988-37"
    end

    test "fails when providing invalid number" do
      exit_status, _, stderr = run_command(["--format", "invalid"])

      assert_equal 1, exit_status
      assert_includes stderr, "Error: Invalid number"
    end

    test "fails when not providing a number" do
      exit_status, _, stderr = run_command(["--format"])

      assert_equal 1, exit_status
      assert_includes stderr, "Error: Invalid number"
    end
  end
end
