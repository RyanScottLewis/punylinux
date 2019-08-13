module Helpers
  module Build

    def make(task=nil, env={})
      env = env.map { |k, v| [k, v].join(?=) }

      command = ['make'] + env
      command << (task || "-j`nproc`")
      command = command.join(' ')

      sh command
    end

  end

  include Build
end

