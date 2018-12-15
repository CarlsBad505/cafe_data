require 'test_helper'

class ConcatenateTest < ActiveSupport::TestCase

  test "concatentate category medium or large size to beginning of cafe name as prefix" do
    # Arrange
    @large_cafe = street_cafes(:another_ls1)
    @medium_cafe = street_cafes(:yet_another_ls1)

    # Act
    run_concatenate

    # Assert
    assert_equal "large Brown's Cafe", @large_cafe.name
    assert_equal "medium Ralph's Cafe", @medium_cafe.name
  end


  private

  def run_concatenate
    CafeData::Application.load_tasks
    Rake::Task['concatenate_medium_large_cafes'].invoke
    Rake::Task['concatenate_medium_large_cafes'].reenable
    @large_cafe.reload
    @medium_cafe.reload
  end

end
