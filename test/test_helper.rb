require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler/setup'

require 'gemojione'

require 'minitest/autorun'
require 'minitest/pride'

UNIMOJI = {heart:   "\u{2764}",
           cyclone: "\u{1f300}"}.freeze
