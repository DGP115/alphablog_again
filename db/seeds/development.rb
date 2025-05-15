array = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
user = User.find_or_create_by(username: "someguy")
array.each do |i|
  user.posts << Post.create!(
                title: "This is Post #{i}",
                body: "This is the body for post #{i}",
                id: user.id
                )
end

array = [ 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ]
user = User.find_or_create_by(username: "John")
array.each do |i|
  user.posts << Post.create!(
                title: "This is Post #{i}",
                body: "This is the body for post #{i}",
                id: user.id
                )
end
