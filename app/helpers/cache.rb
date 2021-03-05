def store_location
  session[:return_to] = request.url
end

def get_location
	pop = session[:return_to]
	session[:return_to] = nil
	pop
end