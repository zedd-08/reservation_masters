class Stay < ApplicationRecord
  has_rich_text :description

  validates :name, :address, :description, :max_persons, :bedrooms, :bathrooms, :area, :price, presence: true

  validates :pet_friendly, inclusion: { in: [true, false] }

  validates :name, uniqueness: true

  validates :image_url, allow_blank: true, format: {
                          with: %r{\.(gif|png|jpe?g|)\z}i,
                          message: "must be an URL for JPG, GIF or PNG",
                        }

  validates :price, :area, numericality: { greater_than_or_equal_to: 0.01 }

  validates :max_persons, :bedrooms, :bathrooms, numericality: {
                                                   only_integer: true,
                                                   greater_than_or_equal_to: 1,
                                                 }
end
