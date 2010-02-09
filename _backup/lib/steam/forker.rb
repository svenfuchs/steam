module Steam
  class Forker
    attr_reader :pid

    def initialize(&block)
      @pid = Kernel.fork { block.call }
      at_exit { kill }
    end

    def kill(signal = 'TERM')
      Process.kill(Signal.list[signal], @pid) && true if running?
    end

    def interrupt
      kill('INT')
    end

    def running?
      @pid ? !!Process.getpgid(@pid) : false
    rescue Errno::ESRCH
      false
    end
  end
end