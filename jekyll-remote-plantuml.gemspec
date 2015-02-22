lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
    s.name        = 'jekyll-remote-plantuml'
    s.version     = '0.1.0'
    s.date        = '2015-02-20'
    s.summary     = "Jekyll remote plantuml"
    s.description = "Jekyll to use plantuml with remote provider without any local plantuml.jar installation"
    s.authors     = ["Patouche"]
    s.email       = 'patralla@gmail.com'
    s.homepage    = 'http://rubygems.org/gems/jekyll-remote-plantuml'

    s.files       = Dir['lib/*.rb']

    s.license       = 'MIT'
    s.require_path = "lib"

    s.add_runtime_dependency('jekyll', '>= 0.11.2')

    s.add_development_dependency('rake', ["~> 0"])
    s.add_development_dependency('minitest', ["~> 0"])
end
