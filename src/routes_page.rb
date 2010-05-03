get '/:page/delete/?' do |page|
    if session[:user] && session[:user].admin
      page = Page.first(:name => page)
      page.destroy unless page.nil?
    end
    redirect '/'
end

get '/:page/?' do |page|
    show_page(page)
end

get '/:page/edit/?' do |page|
    if not session[:user]
      redirect '/'
    else
      @markup = APP.markup
      @page = Page.first(:name => page) || Page.new(:name => page)
      @title = "Editando #{page}"
      haml :edit
    end
end

post '/:page/?' do |page|
    @page = Page.first(:name => page) || Page.new
    @page.name = params[:name]
    @page.content = params[:content]
    @page.save

    redirect "/#{page}"
end
