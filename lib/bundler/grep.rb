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
        if @gems
          Bundler.load.specs.find_all {|spec|
            @gems.include?(spec.name)
          }.map(&:full_gem_path)
        else
          Bundler.load.specs.map(&:full_gem_path)
        end
      end
    end
  end
end
