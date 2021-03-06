module Jekyll
  module Deprecator
    def self.process(args)
      no_subcommand(args)
      arg_is_present? args, "--server", "The --server command has been replaced by the \
                          'serve' subcommand."
      arg_is_present? args, "--no-server", "To build Jekyll without launching a server, \
                          use the 'build' subcommand."
      arg_is_present? args, "--auto", "The switch '--auto' has been replaced with '--watch'."
      arg_is_present? args, "--no-auto", "To disable auto-replication, simply leave off \
                          the '--watch' switch."
      arg_is_present? args, "--pygments", "The 'pygments'settings has been removed in \
                          favour of 'highlighter'."
      arg_is_present? args, "--paginate", "The 'paginate' setting can only be set in your \
                          config files."
      arg_is_present? args, "--url", "The 'url' setting can only be set in your config files."
    end

    def self.no_subcommand(args)
      if args.size > 0 && args.first =~ /^--/ && !%w[--help --version].include?(args.first)
        deprecation_message "Jekyll now uses subcommands instead of just \
                            switches. Run `jekyll --help' to find out more."
      end
    end

    def self.arg_is_present?(args, deprecated_argument, message)
      if args.include?(deprecated_argument)
        deprecation_message(message)
      end
    end

    def self.deprecation_message(message)
      Jekyll.logger.error "Deprecation:", message
    end

    def self.gracefully_require(gem_name)
      Array(gem_name).each do |name|
        begin
          require name
        rescue LoadError => e
          Jekyll.logger.error "Dependency Error:", <<-MSG
  Yikes! It looks like you don't have #{name} or one of its dependencies installed.
  In order to use Jekyll as currently configured, you'll need to install this gem.

  The full error message from Ruby is: '#{e.message}'

  If you run into trouble, you can find helpful resources at http://jekyllrb.com/help/!
MSG
          raise Errors::MissingDependencyException.new(name)
        end
      end
    end
  end
end
