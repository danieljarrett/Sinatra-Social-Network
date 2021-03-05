class Friendship < ActiveRecord::Base

	belongs_to :friender,
		foreign_key: "friender_id",
		class_name: "User"
	belongs_to :friendee,
		foreign_key: "friendee_id",
		class_name: "User"

	validates_uniqueness_of :friendee_id, scope: :friender_id
	validates_presence_of :friender_id, :friendee_id

end