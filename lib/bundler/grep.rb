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
        @gems        = []
        @ignore_gems = []

        parse_argument!(argv)
      end

      def start!
        Kernel.exec(*grep_command, @argv[0], *selected_gem_paths)
      end

      private

      def parse_argument!(argv)
        opt = OptionParser.new
        opt.on('-g name1[,name2..]', '--gems name1[,name2..]', 'select target gems') do |gems|
          @gems = gems.split(',')
        end
        opt.on('--ingore-gems name1[,name2..]', 'ignore grep gems') do |gems|
          @ignore_gems = gems.split(',')
        end
        opt.version = Bundler::Grep::VERSION

        opt.parse!(argv)
        @argv = argv
      end

      def grep_command
        if ENV['BUNDLER_GREP_CMD']
          ENV['BUNDLER_GREP_CMD'].split(/ /).reject {|w| w == '' }
        else
          %w(grep -R)
        end
      end

      def selected_gem_paths
        selected_gem_specs.map(&:full_gem_path)
      end

      def selected_gem_specs
        return Bundler.load.specs if @gems.empty? && @ignore_gems.empty?

        Bundler.load.specs.find_all {|spec|
          collecte_gem?(spec.name) && not_ignored_gem?(spec.name)
        }
      end

      def collecte_gem?(gem_name)
        @gems.empty? || @gems.include?(gem_name)
      end

      def not_ignored_gem?(gem_name)
        @ignore_gems.empty? || !@ignore_gems.include?(gem_name)
      end
    end
  end
end
