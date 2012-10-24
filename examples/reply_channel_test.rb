#require 'rubygems'
#require 'cucub-object'

class Core
  #include Cucub::LiveObject

  #live :channel, :reply

  def state(i)
    puts "--ack--"
    sleep(i)
    puts "Hola! #{i}"
  end
end

#core = Core.new
#core.oid = 1

#Cucub.start!('10.0.0.5', Proc.new {})
