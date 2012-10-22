require 'spec_helper'

describe Cucub::Configuration do
  describe "#uses" do
    subject { Cucub::Configuration.instance }
    context "when parsing a valid config" do
      #before { subject.set_path(@filepath + "/mock/protocol.ini") }
      it { subject.uses.should be_a Array }
    end

=begin
    it "should return a valid SpecificationSet" do
      @loader = Cucub::Protocol::Loader.instance
      @loader.set_path(@filepath + "/mock/protocol.ini")
      specification_set = @loader.parse
      specification_set.object_specifications.each {|obj_spec|
        puts "object: #{obj_spec.class_name}"
        puts "serialize: #{obj_spec.serialize}"
        obj_spec.action_specifications.each {|act|
          puts "\taction: #{act.action_name}"
          puts "\tserialize: #{act.serialize}"
        }
        puts "\n"
        #puts obj_spec.inspect
      }
    end
=end
    
=begin
    it "should return a valid SpecificationSet" do
      @loader = Cucub::Protocol::Loader.instance
      @loader.set_path(@filepath + "/mock/protocol.ini")
      specification_set = @loader.parse
      specification_set.object_specifications.each {|obj_spec|
        puts "object: #{obj_spec.class_name}"
        puts "uses box: #{obj_spec.uses_box}"
        puts "uses mailbox: #{obj_spec.uses_mailbox}"
        puts "uses board: #{obj_spec.uses_board}"
        obj_spec.action_specifications.each {|act|
          puts "\taction: #{act.action_name}"
          puts "\tuses box: #{act.uses_box}"
          puts "\tuses mailbox: #{act.uses_mailbox}"
          puts "\tuses board: #{act.uses_board}"
        }
        puts "\n"
        #puts obj_spec.inspect
      }
    end
=end
  end
end
