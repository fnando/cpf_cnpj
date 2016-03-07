require "bundler"
Bundler.setup
Bundler.require

require "minitest/utils"
require "minitest/autorun"

require_relative "./support/capture_syscall"
