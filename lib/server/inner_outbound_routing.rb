module Cucub
  class Server
    class InnerOutboundRouting
      def self.handle(socket)
        socket.on_receive do |msg|
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
        end
      end
    end
  end
end
