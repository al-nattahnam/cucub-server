#require './request_channel_test'

#e = Engine.new

Cucub.run {
  #e.start
  
  1000.times {|i|
    puts "i"
  }
}
