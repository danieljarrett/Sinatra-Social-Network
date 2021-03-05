class UserComment < ActiveRecord::Base

	belongs_to :liker,
		foreign_key: :liker_id,
		class_name: "User"
	belongs_to :comment

	validates_uniqueness_of :liker_id, scope: :comment_id

end