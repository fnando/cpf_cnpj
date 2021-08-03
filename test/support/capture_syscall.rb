# frozen_string_literal: true

require "timeout"

module CaptureSyscall
  def capture_syscall
    exit_status = nil

    stdout, stderr = Timeout.timeout(1) do
      capture_subprocess_io do
        yield
        #exit_status = $CHILD_STATUS.exitstatus
        exit_status = $CHILD_STATUS.success? ? 0 : 1
      end
    end

    [exit_status, stdout, stderr]
  end
end
