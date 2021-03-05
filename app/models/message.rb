class Message < ActiveRecord::Base

	belongs_to :author,
		foreign_key: "author_id",
		class_name: "User"
	belongs_to :conversation

	def trash
		parent = conversation 
		delete
		parent.trash if parent.messages.count == 0
	end

end