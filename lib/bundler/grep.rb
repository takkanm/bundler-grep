require "bundler/grep/version"
require 'bundler'
require 'optparse'

module Bundler
  module Grep
    def self.start!(argv)
      Bundler::Grep::Command.new(argv).start!
    end

    class Command
      def initialize(argv)
        @argv = argv
      end

      def start!
        Kernel.exec(*grep_command, @argv[0], *Bundler.load.specs.map(&:full_gem_path))
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
