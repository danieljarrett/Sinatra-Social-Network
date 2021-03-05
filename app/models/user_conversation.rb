class UserConversation < ActiveRecord::Base

	belongs_to :participant,
		foreign_key: :participant_id,
		class_name: "User"
	belongs_to :conversation

	validates_uniqueness_of :participant_id, scope: :conversation_id

end