module Cucub
  class StatsCollector
    #include Singleton
    
    def initialize
      @stats = { :vm_stats => {}, :server_stats => {:sent => 0} }
      @pending = { }
    end
  
    def register_vm(vm)
      vm.assigned = 0
      vm.done = 0
      @stats[:vm_stats][vm.klass] ||= []
      @stats[:vm_stats][vm.klass] << vm

      @pending[vm.klass] = []
    end
  
    def sent_msg_to(uid, klass, msg_uuid)
      vm = @stats[:vm_stats][klass].select {|v| v.uid == uid}[0]
      vm.assigned += 1
  
      @stats[:server_stats][:sent] += 1

      @pending[klass] << msg_uuid
    end

    def class_for_msg(msg_uuid)
      @pending.select{|key, value| value.include?(msg_uuid)}.keys[0].underscore
    end
  
    def sent_messages
      @stats[:server_stats][:sent]
    end
  
    def mark_done(uid, klass, msg_uuid)
      vm = @stats[:vm_stats][klass].select {|v| v.uid == uid}[0]
      vm.done += 1
      vm.assigned -= 1
      puts "#{vm.klass} #{uid}: #{vm.assigned} assigned; #{vm.done} done"
      
      @pending.select{|key, value| value.include?(msg_uuid)}.values[0].delete(msg_uuid)
      puts "pending_for: #{@pending}"
    end
  
    def vm_stats
      @stats[:vm_stats]
    end
  end
end
