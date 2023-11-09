# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name = 'birthday-calculator'
  gem.version = '0.1.0'
  gem.license = 'MIT'
  gem.summary = 'Birthday Calculator'
  gem.description = 'Birthday Calculator'
  gem.authors = ['Anton Kozik']
  gem.email = 'pazitron@gmail.com'
  gem.add_dependency 'sinatra', '~> 3.1'
  gem.add_development_dependency 'ruboto', '~> 1.6'
  gem.files = Dir['birthday_calculator.rb', 'birthday_calculator_app.rb', 'birthday_calculator.gemspec']
end
