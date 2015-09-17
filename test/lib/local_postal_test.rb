require 'test_helper'

class LocalPostalTest < Minitest::Test
  def test_root
    assert_kind_of String, LocalPostal.root
  end
end
