class User < ActiveRecord::Base

		has_secure_password

		def name
			"#{first_name} #{last_name}"
		end

	# Friendships

		has_many :frienders,
			through: :received_friendships, 	# rename friendships so this is not duplicated
			source: :friender 								# so AR now looks for friender_id in friendships
		has_many :received_friendships,
			foreign_key: "friendee_id",				# so AR now looks for user in friendee_id
			class_name: "Friendship"					# so AR now knows what received_friendship is

		has_many :friendees,
			through: :initiated_friendships,
			source: :friendee
		has_many :initiated_friendships,
			foreign_key: "friender_id",
			class_name: "Friendship"

	# Conversations

		has_many :messages,
			foreign_key: "author_id"

		has_many :conversations,
			through: :user_conversations
		has_many :user_conversations,
			foreign_key: "participant_id"

	# Posts

		has_many :authored_posts,
			foreign_key: "author_id",
			class_name: "Post"
		has_many :owned_posts,
			foreign_key: "owner_id",
			class_name: "Post"

	# Comments

		has_many :comments,
			foreign_key: "author_id",
			class_name: "Comment"

	# Liked-Posts

		has_many :liked_posts,
			through: :user_posts,
			source: :post
		has_many :user_posts,
			foreign_key: "liker_id"

	# Liked-Comments

		has_many :liked_comments,
			through: :user_comments,
			source: :comment
		has_many :user_comments,
			foreign_key: "liker_id"

	# Methods

		def friends
			# returns an array, not an AR relation
			frienders.order("first_name").to_a.keep_if do |friender| 
				friender.frienders.include?(self)
			end
		end

		def sent
			# returns an array, not an AR relation
			friendees.order("first_name").to_a.keep_if do |friendee|
				!friendee.friendees.include?(self)
			end
		end

		def received
			# returns an array, not an AR relation
			frienders.order("first_name").to_a.keep_if do |friender|
				!friender.frienders.include?(self)
			end
		end

		def add_friend(friendee_id)
			Friendship.create(friender_id: id, friendee_id: friendee_id)
		end

		def delete_friend(friendee_id)
			Friendship.find_by(friender_id: id, friendee_id: friendee_id).delete
		end

		def relevant_posts # needs refactoring for efficiency
			posts = []
			users = [friends, self].flatten
			Post.order("created_at DESC").each do |post|
				if (users & [post.owner, post.author]).length > 0
					posts << post
				end
				break if posts.length >= 20
			end
			posts
		end

		def trash
			received_friendships.delete_all
			initiated_friendships.delete_all
			messages.delete_all
			conversations.each { |conversation| conversation.trash if conversation.messages.count == 0 }
			user_conversations.delete_all
			authored_posts.each { |post| post.trash }
			owned_posts.each { |post| post.trash }
			comments.each { |comment| comment.trash }
			delete
		end

end