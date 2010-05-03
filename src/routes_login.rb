get '/..login' do
  haml :login
end

post '/..login' do
  if session[:user] = User.authenticate(params["email"], params["password"])
    redirect '/'
  else
    flash("Senha e/ou usuario incorreto.")
    redirect '/..login'
  end
end

get '/..logout' do
  session[:user] = nil
  redirect '/'
end

get '/..create-user' do
  haml :create_user
end

post '/..create-user' do
  u = User.new
  u.email = params["email"]
  u.password = params["password"]
  u.page = params["page"]
  if u.save
    redirect '/..list-users'
  else
    tmp = []
    u.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/..create-user'
  end
end

get '/..list-users' do
  @u = User.all
  haml :list_users
end
