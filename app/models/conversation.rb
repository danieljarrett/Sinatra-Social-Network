class Conversation < ActiveRecord::Base

	has_many :messages

	has_many :participants,
		through: :user_conversations
	has_many :user_conversations,
		foreign_key: "conversation_id"

	def newest(i = 1)
		return newest(i - 1) if messages.count < i
		messages.order("created_at DESC").first(i)[i - 1]
	end

	def trash
		user_conversations.delete_all
		messages.delete_all
		delete
	end

end