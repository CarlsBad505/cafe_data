require 'test_helper'

class PostalCodeViewTest < ActiveSupport::TestCase

  def setup
    @cafes_by_postal_code = PostalCodeView.all
  end

  test "chairs percentages should add to 100%" do
    assert_equal 100, @cafes_by_postal_code.sum('chairs_pct')
  end

end
