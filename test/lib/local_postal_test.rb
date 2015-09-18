require 'test_helper'

class LocalPostalTest < Minitest::Test
  def test_root
    assert File.file?(File.join(LocalPostal.root, 'local_postal.gemspec'))
  end
end
