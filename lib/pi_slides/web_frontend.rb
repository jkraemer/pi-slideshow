require 'sinatra/base'

module PiSlides
  class WebFrontend < Sinatra::Base

    set :root, File.expand_path('../../..', __FILE__)
    set :run, true
    set :bind, '0.0.0.0'
    set :server, :puma

    post '/' do
      @slideshow = $slideshow
      case params[:user_action]
      when 'interval'
        if (interval = params[:interval].to_i) > 0
          $slideshow.interval = interval
        end
      when 'autoplay'
        case params[:autoplay]
        when 'on'
          $slideshow.play
        when 'off'
          $slideshow.pause
        end
      else
        if params[:next]
          $slideshow.next
        elsif params[:toggle_autowidth]
          $slideshow.fim.toggle_autowidth
        end
      end

      erb :index, :layout => !request.xhr?
    end

    get '/' do
      @slideshow = $slideshow
      erb :index, :layout => !request.xhr?
    end

    configure do
      use Rack::CommonLogger unless PiSlides.logger.level > 1
    end
  end
end

