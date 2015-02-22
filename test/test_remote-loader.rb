require 'minitest/autorun'
require 'remote-loader'
require 'jekyll'

class RemoteLoaderTest < Minitest::Test

    def setup
        Jekyll.logger.log_level = :debug
    end

    def teardown
        d = Jekyll.configuration({})['destination']
        if File.exist?(d) then
            FileUtils.remove_dir(d);
        end
    end

    def test_createUri
        params = { :url => "http://someurl.com/{type}/{code}", :type => "inputType", :code => "inputCode" };
        assert_equal "http://someurl.com/inputType/inputCode", RemoteLoader.new().createUri(params)
    end

    def test_savedRemoteBinary
        skip('Remote connection made')
        params = { :url => "http://www.plantuml.com:80/plantuml/png/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000", :type => "png", :code => "code" };
        obj = RemoteLoader.new().savedRemoteBinary(params);
        assert_equal "binaries/bea0138eb3e966db916ada26913368fb5896a92b6e3ef991838ba68153fe14c9.png", obj[:uri]
        assert File.exist?(obj[:path])
    end

    def test_savedRemoteBinary_checkCache
        skip('Remote connection made')
        params = { :url => "http://www.plantuml.com:80/plantuml/png/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000", :type => "png", :code => "code" };

        obj =  RemoteLoader.new().savedRemoteBinary(params);
        assert_equal "binaries/bea0138eb3e966db916ada26913368fb5896a92b6e3ef991838ba68153fe14c9.png", obj[:uri];
        assert File.exist?(obj[:path]);
        mtime = File.mtime(obj[:path]);

        obj2 =  RemoteLoader.new().savedRemoteBinary(params);
        assert_equal mtime, File.mtime(obj2[:path]);
    end

end
