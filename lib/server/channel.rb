module Cucub
  class Server
    class Channel
      
      def initialize(kind)
        @kind = kind
        case @kind
          when :box
            box_start
          when :inner_inbound
            inner_inbound_start
          when :inner_outbound
            inner_outbound_start
        end
      end

      def box_start
        # Es usado dentro del Reactor
        $stdout.puts "Initializing Outer Inbound (REPLY) socket"
        @socket = PanZMQ::Reply.new
        @socket.bind("tcp://#{Cucub::Server.instance.address}:6441")
        @socket.register

        # TODO Do this setting on Dispatcher ?
        # TODO Decouple into a Different handler: OuterInboundRouting
        @socket.on_receive { |msg|
          # Chequear por llamada async / sync

          # Async - returns job id
          #### Cucub::Queue.instance.push(msg)
          
          # TODO Sync - returns object return
          # Usar EM Defer
          #Cucub::LiveObject.pass(msg)

          message = Cucub::Message.parse(msg)
          puts "received@server msg to: #{message.header.to.class_name}"
          # TODO check why this class_name is in capitals and the configurations.classes are in downcase
          destination = Cucub::Dispatcher.instance.router.random_with_least_assignments(message.header.to.class_name.downcase, Cucub::Server.instance.stats_collector.vm_stats)

          # TODO Route messages according class_name and object_uuid

          Cucub::Server::Channel.inner_inbound.send_string("#{destination.klass}##{destination.uid} #{msg}")
          Cucub::Server.instance.stats_collector.sent_msg_to(destination.uid, destination.klass, message.uuid)

          @socket.send_string("Cucub::Reply ok!")
        }

        @socket
      end

      def inner_inbound_start
        # a ZMQ PUSH-PULL socket which binds to the local server as a 'pusher',
        #   so workers connect to it in a 1-N way to consume messages.

        # It works by setting up an IPC socket. In a future, it might be considered to
        #   enable tcp communication, so workers can be outside the local server.

        $stdout.puts "Initializing Inner Inbound (PUSH) socket"
        @socket = PanZMQ::Broadcast.new
        @socket.bind "ipc:///tmp/cucub-inner-inbound.sock"
        @socket
      end

      def inner_outbound_start
        # a ZMQ PUSH-PULL socket which binds to the local server as a 'puller',
        #   so workers connect to it in a 1-N way to push their messages.
        
        # It works by setting up an IPC socket. In a future, it might be considered to
        #   enable tcp communication, so workers can be outside the local server.

        $stdout.puts "Initializing Inner Outbound (PULL) socket"
        @socket = PanZMQ::Pull.new
        @socket.bind "ipc:///tmp/cucub-inner-outbound.sock"
        @socket.register
        @socket.on_receive {|msg|
          message = Cucub::Message.parse(msg)
          puts "Received @inner_outbound@server: #{message.inspect}"
          case message.header.to.layer
            when :server
              message.unlock(:inner_outbound)
              case message.body.action
                when "register"
                  Cucub::Server.instance.register_vm(message.body.additionals)
                when "ready"
                  puts "READY: #{message.inspect}"
                  
                  message.body.additionals.each do |done_uuid|
                    Cucub::Server.instance.stats_collector.mark_done(message.header.from.object_uuid, Cucub::Server.instance.stats_collector.class_for_msg(done_uuid), done_uuid)
                  end

                  puts "STATS: #{Cucub::Server.instance.stats_collector.vm_stats}"
              end
          end

          # Cucub::Server.instance.register_vm()
        }
        @socket
      end

      def self.box
        return @@box if defined?(@@box) and @@box.is_a? Cucub::Server::Channel

        @@box = Cucub::Server::Channel.new(:box)
      end
      
      def self.inner_inbound
        return @@inner_inbound if defined?(@@inner_inbound) and @@inner_inbound.is_a? Cucub::Server::Channel

        @@inner_inbound = Cucub::Server::Channel.new(:inner_inbound)
      end

      def self.inner_outbound
        return @@inner_outbound if defined?(@@inner_outbound) and @@inner_outbound.is_a? Cucub::Server::Channel

        @@inner_outbound = Cucub::Server::Channel.new(:inner_outbound)
      end

      def self.channels
        channels = []
        channels << @@box if defined?(@@box)
        channels << @@inner_inbound if defined?(@@inner_inbound)
        channels << @@inner_outbound if defined?(@@inner_outbound)
        channels
      end

      def send_string(msg)
        @socket.send_string(msg)
      end

####
=begin
    def self.local_push
      return @local_push if @local_push.is_a? Cucub::LiveProxy
      @local_push = Cucub::LiveProxy.new
      @local_push.channel = :local_push
      @local_push.connect(Cucub.address)
      @local_push.engage

      @local_push
    end
=end

#### # Reemplazar por broadcast para intercomunicar status updates !
=begin
    def self.ipc_set
      # Es usado por un LiveProxy (dentro del Worker), para actualizar la info de conexion dentro del Reactor
      return @ipc_set if @ipc_set.is_a? MaZMQ::Request
      @ipc_set = MaZMQ::Request.new
      @ipc_set.connect(:ipc, '/tmp/cucub.sock')

      @ipc_set
    end

    def self.ipc_get
      # Es usado dentro del Reactor

      return @ipc_get if @ipc_get.is_a? MaZMQ::Reply
      @ipc_get = MaZMQ::Reply.new
      @ipc_get.bind(:ipc, '/tmp/cucub.sock')
     
      @ipc_get.on_read { |msg|
        msg = JSON.parse(msg)
        proxy = Cucub::LiveProxy.select(msg['oid'])
        proxy.send(msg['action'], *msg['params'])
        @ipc_get.send_string 'Cucub ipc ok!'
      }

      @ipc_get
    end
=end
      def close
        @socket.close
      end

      def self.shutdown!
        @@box.close if defined?(@@box)

        @@inner_inbound.close if defined?(@@inner_inbound)

        @@inner_outbound.close if defined?(@@inner_outbound)
      
        PanZMQ.terminate
      end
    end
  end
end
