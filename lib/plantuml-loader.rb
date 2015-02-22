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

require 'singleton'
require 'open-uri'
require 'plantuml-config'

# Load data from a remote url.

#
# data is loaded once time. If we can found data in cache, just use
# the cache instead of making lot of remote call.
class RemoteLoader
    include Singleton

    # Callback for plain text content
    CONTENT_CALLBACKS = {
        'svg' => { :matcher => /\<\?xml.*?\>/, :replacement => '' }
    }

    # Initialization of the loaded dir
    #
    # Define the constant for the prefix url for binary file
    # and the directory where all file will be saved
    def initialize()
        conf = Jekyll.configuration({});
        pconf = PlantUmlConfig::DEFAULT.merge(conf['plantuml'] || {});
        dirname = conf['source'] + File::SEPARATOR + pconf[:binaries].gsub(/\//, File::SEPARATOR).sub(/\/*$/, '').sub(/^\/*/, '');
        Jekyll.logger.info "Directory for storage remote data : %s" % [dirname],
        unless File.directory?(dirname) then
            Jekyll.logger.info "Create directory %s because this seems to be missing" % [dirname]
            FileUtils.mkdir_p(dirname)
        end
        @prefixUrl = pconf[:binaries];
        @dirname = dirname;
    end

    # Internal : get the url from a config
    #
    # @param a hash with {:url, :code, :type } inside it
    # Returns the url for remote to retrieve
    def createRemoteUri(params)
        uri = params[:url];
        uri = uri.gsub(/\{code\}/, params[:code])
        uri = uri.gsub(/\{type\}/,  params[:type])
        return uri;
    end

    # Internal : get the data for the remote connection
    #
    # @param a hash with {:url, :code, :type } inside it
    # Returns the data as a hash
    def getData(params)
        ruri = createRemoteUri(params);
        fn = Digest::SHA256.hexdigest(ruri) + "." + params[:type]
        return { :remoteUri => ruri, :uri  => @prefixUrl + fn, :path => @dirname + File::SEPARATOR + fn }
    end

    # Public : get and saved the remote uri from a parameters hash
    # if the same content has already been downloaded previously,
    # just retrieve return the file information.
    #
    # @param a hash with {:url, :code, :type } inside it
    # Returns a hash with { :remoteUri, :uri, :path }
    def savedRemoteBinary(params)
        Jekyll.logger.debug "Plantuml remote loader params :", params;
        data = getData(params);
        unless File.exist?(data[:path]) then
            Jekyll.logger.info "Starting download content at %{remoteUri} done into file %{path}." % data;
            open(data[:path], 'wb') do |file|
                file << open(data[:remoteUri]).read
                Jekyll.logger.info "End download content at %{remoteUri} done into file %{path}." % data;
            end
        else
            Jekyll.logger.info "File %{path} has been found. Not download at %{remoteUri} will be made." % data;
        end
        return data;
    end

    # Public : get and saved the remote uri from a parameters hash
    # if the same content has already been downloaded previously,
    # just return the file content.
    #
    # @param a hash with {:url, :code, :type } inside it
    # Returns the content of the remote
    def loadText(params)
        d = savedRemoteBinary(params);
        content = File.read(d[:path]);
        tc = CONTENT_CALLBACKS[params[:type].downcase];
        if tc then
            content = content.gsub(tc[:matcher], tc[:replacement]);
        end
        return content;
    end

end