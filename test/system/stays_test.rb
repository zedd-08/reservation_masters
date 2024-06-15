require "application_system_test_case"

class StaysTest < ApplicationSystemTestCase
  setup do
    @stay = stays(:one)
  end

  test "visiting the index" do
    visit stays_url
    assert_selector "h1", text: "Stays"
  end

  test "should create stay" do
    visit stays_url
    click_on "New stay"

    fill_in "Address", with: @stay.address
    fill_in "Area", with: @stay.area
    fill_in "Bathrooms", with: @stay.bathrooms
    fill_in "Bedrooms", with: @stay.bedrooms
    fill_in "Max persons", with: @stay.max_persons
    fill_in "Name", with: @stay.name
    check "Pet friendly" if @stay.pet_friendly
    fill_in "Price", with: @stay.price
    click_on "Create Stay"

    assert_text "Stay was successfully created"
    click_on "Back"
  end

  test "should update Stay" do
    visit stay_url(@stay)
    click_on "Edit this stay", match: :first

    fill_in "Address", with: @stay.address
    fill_in "Area", with: @stay.area
    fill_in "Bathrooms", with: @stay.bathrooms
    fill_in "Bedrooms", with: @stay.bedrooms
    fill_in "Max persons", with: @stay.max_persons
    fill_in "Name", with: @stay.name
    check "Pet friendly" if @stay.pet_friendly
    fill_in "Price", with: @stay.price
    click_on "Update Stay"

    assert_text "Stay was successfully updated"
    click_on "Back"
  end

  test "should destroy Stay" do
    visit stay_url(@stay)
    click_on "Destroy this stay", match: :first

    assert_text "Stay was successfully destroyed"
  end
end
