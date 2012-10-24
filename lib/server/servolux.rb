require 'servolux'
require 'logger'

module Cucub
  class Server
    class Servolux < Servolux::Server
      attr_accessor :server_opts
      
      def run
        Cucub::Server.instance.start!(@server_opts)
        Process.waitall
      end

      def prefork
      end

      def before_stopping
        Cucub::Server.instance.shutdown!
      end
    end
  end
end

# TODO implement Servolux running as a Daemon
# daemon = Servolux::Daemon.new(:server => server)
# daemon.startup
# daemon.shutdown
#Cucub.start!('10.0.0.4')
