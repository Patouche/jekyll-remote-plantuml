# The MIT License (MIT)
#
# Copyright (c) 2015 Patrick Allain
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'jekyll'
require 'plantuml-config'
require 'plantuml-encode64'
require 'plantuml-loader'

#

# Jekyll plugin for plantuml generation
#
# Any generation is store localy to prevent any further call
# on a remote provider.
module Jekyll

    class PlantUmlBlock < Liquid::Block

        # Plugin initilializer
        def initialize(tag_name, markup, tokens)
            super
            @markup = markup;
        end

        # Render
        def render(context)
            output = super(context);
            code, pconf, baseurl = PlantUmlEncode64.new(output).encode(), PlantUmlConfig::DEFAULT, Jekyll.configuration({})['baseurl'];
            p = {:url => pconf[:url], :type => pconf[:type], :code => code }
            Jekyll.logger.debug "Generate html with input params  :", p;
            d = RemoteLoader.instance.savedRemoteBinary(p);
            return "<img src=\"%{baseurl}%{uri}\" />" % d.merge({ :baseurl => baseurl });
        end

    end
end

Liquid::Template.register_tag('uml', Jekyll::PlantUmlBlock)
