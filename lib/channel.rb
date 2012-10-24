module Cucub
  module Channel
=begin
    def self.initialize
      Cucub::Channel.local_push
    end
=end

    def self.reply
      # Es usado dentro del Reactor
      return @reply if @reply.is_a? MaZMQ::Reply
      @reply = MaZMQ::Reply.new
      @reply.bind(:tcp, Cucub.address, 6441)

      @reply.on_read { |msg|
        # Chequear por llamada async / sync

        # Async - returns job id
        #### Cucub::Queue.instance.push(msg)
        
        # TODO Sync - returns object return
        # Usar EM Defer
        #Cucub::LiveObject.pass(msg)

        @reply.send_string("Cucub::Reply ok!")
      }

      @reply
    end

    ### Right now, and in earlier versions, cucub-server will support only REPLY socket for inbound.
=begin
    def self.pull
      # Es usado dentro del Reactor
      return @pull if @pull.is_a? MaZMQ::Pull
      @pull = MaZMQ::Pull.new
      @pull.bind(:tcp, Cucub.address, 6442)

####
      @pull.on_read { |msg|
        Cucub::Queue.instance.push(msg)
      }

      @pull
    end
=end

    def self.inner_inbound
      # a ZMQ PUSH-PULL socket which binds to the local server as a 'pusher',
      #   so workers connect to it in a 1-N way to consume messages.

      # It works by setting up an IPC socket. In a future, it might be considered to
      #   enable tcp communication, so workers can be outside the local server.

      return @inner_inbound if @inner_inbound.is_a? MaZMQ::Push.new
      @inner_inbound = MaZMQ::Push.new
      @inner_inbound.bind :ipc, "/tmp/cucub-inner-inbound.sock"
    end

    def self.inner_outbound
      # a ZMQ PUSH-PULL socket which binds to the local server as a 'puller',
      #   so workers connect to it in a 1-N way to push their messages.
      
      # It works by setting up an IPC socket. In a future, it might be considered to
      #   enable tcp communication, so workers can be outside the local server.

      return @inner_outbound if @inner_outbound.is_a? MaZMQ::Pull.new
      @inner_outbound = MaZMQ::Pull.new
      @inner_outbound.bind :ipc, "/tmp/cucub-inner-outbound.sock"
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

    def self.shutdown!
      if @reply
        puts 'Closing reply channel.'
        @reply.close
      end

      if @pull
        puts 'Closing pull channel.'
        @pull.close
      end

=begin
      if @local_push
        puts 'Closing local_push channel.'
        @local_push.shutdown!
      end

      if @ipc_get
        puts 'Closing ipc_get channel.'
        @ipc_get.close
      end

      if @ipc_set
        puts 'Closing ipc_set channel.'
        @ipc_set.close
      end
=end
      
      MaZMQ.terminate
    end
  end
end
