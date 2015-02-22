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

# Remote loader to retrieve binary or text file from remote url
# depending of the parameters provide and the method use
#

require 'digest'
require 'fileutils'
require 'jekyll';

require 'plantuml-config'

class RemoteLoader

    # Initialization of the loaded dir
    def initialize()
        conf = Jekyll.configuration({});
        prefixUrl = PlantUmlConfig::DEFAULT[:binaries]
        dirname = conf['destination'] + File::SEPARATOR + prefixUrl;
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end
        @prefixUrl = prefixUrl;
        @dirname = dirname;
    end

    # Internal : get the url from a config
    #
    # @param params the parameters to build the url
    # Returns the url for remote to retrieve
    def createUri(params)
        url = params[:url]
        url = url.gsub(/\{code\}/, params[:code])
        url = url.gsub(/\{type\}/, params[:type])
        return url;
    end

    # Public : get the url from a config
    #
    # @param params { :url, :code, :type }
    # Returns the path of the file saved
    def savedRemoteBinary(params)
        require 'open-uri'
        uri = createUri(params);
        suffix = Digest::SHA256.hexdigest(uri) + "." + params[:type]
        fileName = @dirname + File::SEPARATOR + suffix;
        unless File.exist?(fileName) then
            open(fileName, 'wb') do |file|
                file << open(uri).read
                Jekyll.logger.debug "Download of %{uri} done %{data} " % { :uri => uri, :data => file };
            end
        end
        return { :uri => @prefixUrl + "/" + suffix, :path => fileName };
    end

    def loadText(params)

    end

end