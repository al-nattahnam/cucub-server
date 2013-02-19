module Cucub
  class Router
    def random_with_least_assignments(klass, stats)
      least_assigned = stats[klass].collect {|vm| vm.assigned}.min
      vms = stats[klass].select {|vm| vm.assigned == least_assigned}
      vm = vms[rand(vms.length)]
      puts "random: #{vm}"
      vm
    
    end
  end
end
