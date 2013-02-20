require 'singleton'
require 'pan-zmq'

module Cucub
  class Dispatcher
    include Singleton

    def initialize
      #@load_balancer = nil
      @router = Cucub::Router.new
    end

    def router
      # TODO provisory
      @router
    end

    def start(block=nil)
      block ||= Proc.new {}
      
      self.init_inner_channels
      
      #### @proxy_worker = Cucub::ProxyWorker::connection

      ## TODO if list.size == 1 => oid unico

####
=begin
      Cucub::LiveObject.list.each do |obj|
        case obj.class.channel
          when :reply
            @reply = Cucub::Channel.reply
          when :pull
            @pull = Cucub::Channel.pull
          when :subscribe
            puts '?'
        end
      end
      @ipc_get = Cucub::Channel.ipc_get
=end

      @box = Cucub::Server::Channel.box
      Cucub::Server::OuterInboundRouting.handle(@box)

####
=begin
      Cucub::LiveProxy.list.each do |proxy|
        proxy.engage
      end
=end

####
=begin
      @proxy_worker.each_job { |job|
        if Cucub::LiveProxy.list.size > 0
          msg = job.body
          oid, channel = Cucub::ProxyWorker.read_oid(msg)
          if channel == nil
            proxy = Cucub::LiveProxy.select(oid)
          else
            proxy = Cucub::Channel.local_push
          end

          if proxy
            if proxy.do(msg)
              job.delete
            else
              job.release
            end
          end
        end
      }
=end

      block.call
      
      PanZMQ::Poller.instance.poll
    end

    def init_inner_channels
      @inner_inbound = Cucub::Server::Channel.inner_inbound
      @inner_outbound = Cucub::Server::Channel.inner_outbound
    end

    def stop
      #### Cucub::LiveProxy.shutdown!
      Cucub::Server::Channel.shutdown!
    end
  end
end
