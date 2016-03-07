require "test_helper"

module CNPJCli
  class CheckTest < Minitest::Test
    include CaptureSyscall

    %w[-c --check].each do |switch|
      test "checks if provided number is valid [using #{switch}]" do
        exit_status, stdout = capture_syscall do
          system "./bin/cnpj #{switch} 54550752000155"
        end

        assert_equal 0, exit_status
        assert_equal stdout, ""
      end

      test "outputs error message if provided number is invalid [using #{switch}]" do
        exit_status, _, stderr = capture_syscall do
          system "./bin/cnpj #{switch} invalid"
        end

        assert_equal 1, exit_status
        assert stderr.include?("Error: Invalid number")
      end
    end
  end

  class HelpTest < Minitest::Test
    include CaptureSyscall

    %w[-h --help].each do |switch|
      test "outputs help [using #{switch}]" do
        exit_status, _, stderr = capture_syscall do
          system "./bin/cnpj #{switch}"
        end

        assert_equal 1, exit_status
        assert stderr.include?("Usage: cnpj")
      end
    end

    test "outputs help on tail" do
      exit_status, _, stderr = capture_syscall do
        system "./bin/cnpj"
      end

      assert_equal 1, exit_status
      assert stderr.include?("Usage: cnpj")
    end
  end

  class VersionTest < Minitest::Test
    include CaptureSyscall

    %w[-v --version].each do |switch|
      test "outputs version [using #{switch}]" do
        exit_status, stdout = capture_syscall do
          system "./bin/cnpj #{switch}"
        end

        assert_equal 0, exit_status
        assert stdout.include?(CNPJ::VERSION.to_s)
      end
    end
  end

  class GenerateTest < Minitest::Test
    include CaptureSyscall

    %w[-g --generate].each do |switch|
      test "generates number [using #{switch}]" do
        exit_status, stdout = capture_syscall do
          system "./bin/cnpj #{switch}"
        end

        assert_equal 0, exit_status
        assert_match CNPJ::REGEX, stdout
      end
    end

    test "generates stripped number" do
      exit_status, stdout = capture_syscall do
        system "./bin/cnpj -gs"
      end

      assert_equal 0, exit_status
      assert_match /\A\d{14}\Z/, stdout
    end
  end

  class FormatTest < Minitest::Test
    include CaptureSyscall

    %w[-f --format].each do |switch|
      test "formats argument [using #{switch}]" do
        exit_status, stdout = capture_syscall do
          system "./bin/cnpj #{switch} 54550752000155"
        end

        assert_equal 0, exit_status
        assert stdout.include?("54.550.752/0001-55")
      end
    end

    test "formats argument using stdin" do
      exit_status, stdout = capture_syscall do
        system "echo 54550752000155 | ./bin/cnpj --format"
      end

      assert_equal 0, exit_status
      assert stdout.include?("54.550.752/0001-55")
    end

    test "fails when providing invalid number" do
      exit_status, _, stderr = capture_syscall do
        system "./bin/cnpj --format invalid"
      end

      assert_equal 1, exit_status
      assert stderr.include?("Error: Invalid number")
    end

    test "fails when not providing a number" do
      exit_status, _, stderr = capture_syscall do
        system "./bin/cnpj --format"
      end

      assert_equal 1, exit_status
      assert stderr.include?("Error: Invalid number")
    end
  end
end
