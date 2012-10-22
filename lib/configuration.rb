require 'singleton'

module Cucub
  class Configuration
    include Singleton

    def initialize
      @loader = Cucub::Protocol::Loader.instance
      set_config_file
      reload
    end

    def set_config_file
      @loader.set_path("./config/protocol.ini")
    end

    def reload
      @specification_set = @loader.parse
      @uses = nil
    end

    def uses
      # lazy load array of uses
      return @uses if @uses
      uses = []
      uses << "box" if @specification_set.uses_box
      uses << "mailbox" if @specification_set.uses_mailbox
      uses << "board" if @specification_set.uses_board
      @uses = uses
    end
  end
end
