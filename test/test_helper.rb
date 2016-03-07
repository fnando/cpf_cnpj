require "bundler"
Bundler.setup
Bundler.require

require "minitest/utils"
require "minitest/autorun"

require_relative "./support/capture_exit"
# require_relative "./support/validation_shared"
