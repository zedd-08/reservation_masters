require "test_helper"

class StaysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @stay = stays(:pet_friendly_stay)
    @name = @stay.name + "#{rand(1000)}"

    sign_in users(:admin)
  end

  test "should get index signed in" do
    get stays_url
    assert_response :success

    assert_select "a", "Add a new stay"
  end

  test "should get index signed out" do
    sign_out :user

    get stays_url
    assert_response :success
  end

  test "should get redirected from new when not logged in" do
    sign_out :user

    get new_stay_url
    assert_redirected_to :new_user_session
  end

  test "should get new when logged in" do
    get new_stay_url
    assert_response :success
  end

  test "should create stay" do
    assert_difference("Stay.count") do
      post stays_url, params: { stay: { address: @stay.address, area: @stay.area, bathrooms: @stay.bathrooms, bedrooms: @stay.bedrooms, description: @stay.description, image_url: @stay.image_url, max_persons: @stay.max_persons, name: @name, pet_friendly: @stay.pet_friendly, price: @stay.price } }
    end

    assert_redirected_to stay_url(Stay.last)
  end

  test "should show stay signed in" do
    get stay_url(@stay)
    assert_response :success

    assert_select "a", "Book this stay"
    assert_select "a", "Back to all stays"
    assert_select "a", "Edit this stay"
    assert_select "button", "Disable this stay"
  end

  test "should show stay signed out" do
    sign_out :user

    get stay_url(@stay)
    assert_response :success

    assert_select "a", "Book this stay"
    assert_select "a", "Back to all stays"
  end

  test "should redirect from edit when not signed in" do
    sign_out :user

    get edit_stay_url(@stay)
    assert_redirected_to :new_user_session
  end

  test "should get edit when signed in" do
    get edit_stay_url(@stay)
    assert_response :success
  end

  test "should redirect from update stay when not signed in" do
    sign_out :user

    patch stay_url(@stay), params: { stay: { address: @stay.address, area: @stay.area, bathrooms: @stay.bathrooms, bedrooms: @stay.bedrooms, description: @stay.description, image_url: @stay.image_url, max_persons: @stay.max_persons, name: @name, pet_friendly: @stay.pet_friendly, price: @stay.price } }

    assert_redirected_to :new_user_session
  end

  test "should update stay" do
    patch stay_url(@stay), params: { stay: { address: @stay.address, area: @stay.area, bathrooms: @stay.bathrooms, bedrooms: @stay.bedrooms, description: @stay.description, image_url: @stay.image_url, max_persons: @stay.max_persons, name: @name, pet_friendly: @stay.pet_friendly, price: @stay.price } }

    assert_redirected_to stay_url(@stay)

    follow_redirect!

    assert_select "p", "Stay was successfully updated."
    assert_select "h1", @name
  end

  test "should disable stay" do
    put disable_stay_url(@stay)
    assert_redirected_to @stay

    follow_redirect!

    assert_select "p", "Stay was successfully disabled."
    assert_select "h1", "This stay is disabled. This will prevent the stay from showing up in search results."
  end

  test "should enable stay" do
    dis_stay = stays(:disabled_stay)
    put enable_stay_url(dis_stay)
    assert_redirected_to dis_stay

    follow_redirect!

    assert_select "p", "Stay was successfully enabled."
  end
end
