require "simplecov"
require "simplecov-html"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter::new [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
]

SimpleCov.start do
  add_filter "test/"
end

require "minitest"
require "minitest/unit"
require "minitest/autorun"
require "has_a_token"
