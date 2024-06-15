require "test_helper"

class StayTest < ActiveSupport::TestCase
  test "stay must contain required attributes" do
    stay = Stay.new
    assert stay.invalid?
    assert stay.errors[:name].any?
    assert stay.errors[:address].any?
    assert stay.errors[:description].any?
    assert stay.errors[:max_persons].any?
    assert stay.errors[:bedrooms].any?
    assert stay.errors[:bathrooms].any?
    assert stay.errors[:area].any?
    assert stay.errors[:price].any?
    assert stay.errors[:pet_friendly].any?
  end

  test "price must be positive" do
    stay = create_valid_stay
    assert stay.valid?

    stay.price = 0
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 0.01"], stay.errors[:price]

    stay.price = -1
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 0.01"], stay.errors[:price]

    stay.price = 10
    assert stay.valid?
  end

  test "area must be positive" do
    stay = create_valid_stay
    assert stay.valid?

    stay.area = 0
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 0.01"], stay.errors[:area]

    stay.area = -1
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 0.01"], stay.errors[:area]

    stay.area = 10
    assert stay.valid?
  end

  test "bedrooms must be more than 1 and integer" do
    stay = create_valid_stay
    assert stay.valid?

    stay.bedrooms = 0
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:bedrooms]

    stay.bedrooms = -1
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:bedrooms]

    stay.bedrooms = 1.9
    assert stay.invalid?
    assert_equal ["must be an integer"], stay.errors[:bedrooms]
  end

  test "bathrooms must be more than 1 and integer" do
    stay = create_valid_stay
    assert stay.valid?

    stay.bathrooms = 0
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:bathrooms]

    stay.bathrooms = -1
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:bathrooms]

    stay.bathrooms = 1.9
    assert stay.invalid?
    assert_equal ["must be an integer"], stay.errors[:bathrooms]
  end

  test "max_persons must be more than 1 and integer" do
    stay = create_valid_stay
    assert stay.valid?

    stay.max_persons = 0
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:max_persons]

    stay.max_persons = -1
    assert stay.invalid?
    assert_equal ["must be greater than or equal to 1"], stay.errors[:max_persons]

    stay.max_persons = 1.9
    assert stay.invalid?
    assert_equal ["must be an integer"], stay.errors[:max_persons]
  end

  test "image url must be of jpg, png or gif" do
    stay = create_valid_stay
    ok = %w{image.gif image.png image.jpeg IMAGE.JPG IMAGE.JPEG IMAGE.PNG IMAGE.GIF http://a.com/g/d/jj.png}
    bad = %w{image.doc iamge.gif/more isittrue.gif.is.more}

    ok.each do |url|
      stay.image_url = url
      assert stay.valid?, "Image URL must be valid"
    end

    bad.each do |url|
      stay.image_url = url
      assert stay.invalid?, "Image URL must not be valid"
    end
  end

  test "name must be unique" do
    stay = create_valid_stay
    stay.name = stays(:pet_friendly_stay).name
    assert stay.invalid?
    assert_equal [I18n.translate("errors.messages.taken")], stay.errors[:name]
  end

  private

  def create_valid_stay
    Stay.new(
      name: "Random name #{rand(1000)}",
      description: "Description",
      address: "MyString",
      image_url: "image.jpg",
      max_persons: 1,
      pet_friendly: false,
      bedrooms: 1,
      bathrooms: 1,
      area: 9.99,
      price: 9.99,
    )
  end
end
