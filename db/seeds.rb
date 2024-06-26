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

Stay.delete_all

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

# Stay.create!(
#   name: "Sleeping Beach House - Strand Dishoek",
#   address: "Heideveld 6, 4386 GP Vlissingen, Netherlands",
#   description: %{<div><strong><em>Your perfect holiday destination on the coast in this unique beach house!<br><br>
#   </em></strong>Wake up to the sound of waves, right on the beach. That's what you'll experience in this
#   spacious double-linked beach house. This gives you a lot of space in a beach house in an unparalleled location.
#   Located between the two beach pavilions Vloed and Kaapduin, you will find the peace and quiet you are looking
#   for here. Away from the hustle and bustle but cosiness within easy reach and surrounded by the beauty of the
#     unique south beach of the Netherlands. Just you, your loved ones, the sand and the sea, enjoying a fantastic
#     view. <br><br><strong>Accommodation</strong><br><br>With its double circuit, this special holiday home offers
#     a surprisingly spacious living environment, ideal for both a cosy family holiday and a relaxing getaway with
#     friends. With a total of six sleeping places, there is more than enough space for everyone to stay comfortably.
#     The living area is complete with a fully equipped kitchen and a spacious sitting/dining area. The cosy U-shaped
#     sofa invites you to sit together, eat and have a drink. The kitchen is equipped with everything you need: a hob,
#     oven, fridge freezer, Nespresso coffee machine, filter coffee machine and kettle.<br><br>Behind the living area
#     you will find a bedroom with a double bed (140x200cm) and plenty of closet space for all your holiday clothes.
#     <br><br>In the other cottage you will find the other four sleeping places: a narrow double bed (140x200cm) and
#     a comfortable bunk bed (2x 90x200cm), perfect for the children or extra guests.<br><br>One of the highlights of
#     this beach house is undoubtedly the double-wide terrace (approx. 5.5 x 1.80 m), where you can enjoy the fresh sea
#     air and the beautiful view. The beach in front of the cottage is extra wide due to the double link, so there is
#     enough space to relax in one of the six garden chairs or on the two sunbeds.<br><br>For the little ones, a foldable
#     camping bed is available. Plus, you don't have to worry about parking; The beach house comes with a free parking
#     space at a location behind the dunes.<br><br>This beach house in Dishoek offers everything you need for an
#     unforgettable holiday by the sea. Whether you come for the peace and quiet or for the adventure on the beach,
#     you will find it all here. Pack your bags and get ready for a wonderful time on the Dutch coast.<br><br><strong>
#     Surroundings<br><br></strong>Dishoek, a cozy coastal town, is known for its wide sandy beaches. It is the perfect
#     place to relax, sunbathe or take a refreshing dip in the North Sea. For the more active among us, the beach of
#     Dishoek offers countless possibilities: from beach walks at sunset to adventurous water sports.<br><br>But Dishoek
#     is more than just a beach. The area invites you to explore Zeeland's nature and culture. Cycling and walking
#     routes lead you through the dunes, past picturesque villages and historical sights.<br><br>Just a stone's throw
#     from Dishoek is Vlissingen. This city, with its rich maritime history, offers something for everyone. Stroll
#     around the boulWith a view of the busy Western Scheldt, visit the MuZEEum for a dive into Zeeland's maritime
#     history or enjoy the culinary delights in one of the many restaurants.<br><br>A visit to Middelburg should not
#     be missed. This historic city, the beating heart of Zeeland, is full of monumental buildings, atmospheric squares
#     and pleasant shopping streets. Discover the Abbey of Middelburg, climb the Lange Jan for a breathtaking view of
#     the city or explore the local markets.<br><br>Dishoek is the perfect base for those looking for the best of both
#     worlds: the tranquility of the beach combined with the liveliness of the city. Whether you are looking for a
#     relaxing day at the beach, a cultural city trip or an active holiday, you will find it all in Dishoek and the
#     surrounding area.</div>},
#   max_persons: 6,
#   pet_friendly: true,
#   bedrooms: 3,
#   bathrooms: 2,
#   area: 30.0,
#   price: 159.99,
#   image_url: "https://cdn-cms.bookingexperts.nl/media/1172/21/optimized.jpg",
# )

