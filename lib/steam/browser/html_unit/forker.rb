module Steam
  class Forker
    attr_reader :options

    def initialize(options = {}, &block)
      options = { 
        :pid    => '/tmp/steam.pid',
        :stdin  => $stdin, 
        :stdout => $stdout, 
        :stderr => $stderr 
      }.merge(options)

      @pid = Kernel.fork do 
        STDIN.reopen  options[:stdin]
        STDOUT.reopen options[:stdout]
        STDERR.reopen options[:stderr]
        block.call
      end
      # write_pid
      at_exit { kill }
    end

    def interrupt
      kill('INT')
    end

    def kill(signal = 'TERM')
      if running?
        Process.kill(Signal.list[signal], @pid)
        delete_pid
        true
      end
    end

    def running?
      @pid ? !!Process.getpgid(@pid) : false
    rescue Errno::ESRCH
      false
    end

    protected

      def write_pid
        ::File.open('/tmp/steam.pid', 'w'){ |f| f.write("#{@pid}") }
      end

      def delete_pid
        ::File.delete('/tmp/steam.pid') rescue Errno::ENOENT
      end
  end
end