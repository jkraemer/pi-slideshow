require 'logger'

require 'pi_slides/fim'
require 'pi_slides/image_dir'
require 'pi_slides/slideshow'

module PiSlides

  class << self

    def logger
      @logger ||= (STDOUT.sync = true; Logger.new(STDOUT))
    end

    %w(debug info error).each do |m|
      define_method m do |msg|
        logger.send m, msg
      end
    end

  end

end