# Stay.create!(
#   name: "Houseboat RiggelBrug Sneekermeer",
#   address: "4 Paviljoenwei, 8626 GD Offingawier, Netherlands",
#   max_persons: 4,
#   pet_friendly: false,
#   bedrooms: 2,
#   bathrooms: 2,
#   area: 0.48e2,
#   price: 0.45e3,
#   image_url: "https://cdn.bookingexperts.nl/uploads/image/image/505826/large_Houseboat_RiggelBrug_sneekermeer_00017.JPG",
#   description: %{<div><strong><em>Celebrate your holiday on the water: the Sneekermeer is right in the backyard of this
#   lovely houseboat</em></strong></div><div><br></div><div>This spacious and light houseboat is located in marina
#   Waterrijck on the Sneekermeer near the Start Island, within cycling distance of the cozy town of Sneek. The perfect
#   base for anyone who loves living on and by the water. Here you can indulge yourself in the beautiful view over the
#   lake and it will be difficult to choose between the countless possibilities in the field of water sports.</div><div>
#   <br></div><div><strong>Accommodation<br></strong><br></div><div>From the jetty you step on the spacious houseboat.
#   Under the stairs to the huge roof terrace you step through the back door into the ground floor houseboat. On this
#   side of the houseboat are the two bedrooms, one with a double bed (160x200cm) consisting of two separate single
#   mattresses, bedside tables + bedside lamps and a high wardrobe. The sockets are equipped with USB and USB-C
#   connections, a large mirror and a desk with separate stool. In the other bedroom there are two single beds
#   (80x200cm), also a bedside table, two wall cabinets with storage space and bedside lamps, there are also smart
#   sockets. The bathroom is equipped with a shower, washbasin with furniture and toilet. At the rear of the houseboat
#   you will find the living room with a comfortable sofa with ottoman and a separate armchair. Diagonally opposite the
#   sofa is the cozy round dining table with 4 seats. The adjacent open kitchen is equipped with an induction hob, combi
#   microwave, dishwasher, fridge with freezer, toaster, Nespresso and filter coffee machine and a kettle. Through the
#   living room you step onto the adjoining (covered) terrace (15m2) directly on the water, here you can sit in the shade
#   all day long. There are 4 garden chairs on this terrace. If you want to enjoy the view over the Sneekermeer and the
#   sun, you can sit beautifully on the lounge sofa (with cushions) on the roof terrace (25m2).</div><div><br><br></div>
#   <div>If you are travelling with small children up to 2 years old, a cot and a high chair are available in the
#   accommodation. Please note that both terraces are not fully fenced.</div><div>Unfortunately, pets are not allowed
#   in this property.</div><div><br><br></div><div><strong>Environment</strong></div><div><br></div><div>Water
#   sports and the Sneekermeer... It is often mentioned in the same breath. Not surprising, because in terms of
#   water sports, almost everything is possible here. Sailing, boating, supping, fishing or sitting on the nearby
#   beach. In the center of Sneek it is often pleasantly busy, nice restaurants and terraces and surprising boutiques.
#   It is not for nothing that Sneek has been chosen as the best shopping city above the major rivers. This
#   accommodation not only offers comfort and relaxation, but also plenty of nice amenities in the vicinity.
#   Walk in about 13 minutes to the ferry that takes you to Start Island and just a 9-minute walk from the
#   ferry you are on Start Island, where adventure awaits. For the beach lovers, there is a beautiful beach
#   club just 12 minutes away, perfect for enjoying sunny days by the water. A 6-minute walk away is the RCN
#   campsite with a range of facilities and the possibility to rent falcons for an enjoyable day on the water.
#   For culinary discoveries, there are several restaurants just a 10-minute walk away. And if watersports are
#   your passion, you can walk to the waterski slope in just 6 minutes or enjoy the Aquapark (during the season)
#   just 5 minutes away. In short, this accommodation in Sneek offers everything you need for an unforgettable stay
#   with plenty of fun activities nearby!</div><div><br><br></div>},
# )

# Stay.create!(
#   name: "Modern Minecraft Villa - Villa Enderlight",
#   address: "1 Creeper Lane, Blocktopia Heights, Minecraftia",
#   max_persons: 10,
#   pet_friendly: true,
#   bedrooms: 5,
#   bathrooms: 5,
#   area: 0.15e3,
#   price: 0.75e3,
#   image_url: "https://i.ytimg.com/vi/cZcve1B-exk/maxresdefault.jpg",
#   description: %{<div><strong><em>A sleek, contemporary villa in a calming environment</em></strong></div><div>
#   <br></div><div>Imagine a sleek, contemporary villa that stands out with its clean lines and minimalist design.
#   The structure is a harmonious blend of natural materials and modern aesthetics, creating an inviting retreat that
#   offers both comfort and style. As you approach, the villa's expansive windows and open terraces promise breathtaking
#   views and a seamless connection with the surrounding landscape. Inside, the open-concept layout is accentuated by
#   high ceilings and a neutral color palette, with pops of vibrant color adding warmth and personality.&nbsp;</div>
#   <div><br></div><div><strong>Description</strong></div><div><br></div><div>Each room is thoughtfully designed to
#   maximize space and light, ensuring a tranquil and luxurious stay. The villa's outdoor area is equally impressive,
#   featuring a serene pool, lush gardens, and cozy seating areas perfect for relaxation or entertaining guests. This
#   Minecraft villa is not just a vacation home; it's a modern sanctuary where design and nature coexist beautifully.
#   </div>},
# )

# Stay.create!(
#   name: "Sasta wala villa",
#   address: "Sasta galli, Sastapur, Sasta Pradesh",
#   max_persons: 1,
#   pet_friendly: true,
#   bedrooms: 1,
#   bathrooms: 1,
#   area: 0.999e1,
#   price: 0.999e1,
#   image_url: "image.jpg",
#   description: %{<div>Sasta description v2</div>},
# )
