module Helpers
  module Build

    def make(task=nil)
      command = ['make']
      command << (task || "-j`nproc`")
      command = command.join(' ')

      sh command
    end

  end

  include Build
end

