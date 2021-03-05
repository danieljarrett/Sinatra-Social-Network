class UserPost < ActiveRecord::Base

	belongs_to :liker,
		foreign_key: :liker_id,
		class_name: "User"
	belongs_to :post

	validates_uniqueness_of :liker_id, scope: :post_id

end