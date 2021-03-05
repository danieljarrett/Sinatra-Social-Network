def search_users(term)
	matches = []
	User.order("first_name").each do |user|
		user.attributes.each do |attribute|
			if attribute[1] =~ /#{term}/
				matches << user
				break
			end
		end
	end
	return matches
end