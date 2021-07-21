# frozen_string_literal: true

require "timeout"

module CaptureSyscall
  def capture_syscall
    exit_status = nil

    stdout, stderr = Timeout.timeout(5) do
      capture_subprocess_io do
        yield
        exit_status = $CHILD_STATUS.exitstatus
      end
    end

    [exit_status, stdout, stderr]
  end
end
