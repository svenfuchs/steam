module Steam
  class Process
    attr_reader :pid, :path

    def initialize(path = '/tmp')
      @path = path
      recall_pid
    end

    def pid?
      !!pid
    end

    def running?
      pid? && !!::Process.getpgid(pid)
    rescue Errno::ESRCH
      false
    end

    def fork(options)
      @pid = Kernel.fork { yield }
      write_pid
      # Process.detach(pid) ?
      at_exit { kill } unless options[:keep_alive]
    end

    def kill(signal = 'TERM')
      ::Process.kill(Signal.list[signal], pid)
      delete_pid
      true
    end

    protected

      def recall_pid
        @pid = ::File.read(filename).to_i rescue nil
        delete_pid if pid? && !running?
      end

      def write_pid
        File.open(filename, 'w') { |f| f.write(pid) }
      end

      def delete_pid
        File.delete(filename) rescue Errno::ENOENT
        @pid = nil
      end

      def filename
        "#{path}/steam.pid"
      end
  end
end
