module PiSlides
  class Slideshow
    attr_reader :fim, :interval

    def initialize(image_dir, fim, options = {})
      options = { :interval => 30 }.merge options
      @interval = options[:interval]
      @image_dir = image_dir
      @fim = fim
    end

    # the pause/play/next/paused? methods are called from sinatra and
    # manipulate instance variables that are checked by _run in the background
    # thread.

    def interval=(new_interval)
      if @interval != new_interval
        @interval = new_interval
        self.next
      end
    end

    def pause
      @paused = true
    end

    def play
      @paused = false
    end

    def next
      @skip_to_next = true
    end

    def paused?
      !!@paused
    end

    def running?
      !paused?
    end

    def join
      @thread.join
    end

    def stop
      @stopped = true
    end

    def run
      @thread = Thread.new{ _run }
    end

    private

    def should_exit?
      !!@stopped
    end

    def skip_to_next?
      !!@skip_to_next
    end

    WAIT_INCREMENT = 0.2
    def wait(interval)
      time_spent = 0.0
      while !skip_to_next? && (paused? || time_spent < interval) && !should_exit?
        sleep WAIT_INCREMENT
        time_spent += WAIT_INCREMENT
      end
      @skip_to_next = false
    end

    def _run
      @paused = false
      @skip_to_next = false
      PiSlides.debug "running with #{@image_dir.size} files"
      @fim.status_line false
      loop do
        while f = @image_dir.random_file
          PiSlides.debug f
          @fim.show f
          wait @interval
          return if should_exit?
        end
        @image_dir.reset
      end
    end

  end
end
