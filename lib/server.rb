require 'singleton'
require_relative './server/configuration'

module Cucub
  class Server
    include Singleton

    attr_reader :stats_collector

    def initialize
      @dispatcher = Cucub::Dispatcher.instance
      @stats_collector = Cucub::StatsCollector.new
    end

    def start!(server_opts={})
      @address = server_opts[:host]
      @config_filepath = server_opts[:config]
      @dispatcher.start
    end

    def shutdown!
      @dispatcher.stop
    end

    def address
      @address
    end

    def register_vm(params)
      puts "REGISTER_VM: #{params}"
      uid, klass = params

      vm = OpenStruct.new
      vm.uid = uid
      vm.klass = klass.underscore

      # @vm_manager.register_vm(vm)
      @stats_collector.register_vm(vm)
      puts "registered: #{uid} #{klass}"
    end

    def config_filepath
      @config_filepath
    end
  end
  
  #def self.initialize(&block)
  #  @@server.initialize_block = block
  #end

  #def self.run(&block)
  #  @@server.run_block = block
  #end

  #@@server = nil
  #def self.server(*args)
  #  return @@server if @@server.is_a? Cucub::Server
  #  @@server = Cucub::Server.new(*args)
  #  @@server
  #end

=begin
  This has been moved to the lib/server/servolux.rb handler class
  class Server < Servolux::Server
    # attr_accessor :host

    # I guess this will stay deprecated
    #def run_block=(block)
    #  @run_block = block
    #end

    #
    #def run
    #  #Cucub.init
    #  Cucub.start!(@host, @run_block)
    #  Process.waitall
    #end

    #def prefork
    #  #workers_pool = Servolux::Pre
    #end

    #def before_stopping
    #  Cucub.shutdown!
    #end
  end
=end
end
