User.create(username: "someguy",
            password: "someguy",
            email_address: "someguy@someguy.com",
            role: User.roles[:admin])
User.create(username: "john",
            password: "password",
            email_address: "john@email.com")

Category.create(name: "Category 1",
                description: "This is the first category")
Category.create(name: "Category 2",
                description: "This is the second category")
category_1 = Category.first
category_2 = Category.second

elapsed = Benchmark.measure do
  someguy = User.first
  john = User.second


  20.times do |i|
    puts "Creating Post #{i+1} for someguy"

    post = Post.new(title: "This is #{someguy.username} Post #{i+1}",
                    body: ActionText::Content.new(
                          "This is the <strong>body</strong> for #{someguy.username}'s Post# #{i+1}"),
                    category_ids: category_1.id,
                    user: someguy)
    post.save

    5.times do |j|
      puts "Creating Comment #{j+1} for Post #{i+1} authored by someguy"
      comment = Comment.new(
                body: "This is the body for #{john.username}'s comment #{j+1} on #{someguy.username}'s Post #{i+1}",
                user: john,
                post: post)
      comment.save
    end
  end

  20.times do |i|
    puts "Creating Post #{i+1} for john"

    post = Post.new(title: "This is #{john.username}'s Post #{i+1}",
                    body: ActionText::Content.new(
                          "This is <strong>body</strong> for #{john.username}'s Post# #{i+1}"),
                    category_ids: category_2.id,
                    user: john)
    post.save

    5.times do |j|
      puts "Creating Comment #{j+1} for Post #{i+1} authored by john"
      comment = Comment.new(
                body: "This is the body for #{someguy.username}'s comment #{j+1} on #{john.username}'s Post# #{i+1}",
                user: john,
                post: post)
      comment.save
    end
  end
end

puts "Elapsed time is #{elapsed.real} seconds"
