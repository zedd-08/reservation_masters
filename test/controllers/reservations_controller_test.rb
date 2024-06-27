require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @reservation = reservations(:one)
    @check_in = "2024-10-07"
    @check_out = "2024-10-11"
  end

  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "(index) should get index after signing in" do
    sign_in users(:admin)

    get reservations_url
    assert_response :success

    assert_select "strong", { count: 6, text: "Stay:" }
    sign_out :user
  end

  test "(index) should redirect from index without email" do
    get reservations_url
    assert_redirected_to :root

    follow_redirect!

    assert_equal "Email not provided, please try again", flash[:notice]
  end

  test "(index) should get index with email provided" do
    get reservations_url(email: "email1@mail.com")
    assert_response :success

    assert_select "strong", { count: 3, text: "Stay:" }
  end

  test "(index) should redirect to root when reservations not found" do
    get reservations_url(email: "email4@mail.com")
    assert_redirected_to :root

    assert_equal "Could not find any reservations with email: email4@mail.com", flash[:notice]
  end

  test "(new) should not get new without stay params" do
    get new_reservation_url
    assert_redirected_to :root

    follow_redirect!

    assert_equal "Please select a stay to create a reservation", flash[:notice]

    sign_out :user

    get new_reservation_url
    assert_redirected_to :root

    follow_redirect!

    assert_equal "Please select a stay to create a reservation", flash[:notice]
  end

  test "(new) should get new with stay params prodived" do
    get new_reservation_url(stay_id: stays(:low_price).id)
    assert_response :success
    assert_select "a", stays(:low_price).name
  end

  test "(new) should get new with stay and dates params prodived" do
    get new_reservation_url(stay_id: stays(:low_price).id, check_in: @check_in, check_out: @check_out)

    assert_response :success

    assert_select "a", stays(:low_price).name
    assert_select "input", { id: "reservation_check_in", value: @check_in }
    assert_select "input", { id: "reservation_check_out", value: @check_out }
  end

  test "(create) should create reservation" do
    assert_difference("Reservation.count") do
      post reservations_url, params: {
                               reservation: { check_in: @check_in, check_out: @check_out, name: @reservation.name, email: @reservation.email, address: @reservation.address, pay_type: @reservation.pay_type, routing_number: "SOJFGHB12356", account_number: "2937856rtyg" },
                               stay_id: @reservation.stay_id,
                             }
    end

    assert_redirected_to reservation_url(Reservation.last)
    assert_equal "Reservation was successfully created.", flash[:notice]
  end

  test "(show) should not show reservation without email" do
    get reservation_url(@reservation)
    assert_redirected_to :root
  end

  test "(show) should show reservation after giving email" do
    get reservations_url(email: "email1@mail.com")
    get reservation_url(@reservation)
    assert_response :success
  end

  test "(edit) should not get edit when not signed in" do
    get edit_reservation_url(@reservation)
    assert_redirected_to :new_user_session
  end

  test "(edit) should get edit when signed in" do
    sign_in users(:admin)

    get edit_reservation_url(@reservation)
    assert_response :success
    assert_select "select", { count: 1 }

    sign_out :user
  end

  test "(edit) should not get edit when reservation is cancelled" do
    sign_in users(:admin)

    cancelled_reservation = reservations(:five)
    get edit_reservation_url(cancelled_reservation)
    assert_redirected_to cancelled_reservation
    assert_equal "Reservation is cancelled. Further modifications not allowed.", flash[:notice]

    sign_out :user
  end

  test "(update) should not update reservation when signed out" do
    patch reservation_url(@reservation), params: { reservation: { status: "Booked - Paid" } }
    assert_redirected_to :new_user_session
  end

  test "(update) should update reservation only when signed in" do
    sign_in users(:admin)

    patch reservation_url(@reservation), params: { reservation: { status: "Booked - Paid" } }
    assert_redirected_to reservation_url(@reservation)

    follow_redirect!

    assert_equal "Reservation was successfully updated.", flash[:notice]

    @reservation.reload
    assert_equal @reservation.status, "Booked - Paid"
    sign_out :user
  end

  test "(update) should not update reservation with invalid status update" do
    sign_in users(:admin)

    reservation = reservations(:two)

    patch reservation_url(reservation), params: { reservation: { status: "Booked - Payment pending" } }

    assert_redirected_to reservation
    assert_equal "Invalid status update", flash[:notice]

    sign_out :user
  end

  test "(update) should not update reservation when checked in/checked out" do
    sign_in users(:admin)

    reservation = reservations(:three)

    patch reservation_url(reservation), params: { reservation: { status: "Checked out" } }

    assert_redirected_to reservation
    assert_equal "Cannot update a checked in/out reservation", flash[:notice]

    reservation = reservations(:four)

    patch reservation_url(reservation), params: { reservation: { status: "Cancelled" } }

    assert_redirected_to reservation
    assert_equal "Cannot update a checked in/out reservation", flash[:notice]

    sign_out :user
  end

  test "(destroy) should not cancel reservation without email" do
    delete reservation_url(@reservation)
    assert_redirected_to :root

    @reservation.reload
    assert_equal @reservation.status, "Booked - Payment pending"
  end

  test "(destroy) should cancel reservation when signed in" do
    sign_in users(:admin)

    delete reservation_url(@reservation)
    assert_redirected_to @reservation

    follow_redirect!

    assert_equal "Reservation was successfully cancelled.", flash[:notice]

    @reservation.reload
    assert_equal @reservation.status, "Cancelled"
  end

  test "(destroy) should cancel reservation with email" do
    get reservations_url(email: "email1@mail.com")
    delete reservation_url(@reservation)

    assert_redirected_to @reservation

    follow_redirect!

    assert_equal "Reservation was successfully cancelled.", flash[:notice]

    @reservation.reload
    assert_equal @reservation.status, "Cancelled"
  end

  test "(destroy) should not cancel reservation checked in" do
    get reservations_url(email: "email123@mail.com")

    reservation = reservations(:three)
    delete reservation_url(reservation)

    assert_redirected_to reservation

    follow_redirect!
    assert_equal "You have already checked in. This reservation cannot be cancelled", flash[:notice]

    reservation.reload
    assert_equal reservation.status, "Checked in"
  end

  test "(destroy) should not cancel reservation checked out" do
    get reservations_url(email: "email1@mail.com")

    reservation = reservations(:four)
    delete reservation_url(reservation)

    assert_redirected_to reservation

    follow_redirect!
    assert_equal "You have already checked in. This reservation cannot be cancelled", flash[:notice]

    reservation.reload
    assert_equal reservation.status, "Checked out"
  end

  test "(destroy) should not cancel reservation checked in and logged in" do
    sign_in users(:admin)
    reservation = reservations(:three)
    delete reservation_url(reservation)

    assert_redirected_to reservation

    follow_redirect!
    assert_equal "Customer has already checked in. This reservation cannot be cancelled", flash[:notice]

    reservation.reload
    assert_equal reservation.status, "Checked in"
    sign_out :user
  end

  test "(destroy) should not cancel reservation checked out and logged in" do
    sign_in users(:admin)
    reservation = reservations(:four)
    delete reservation_url(reservation)

    assert_redirected_to reservation

    follow_redirect!
    assert_equal "Customer has already checked in. This reservation cannot be cancelled", flash[:notice]

    reservation.reload
    assert_equal reservation.status, "Checked out"

    sign_out :user
  end
end
