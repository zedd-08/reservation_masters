# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.where(email: "manish.96@live.com").first_or_initialize
user.update!(
    password: "password",
    password_confirmation: "password"
)

1.upto(23) do |i|
  stay = Stay.where(name: "Minecraft Villa ##{i}").first_or_initialize
  stay.update(
    name: "Minecraft Villa ##{i}",
    address: "#{i*rand(1..10)} Creeper Lane, Blocktopia Heights, Minecraftia",
    description: %{<div><strong><em>A sleek, contemporary villa in a calming environment</em></strong></div><div>
  <br></div><div>Imagine a sleek, contemporary villa that stands out with its clean lines and minimalist design.
  The structure is a harmonious blend of natural materials and modern aesthetics, creating an inviting retreat that
  offers both comfort and style. As you approach, the villa's expansive windows and open terraces promise breathtaking
  views and a seamless connection with the surrounding landscape. Inside, the open-concept layout is accentuated by
  high ceilings and a neutral color palette, with pops of vibrant color adding warmth and personality.&nbsp;</div>
  <div><br></div><div><strong>Description</strong></div><div><br></div><div>Each room is thoughtfully designed to
  maximize space and light, ensuring a tranquil and luxurious stay. The villa's outdoor area is equally impressive,
  featuring a serene pool, lush gardens, and cozy seating areas perfect for relaxation or entertaining guests. This
  Minecraft villa is not just a vacation home; it's a modern sanctuary where design and nature coexist beautifully.
  </div>},
    max_persons: rand(1..10),
    pet_friendly: rand(1..2) == 1,
    bedrooms: rand(1..6),
    bathrooms: rand(1..3),
    area: (1.0 + (rand * 100)).round(2),
    price: (1.0 + (rand * 250)).round(2),
    image_url: "#{i}-minecraft-img.png"
  )
end
