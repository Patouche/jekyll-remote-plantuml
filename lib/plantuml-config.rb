# Config for plantuml plugin.

require 'singleton';

class PlantUmlConfig
    include Singleton

    DEFAULT = {
        :binaries => 'binaries',
        :type =>  'png',
        :encode => 'encode64',
        :url =>' http://www.plantuml.com/plantuml/{type}/{code}'
    }

end
