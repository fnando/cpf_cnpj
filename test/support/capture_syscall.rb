# frozen_string_literal: true

require "timeout"

module CaptureSyscall
  def capture_syscall(cmd)
    stdout = stderr = `#{cmd} 2>&1`
    exit_status = $CHILD_STATUS.exitstatus
    puts "@#{cmd}: |#{stdout}| --- |#{stderr}| --- |#{exit_status}|@"
    [exit_status, stdout, stderr]    
  end
end
