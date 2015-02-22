lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
    s.name        = 'jekyll-remote-plantuml'
    s.version     = '0.0.1'
    s.date        = '2015-02-20'
    s.summary     = "Jekyll remote plantuml"
    s.description = "Jekyll to use plantuml with remote provider without any local plantuml.jar installation"
    s.authors     = ["Patouche"]
    s.email       = 'patralla@gmail.com'
    s.files       = ["lib/jekyll-remote-plantuml.rb"]
    s.homepage    = 'http://rubygems.org/gems/jekyll-remote-plantuml'
    s.add_runtime_dependency('jekyll', ["~> 0.10"])
    s.add_runtime_dependency('less', ["~> 2.0"])
    s.license       = 'MIT'
end
