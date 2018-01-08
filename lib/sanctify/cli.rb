require 'yaml'
require 'optparse'
module Sanctify
  class CliError < StandardError; end
  class CLI
    def self.run(argv)
      args = {}

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: sanctify [-r REPO_PATH] [-c CONFIG_PATH]"

        opts.on("-r REPO", "--repo REPO", "Repo to test") do |repo|
          args[:repo] = repo
        end

        opts.on("-c CONFIG", "--config CONFIG", "Configuration file in YAML") do |config|
          args[:config] = YAML.load(File.open(config))
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end

      opt_parser.parse!(argv)
      if args[:repo].nil?
        if Dir['.git'].empty?
          raise Sanctify::CliError, "Repo not specified and current directory not a git repository."
        else
          args[:repo] = Dir.pwd
        end
      end
      Scanner.new(args).run
    end
  end
end