require 'test_helper'

class StreetCafeTest < ActiveSupport::TestCase

  test "LS1 postal code with number of chairs less than 10 then categorize small" do
    # Arrange
    @cafe = street_cafes(:ls1)
    @cafe.update(chairs: 8)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls1 small', @cafe.category
  end

  test "LS1 postal code with number of chairs equal to 10 then categorize medium" do
    # Arrange
    @cafe = street_cafes(:ls1)
    @cafe.update(chairs: 10)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls1 medium', @cafe.category
  end

  test "LS1 postal code with number of chairs greater than 10 and less than 100 then categorize medium" do
    # Arrange
    @cafe = street_cafes(:ls1)
    @cafe.update(chairs: 50)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls1 medium', @cafe.category
  end

  test "LS1 postal code with number of chairs equal to 100 then categorize as large" do
    # Arrange
    @cafe = street_cafes(:ls1)
    @cafe.update(chairs: 100)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls1 large', @cafe.category
  end

  test "LS1 postal code with number of chairs greater than 100 then categorize as large" do
    # Arrange
    @cafe = street_cafes(:ls1)
    @cafe.update(chairs: 101)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls1 large', @cafe.category
  end

  test "LS2 postal code with number of chairs less than 50th percentile then categorize small" do
    # Arrange
    @cafe = street_cafes(:ls2)
    @cafe.update(chairs: 9)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls2 small', @cafe.category
  end

  test "LS2 postal code with number of chairs greater than 50th percentile then categorize large" do
    # Arrange
    @cafe = street_cafes(:ls2)
    @cafe.update(chairs: 101)

    # Act
    run_categorize

    # Assert
    assert_equal 'ls2 large', @cafe.category
  end

  test "Other postal code then categorize as other" do
    # Arrange
    @cafe = street_cafes(:other)

    # Act
    run_categorize

    # Assert
    assert_equal 'other', @cafe.category
  end

  private

  def run_categorize
    CafeData::Application.load_tasks
    Rake::Task['categorize_street_cafes'].invoke
    Rake::Task['categorize_street_cafes'].reenable
    @cafe.reload
  end
end
