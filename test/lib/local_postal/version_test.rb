require 'test_helper'

class LocalPostal::VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_kind_of String, LocalPostal::VERSION
  end
end
