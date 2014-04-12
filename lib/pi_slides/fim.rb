require 'socket'

module PiSlides
  class Fim

    def initialize(options = {})
      @mutex = Mutex.new
      options = {
        :host => 'localhost', :port => 9999
      }.merge options
      @host = options[:host]
      @port = options[:port]
    end

    # pushes the file, displays it and removes it from the list immediately
    # shows and pops the next file from the list if path.nil?
    def show(path=nil)
      exec %{#{"push '#{path}';" if path}next;pop;}
    end

    # turn status line on/off
    def status_line(switch_on = true)
      if switch_on
        set_vars :_display_busy => 1, :_display_status => 1
      else # switch off
        set_vars :_display_busy => 0, :_display_status => 0
      end
    end

    def toggle_autowidth
      exec 'autowidth=1-autowidth;'
    end

    def push(*files)
      exec files.map{|f| "push '#{f}';"}.join + "prefetch;"
    end

    def set_vars(vars = {})
      exec vars.to_a.map{|name, value| %{#{name}=#{value};}}.join
    end

    def exec(cmd)
      @mutex.synchronize do
        TCPSocket.open(@host, @port).tap do |s|
          s << cmd
          s.close
        end
      end
    rescue
      # this happens from time to time when fim is busy
      PiSlides.debug "error sending command, will retry in 1s"
      PiSlides.debug "host=#{@host} port=#{@port} cmd=#{cmd}"
      PiSlides.debug $!
      #PiSlides.debug $!.backtrace.join "\n"
      sleep 1
      retry
    end
  end

end
