class Comment < ActiveRecord::Base

	belongs_to :author,
		foreign_key: "author_id",
		class_name: "User"
	belongs_to :post

	has_many :likers,
		through: :user_comments,
		source: :liker
	has_many :user_comments

	def like_count
		likers.count
	end

	def trash
		user_comments.delete_all
		delete
	end

end