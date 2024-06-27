require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = reservations(:one)
  end

  test "should get index with email id" do
    assert reservations(:one).save!
    assert reservations(:four).save!
    assert reservations(:five).save!

    visit root_url

    fill_in "Email", with: @reservation.email

    click_on "Search for your reservations"

    assert_selector "h1", text: "Reservations"
  end

  test "should create reservation" do
    visit root_url
    assert_selector "h1", text: "We have 3 stays waiting for you!"

    click_on "Browse all stays"
    click_on "Stay with low price"
    click_on "Book this stay"

    fill_in "Enter your name", with: @reservation.name
    fill_in "Enter your email", with: @reservation.email
    fill_in "Enter your address", with: @reservation.address
    fill_in "Check in", with: @reservation.check_in
    fill_in "Check out", with: @reservation.check_out

    select "iDeal", from: "Pay type"

    fill_in "Routing number", with: "WIJKEFHB13927456"
    fill_in "Account number", with: "WIJKEFHB13927456"

    click_on "Create Reservation"

    assert_text "Reservation was successfully created"
    click_on "Home"
  end

  test "should not create reservation when dates are unavailable" do
    assert @reservation.save!
    visit root_url

    click_on "Browse all stays"
    click_on "Pet friendly stay"
    click_on "Book this stay"

    fill_in "Enter your name", with: @reservation.name
    fill_in "Enter your email", with: @reservation.email
    fill_in "Enter your address", with: @reservation.address
    fill_in "Check in", with: @reservation.check_in
    fill_in "Check out", with: @reservation.check_out

    select "iDeal", from: "Pay type"

    fill_in "Routing number", with: "WIJKEFHB13927456"
    fill_in "Account number", with: "WIJKEFHB13927456"

    click_on "Create Reservation"

    assert_text "Dates not available"
  end

  test "check dynamic fields" do
    visit :stays

    click_on "Pet friendly stay", match: :first

    click_on "Book this stay"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "I agree to pay the full amount at the stay and understand that I will not be allowed if unpaid"

    select "iDeal", from: "Pay type"

    assert has_field? "Routing number"
    assert has_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "I agree to pay the full amount at the stay and understand that I will not be allowed if unpaid"

    select "Bank Card", from: "Pay type"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_field? "Credit card number"
    assert has_field? "Expiration date"
    assert has_no_field? "I agree to pay the full amount at the stay and understand that I will not be allowed if unpaid"

    select "Pay at stay", from: "Pay type"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_field? "I agree to pay the full amount at the stay and understand that I will not be allowed if unpaid"
  end

  test "should cancel reservation" do
    assert reservations(:one).save!
    assert reservations(:four).save!
    assert reservations(:five).save!

    visit root_url

    fill_in "Email", with: @reservation.email

    click_on "Search for your reservations"

    click_on "Show this reservation", match: :first

    page.accept_confirm do
      click_on "Cancel this reservation"
    end

    assert_text "Cancelled"
  end
end
