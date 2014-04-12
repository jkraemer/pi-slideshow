require File.expand_path("../lib/pi_slides/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pi-slideshow"
  s.version     = PiSlides::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jens Kraemer"]
  s.email       = ["jk@jkraemer.net"]
  s.homepage    = "http://github.com/jkraemer/pi-slideshow"
  s.summary     = "Framebuffer based slideshow app for the Raspberry Pi."
  s.description = "Comes with a handy web interface for your smartphone."

  s.required_rubygems_version = ">= 1.3.6"

  # required for validation
  s.rubyforge_project         = "pi-slideshow"

  # If you have other dependencies, add them here
  s.add_dependency "trollop"
  s.add_dependency "sinatra"
  s.add_dependency "puma"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md", "views/*", "public/*"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["pi-slides"]

end
