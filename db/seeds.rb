### CREATE USERS

  def gen_username(i)
    if i == 0
      'dkj25'
    elsif i == 1
      'aecook90'
    else
      Faker::Internet.user_name
    end
  end

  def gen_password(i)
    if i <= 1
      '123'
    else
      Faker::Internet.password
    end
  end

  30.times do |i|

    User.create(
      username: gen_username(i),
      password: gen_password(i),
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      gender: ['Male', 'Female'].shuffle[0],
      hometown: Faker::Address.city,
      current_city: Faker::Address.city,
      dob: Faker::Date.birthday(min_age = 22, max_age = 28),
      bio: Faker::Lorem.sentence(word_count = 50, supplemental = false, random_words_to_add = 0),
      phone: Faker::PhoneNumber.cell_phone,
      email: Faker::Internet.email
    )

  end

### CREATE FRIENDSHIPS

  1000.times do

    Friendship.create(
      friender_id: 1 + rand(User.all.length),
      friendee_id: 1 + rand(User.all.length)
    )

  end

### CREATE CONVERSATIONS

  100.times do |i|

    Conversation.create(
      subject: Faker::Lorem.sentence(word_count = 2 + rand(6), supplemental = false, random_words_to_add = 0),
    )

    (1 + rand(5)).times do
      UserConversation.create(
        participant_id: 1 + rand(User.all.length),
        conversation_id: i + 1
      )
    end

    (3 + rand(3)).times do
      UserConversation.where(conversation_id: i + 1).each do |x|
        (1 + rand(2)).times do
          Message.create(
            author_id: x.participant_id,
            conversation_id: i + 1,
            body: Faker::Lorem.sentence(word_count = 30 + rand(170), supplemental = false, random_words_to_add = 0)
          )
        end
      end
    end

  end

### CREATE POSTS

  User.all.each do |user|

    user.friends.each do |author|
      Post.create(
        author_id: author.id,
        owner_id: user.id,
        body: Faker::Lorem.sentence(word_count = 10 + rand(90), supplemental = false, random_words_to_add = 0)
      )
    end

    Post.where(owner_id: user.id).each do |post|

      user.friends.each do |friend|
        if rand(3) == 2
          Comment.create(
            author_id: friend.id,
            post_id: post.id,
            body: Faker::Lorem.sentence(word_count = 5 + rand(25), supplemental = false, random_words_to_add = 0)
          )
        end

        if rand(3) == 2
          UserPost.create(
            liker_id: friend.id,
            post_id: post.id
          )
        end
      end

      post.comments.each do |comment|
        user.friends.each do |liker|
          if rand(3) == 2
            UserComment.create(
              liker_id: liker.id,
              comment_id: comment.id
            )
          end
        end
      end

    end

  end
