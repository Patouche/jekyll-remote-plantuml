require 'minitest/autorun'
require 'plantuml-loader'
require 'plantuml-config'
require 'jekyll'

class RemoteLoaderTest < Minitest::Test

    GENERATION_FOLDER = PlantUmlConfig::DEFAULT[:assets].sub(/^\/*/, '');

    ROOT_FOLDER = GENERATION_FOLDER.sub(/^([^\/]+).*$/, '\1');

    GENERATED = "assets/images/plantuml/1fc2071adfcf94c83cb527ea98c29cae1656a085ff72acb12db7518fe93f1869.png";

    def setup
        Jekyll.logger.log_level = :debug
        d = d = Jekyll.configuration({})['source'] + File::SEPARATOR + GENERATION_FOLDER;
        if !File.exist?(d) then
            FileUtils.mkdir_p(d);
        end
    end

    def teardown
        d = Jekyll.configuration({})['source'] + File::SEPARATOR + ROOT_FOLDER;
        if File.exist?(d) then
            FileUtils.remove_dir(d);
        end
    end

    def test_createUri
        params = { :url => "http://someurl.com/{type}/{code}", :type => "inputType", :code => "inputCode" };
        assert_equal "http://someurl.com/inputType/inputCode", RemoteLoader.instance.createRemoteUri(params), "uri generation";
    end

    def test_savedRemoteBinary_checkDownload
        #skip('Remote connection made')
        params = { :url => "http://www.plantuml.com/plantuml/{type}/{code}", :type => "png", :code => "SyfFKj2rKt3CoKnELR1Io4ZDoSa70000" };

        obj = RemoteLoader.instance.savedRemoteBinary(params);
        assert_equal GENERATED, obj[:uri], "file created with defined hash";
        assert File.exist?(obj[:path]), "file exist";
    end

    def test_savedRemoteBinary_downloadOnlyOnce
        #skip('Remote connection made')
        params = { :url => "http://www.plantuml.com/plantuml/{type}/{code}", :type => "png", :code => "SyfFKj2rKt3CoKnELR1Io4ZDoSa70000" };

        obj =  RemoteLoader.instance.savedRemoteBinary(params);
        assert_equal GENERATED, obj[:uri], "file created with defined hash";;
        assert File.exist?(obj[:path]), "file exist";;
        mtime = File.mtime(obj[:path]);

        obj2 =  RemoteLoader.instance.savedRemoteBinary(params);
        assert_equal mtime, File.mtime(obj2[:path]), "file not modified";;
    end

    def test_loadText
        #skip('Remote connection made')
        params = { :url => "http://www.plantuml.com/plantuml/{type}/{code}", :type => "svg", :code => "SyfFKj2rKt3CoKnELR1Io4ZDoSa70000" };

        content = RemoteLoader.instance.loadText(params);
        refute_nil content, "retrieve content must not be null";
        assert_match /^\<svg/, content, "start with svg tag";
        assert_match /<\/svg>$/, content, "end with svg tag";
    end

end
