require 'singleton'
require 'ma-zmq'

module Cucub
  class Dispatcher
    include Singleton

    def initialize
      #@load_balancer = nil
    end

    def start(block=nil)
      block ||= Proc.new {}
      EM.epoll
      EM.run do
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
        if Cucub::Configuration.uses.include? ("box")
          @box = Cucub::Channel.reply
        end

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
      end
    end

    def stop
      #### Cucub::LiveProxy.shutdown!
      Cucub::Channel.shutdown!
      EM.stop
    end
  end
end
