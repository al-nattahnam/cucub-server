module Cucub
  class Server
    class OuterInboundRouting
      def self.handle(socket)
        socket.on_receive do |msg|
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

          socket.send_string("Cucub::Reply ok!")
        end
        
      end
    end
  end
end
