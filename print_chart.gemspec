Gem::Specification.new do |s|
  s.name        = "print_chart"
  s.version     = File.read('VERSION').strip
  s.authors     = ["Jordan Byron"]
  s.email       = ["jordan.byron@gmail.com"]
  s.homepage    = "https://github.com/mission-of-mercy/print_chart"
  s.summary     = "Prints patient charts for the Mission of Mercy Management Application"
  s.description = "Prints patient charts for the Mission of Mercy Management Application"
  s.require_path = "lib"
  s.files = Dir["{lib}/**/*"] +
    %w{Rakefile README.md LICENSE}
  s.test_files = Dir[ "test/*_test.rb" ]

  s.add_dependency "resque", "~> 1.25.2"
  s.add_dependency "rest-client", "~> 1.7.3"

  s.add_development_dependency "bundler"
end
