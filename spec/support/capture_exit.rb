module CaptureExit
  def capture_exit(status = 0, &block)
    yield
    raise "Expected exit(#{status}); it didn't exit"
  rescue SystemExit => error
    raise "Expected exit(#{status}); got exit(#{error.status})" unless status == error.status
  end
end

RSpec.configuration.include(CaptureExit)
