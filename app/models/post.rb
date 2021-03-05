class Post < ActiveRecord::Base

	belongs_to :author,
		foreign_key: "author_id",
		class_name: "User"
	belongs_to :owner,
		foreign_key: "owner_id",
		class_name: "User"

	has_many :comments

	has_many :likers,
		through: :user_posts,
		source: :liker
	has_many :user_posts

	def like_count
		likers.count
	end

	def trash
		comments.each do |comment|
			comment.trash
		end
		user_posts.delete_all
		delete
	end

	def comment_count
		comments.count
	end

end