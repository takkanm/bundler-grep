require "bundler/grep/version"
require 'bundler'

module Bundler
  module Grep
    class << self
      def start!(argv)
        Kernel.exec(*grep_command, argv[0], *Bundler.load.specs.map(&:full_gem_path))
      end

      private

      def grep_command
        if ENV['BUNDLER_GREP_CMD']
          ENV['BUNDLER_GREP_CMD'].split(/ /).reject {|w| w == '' }
        else
          %w(grep -R)
        end
      end
    end
  end
end
