require "bundler/grep/version"
require 'bundler'

module Bundler
  module Grep
     def self.start!(argv)
       p Bundler.load.specs
     end
  end
end
