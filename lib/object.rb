#require 'em-jack'
#require 'json'

require 'channel'
require 'dispatcher'
#require 'queue'
#require 'live_object'
#require 'live_proxy'

#require 'worker'
#require 'proxy_queue'
#require 'proxy_worker'

module Cucub
  @@dispatcher = Cucub::Dispatcher.instance
#####
=begin
  @@in_worker = false
=end

  def self.start!(address, block=Proc.new({}))
    @@address = address
    #### Cucub::Channel.initialize

    # refactor !
    # separar este codigo en init y start (?)
    # mover codigo a cucub-server (?)
#####
=begin
    workers_pool = Servolux::Prefork.new(:module => Cucub::Worker)
    workers_pool.start 1
    trap("INT") {
      workers_pool.signal "INT"
      workers_pool.reap
      Cucub.shutdown!
      exit
    }
=end
    @@dispatcher.start(block)
  end

  def self.shutdown!
    @@dispatcher.stop
  end

  def self.address
    @@address
  end

#####
=begin
  def self.in_worker
    @@in_worker = true
  end

  def self.in_worker?
    @@in_worker
  end
=end
end
