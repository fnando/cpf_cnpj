# frozen_string_literal: true

require "timeout"

module CaptureSyscall
  def capture_syscall(cmd)
    stdout = stderr = `#{cmd} 2>&1`
    exit_status = $?.success? ? 0 : 1
    puts "AAAAAAAA: |#{stdout}| --- |#{stderr}| --- |#{exit_status}|"
    [exit_status, stdout, stderr]    
  end
end
