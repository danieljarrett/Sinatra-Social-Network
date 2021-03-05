### PRIMARY PAGE VIEWS

	# Home

		get '/', auth: :user do
			store_location
			erb :'index', locals: { posts: current_user.relevant_posts }
		end

	# Profile

		get '/profile', auth: :user do
			store_location
			erb :'profile', locals: { user: current_user }
		end

		get '/profile/:user_id', auth: :user do
			redirect '/profile' if User.find(params[:user_id]) == current_user
			store_location
			erb :'profile', locals: { user: User.find(params[:user_id]) }
		end

	# Friends

		get '/friends', auth: :user do
			store_location
			erb :'friends'
		end

	# Mailbox

		get '/mailbox', auth: :user do
			erb :'mailbox', locals: { conversation: current_user.conversations.order("created_at DESC").first }
		end

		get '/mailbox/:conversation_id', auth: :user do
			erb :'mailbox', locals: { conversation: Conversation.find(params[:conversation_id]) }
		end

	# Search

		get '/search', auth: :user do
			store_location
			erb :'search', locals: { matches: search_users(params[:term]) }
		end

### RESOURCE CRUD ACTIONS

	# Users

		# Create

			get '/users/new' do # Non-accessible
				redirect '/signup'
			end

		# Read

			get '/users/:user_id' do # Non-accessible
				store_location
				erb :'user/show/default', locals: { user: User.find(params[:user_id]) },
					layout: :inset
			end

			get '/users/:user_id/compact' do # Non-accessible
				store_location
				erb :'user/show/compact', locals: { user: User.find(params[:user_id]) },
					layout: :inset
			end

		# Group

			get '/users/friends/:user_id' do # Non-accessible
				store_location
				erb :'user/group/friends', locals: { friends: User.find(params[:user_id]).friends },
					layout: :inset
			end

			get '/users/received/:user_id' do # Non-accessible
				store_location
				erb :'user/group/received', locals: { received: User.find(params[:user_id]).received }, layout: :inset
			end

			get '/users/sent/:user_id' do # Non-accessible
				store_location
				erb :'user/group/sent', locals: { sent: User.find(params[:user_id]).sent },
					layout: :inset
			end

		# Update

			get '/users/:user_id/edit' do
				erb :'user/edit', locals: { user: User.find(params[:user_id]) }
			end

			post '/users/:user_id/edit' do
				User.find(params[:user_id]).update(params[:user])
				redirect get_location
			end

		# Delete

			delete '/users/:user_id/delete' do
				User.find(params[:user_id]).trash
		  	session[:user_id] = nil
		  	redirect '/'
			end	

	# Posts

		# Create

			get '/posts/new/:owner_id' do # Non-accessible
				erb :'post/new', locals: { user: User.find(params[:owner_id]) }
			end

			put '/posts/new/:owner_id' do
				Post.create(
					author_id: current_user.id,
					owner_id: params[:owner_id],
					body: params[:body]
				)
				redirect back
			end

		# Read

			get '/posts/:post_id' do
				store_location
				erb :'post/show/default', locals: { post: Post.find(params[:post_id]) },
					layout: :inset
			end

			get '/posts/:post_id/authored' do # Non-accessible
				store_location
				erb :'post/show/authored', locals: { post: Post.find(params[:post_id]) },
					layout: :inset
			end

			get '/posts/:post_id/owned' do # Non-accessible
				store_location
				erb :'post/show/owned', locals: { post: Post.find(params[:post_id]) },
					layout: :inset
			end

		# Group

			get '/posts/authored/:user_id' do # Non-accessible
				store_location
				erb :'post/group/authored', locals: { user: User.find(params[:user_id]) },
					layout: :inset
			end

			get '/posts/owned/:user_id' do # Non-accessible
				store_location
				erb :'post/group/owned', locals: { user: User.find(params[:user_id]) },
					layout: :inset
			end

		# Update

			get '/posts/:post_id/edit' do
				erb :'post/edit', locals: { post: Post.find(params[:post_id]) }
			end

			post '/posts/:post_id/edit' do
				Post.find(params[:post_id]).update(params[:post])
				redirect get_location
			end

		# Delete

			delete '/posts/:post_id/delete' do
				Post.find(params[:post_id]).trash
		  	redirect back # Breaks if request is from POST-SHOW
			end

			delete '/posts/default/:post_id/delete' do
				Post.find(params[:post_id]).trash
		  	redirect "/profile/#{current_user.id}"
			end

	# Comments

		# Create

			get '/comments/new/:post_id' do # Non-accessible
				erb :'comment/new', locals: { post: Post.find(params[:post_id]) }
			end

			put '/comments/new/:post_id' do
				Comment.create(
					post_id: params[:post_id],
					author_id: current_user.id,
					body: params[:body]
				)
				redirect back
			end

		# Read

			get '/comments/:comment_id' do # Non-accessible
				store_location
				erb :'comment/show', locals: { comment: Comment.find(params[:comment_id]) },
					layout: :inset
			end

		# Update

			get '/comments/:comment_id/edit' do
				erb :'comment/edit', locals: { comment: Comment.find(params[:comment_id]) }
			end

			post '/comments/:comment_id/edit' do
				Comment.find(params[:comment_id]).update(params[:comment])
				redirect get_location
			end

		# Delete

			delete '/comments/:comment_id/delete' do
				Comment.find(params[:comment_id]).trash
		  	redirect back # Breaks if request is from COMMENT-SHOW
			end

	# Conversations

		# Create

			get '/conversations/new' do
				erb :'conversation/new'
			end

			put '/conversations/new' do
				conversation = Conversation.create(subject: params[:subject])
				participants = params[:participants].split(" ") << current_user.username
				participants.each do |username|
					UserConversation.create(
						participant_id: User.find_by(username: username).id,
						conversation_id: conversation.id
					)
				end
				
				Message.create(
					conversation_id: conversation.id,
					author_id: current_user.id,
					body: params[:body]
				)
				redirect "/mailbox/#{conversation.id}"
			end

		# Read

			get '/conversations/:conversation_id' do # Non-accessible
				erb :'conversation/show/default', locals: { conversation: Conversation.find(params[:conversation_id]) },
					layout: :inset
			end

			get '/conversations/compact/:conversation_id' do # Non-accessible
				erb :'conversation/show/compact', locals: { conversation: Conversation.find(params[:conversation_id]) },
					layout: :inset
			end

		# Group

			get '/conversations/sidebar/:user_id' do # Non-accessible
				erb :'conversation/group/sidebar', locals: { user: User.find(params[:user_id]) },
					layout: :inset
			end

		# Update (N/A)

		# Delete

			delete '/conversations/:conversation_id/delete' do
				Conversation.find(params[:conversation_id]).trash
		  	redirect '/mailbox'
			end

			delete '/conversations/compact/:conversation_id/delete' do
				Conversation.find(params[:conversation_id]).trash
		  	redirect '/mailbox'
			end

	# Messages
		
		# Create

			get '/messages/new/:conversation_id' do # Non-accessible
				erb :'message/new', locals: { conversation: Conversation.find(params[:conversation_id]) }
			end

			put '/messages/new/:conversation_id' do
				Message.create(
					conversation_id: params[:conversation_id],
					author_id: current_user.id,
					body: params[:body]
				)
				redirect back
			end

		# Read

			get '/messages/:message_id' do # Non-accessible
				store_location
				erb :'message/show', locals: { message: Message.find(params[:message_id]) },
					layout: :inset
			end

		# Update (N/A)

		# Delete (N/A)

### JOIN-TABLE C/D ACTIONS

	# Friends

		# Create

			put '/friends/:user_id/add' do
				current_user.add_friend(params[:user_id])
		  	redirect back
			end		

		# Delete

			delete '/friends/:user_id/remove' do
				current_user.delete_friend(params[:user_id])
		  	redirect back
			end

	# Post-Likes

		# Create

			put '/likes/post/:post_id/add' do
				UserPost.create(post_id: params[:post_id], liker_id: current_user.id)
		  	redirect back
			end		

		# Delete

			delete '/likes/post/:post_id/remove' do
				UserPost.find_by(post_id: params[:post_id], liker_id: current_user.id).delete
		  	redirect back
			end

	# Comment-Likes

		# Create

			put '/likes/comment/:comment_id/add' do
				UserComment.create(comment_id: params[:comment_id], liker_id: current_user.id)
		  	redirect back
			end		

		# Delete

			delete '/likes/comment/:comment_id/remove' do
				UserComment.find_by(comment_id: params[:comment_id], liker_id: current_user.id).delete
		  	redirect back
			end

	# User-Conversations

		# Create (N/A)

		# Delete (N/A)