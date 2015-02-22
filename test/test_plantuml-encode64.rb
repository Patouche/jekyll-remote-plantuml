require 'minitest/autorun'
require 'plantuml-encode64'

class PlantUmlEncode64Test < Minitest::Test

    def setup
        Jekyll.logger.log_level = :debug
    end

    def test_encode_one
        assert_equal "SyfFqhLppCbCJbMmKiX8pSd91m00", PlantUmlEncode64.new("Bob->Alice : hello").encode()
    end

end
