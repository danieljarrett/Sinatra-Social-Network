Sinatra Network
====
A demonstration of authentication, routing, modeling, and messaging for a social network in Sinatra. We employ a general-purpose implementation of a network model, consisting of user nodes, friendship edges, posts, comments, and live conversations comprising direct messages.

### Authentication

Routing is specified explicitly:

	get '/signin' do
	  erb :'auth/signin'
	end

	post '/signin' do
	  user = User.find_by(username: params[:user][:username])

	  if user && user.authenticate(params[:user][:password])
	    session[:user_id] = user.id
	    redirect '/'
	  else
	    redirect '/signin'
	  end
	end
	
### Redirection

Prior locations are stored:

	def store_location
	  session[:return_to] = request.url
	end
	
	def get_location
		pop = session[:return_to]
		session[:return_to] = nil
		pop
	end

And used where redirection is necessary:

	get '/posts/authored/:user_id' do # Non-accessible
		store_location
		erb :'post/group/authored', locals: { user: User.find(params[:user_id]) },
			layout: :inset
	end

	post '/posts/:post_id/edit' do
		Post.find(params[:post_id]).update(params[:post])
		redirect get_location
	end
	
### Connections

Friendship tables are stored in a validated self join:

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

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
