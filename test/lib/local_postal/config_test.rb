require 'test_helper'

class LocalPostal::ConfigTest < Minitest::Test
  def test_load_yaml
    assert_kind_of Array, LocalPostal::Config.load_yaml(:city_line_formatting)
  end
end
