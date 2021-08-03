# frozen_string_literal: true

require "timeout"
require "open3"

module CaptureSyscall
  def capture_syscall(cmd)
    stdout, stderr = Timeout.timeout(1) do
      capture_subprocess_io do
        `#{cmd}`
        exit_status = $?.exitstatus
      end
    end

    #Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
    #  [wait_thr.value.exitstatus, stdout.read, stderr.read]
    #end    
  end
end
