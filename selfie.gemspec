require './lib/selfie/version'

Gem::Specification.new do |s|
  s.name        = 'selfie'
  s.version     = Selfie::VERSION
  s.date        = '2013-10-24'
  s.summary     = "Screenshots for your poltegergeist tests"
  s.description = "Selfie takes screenshots of itself, when running your poltergeist tests, little egotistical bastard."
  s.authors     = ["Emile Bosch"]
  s.email       = 'emilebosch@me.com'
  s.files        = Dir.glob('{lib}/**/*') + %w(README.md selfie.gemspec Gemfile)
  s.homepage    = 'https://github.com/emilebosch/selfie'
  s.license     = 'MIT'
end