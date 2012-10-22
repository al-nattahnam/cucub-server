#require 'singleton'

require 'servolux'
require 'logger'

module Cucub
  #def self.initialize(&block)
  #  @@server.initialize_block = block
  #end

  def self.run(&block)
    @@server.run_block = block
  end

  @@server = nil
  def self.server(*args)
    return @@server if @@server.is_a? Cucub::Server
    @@server = Cucub::Server.new(*args)
    @@server
  end

  class Server < Servolux::Server
    attr_accessor :host

    def run_block=(block)
      @run_block = block
    end

    def run
      #Cucub.init
      Cucub.start!(@host, @run_block)
      Process.waitall
    end

    def prefork
      #workers_pool = Servolux::Pre
    end

    def before_stopping
      Cucub.shutdown!
    end
  end
end

# daemon = Servolux::Daemon.new(:server => server)
# daemon.startup
# daemon.shutdown
#Cucub.start!('10.0.0.4')
