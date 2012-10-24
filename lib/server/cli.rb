require 'thor'
require 'thor/actions'

# check reference
# https://github.com/carlhuda/bundler/blob/master/lib/bundler/cli.rb

module Cucub
  class Server
    class CLI < Thor
      include Thor::Actions

      #default_task :start

      desc "start", "start cucub as a service"
      method_option :host, :aliases => '-h', :default => '127.0.0.1', :type => :string
      def start(boot_file)
        opts = options.dup

        # puts opts.inspect
        # puts gem

        # encapsular esto en una clase de Cucub::Server
        # mover esto a una clase de cucub:server
        logger = Logger.new($stderr)
        logger.level = Logger::DEBUG

        # encapsular esto en una clase de Cucub::Server
        pid_file = File.expand_path('cucub.pid')

        # before server
        #driver = Driver.instance
        #core = Antir::Core.instance
        #core.oid = 1
        servolux = Cucub::Server::Servolux.new('Cucub', :logger => logger, :pid_file => pid_file)
        servolux.server_opts = opts # opts are passed raw to the servolux. They are read by a Cucub::Server instance.

        boot_file = "./#{boot_file}" unless boot_file.match(/^[\/.]/)
        require boot_file

        # after server

        servolux.startup
      end

      def help(cli = nil)
        puts "ping"
      end
    end
  end
end
