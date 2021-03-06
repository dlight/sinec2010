require 'haml'
require 'sass'

enable :sessions

APP = Qwicky.new

# Routes. {{{1
helpers do
    def redirect_home
        if APP.conf['homepage'].empty?
            redirect "/..settings"
        else
            show_page APP.conf['homepage']
        end
    end
    def show_page page
        def partial_page q
          haml q, :layout => false
         end

        #puts("----------------------------------------------")
        #@partial = proc{ |x| partial_page x }
        #puts("---------------------------------------------!")

        @page = Page.first(:name => page)
        redirect "/#{page}/edit" if @page.nil?
        @title = page
        haml :page
    end
    def markup text
        APP.format(text)
    end

end

before do
    @configurable = File.writable?(CONF_FILE)
end

get '/' do
    redirect_home
end

get '/..settings/?' do
    if File.writable?(CONF_FILE)
        @settings = APP.conf
        @title = 'Settings'
        @markups = Markup::Markup.markups
        haml :settings
    else
        haml "%h1 Config file not writable!"
    end
end

post '/..settings/?' do
    APP.conf.merge!(params[:settings])
    APP.set_markup

    if File.writable?(CONF_FILE)
        open(CONF_FILE, 'w') { |f|
            f.write(YAML::dump(APP.conf))
        }
    end
    
    redirect_home
end

get '/..stylesheet' do
    content_type 'text/css'
    sass :base
end

get '/..sitemap' do
    @title = 'Sitemap'
    @pages = Page.all.sort_by { |page| page.name }
    haml :sitemap
end

require 'src/routes_login'
require 'src/routes_page'
