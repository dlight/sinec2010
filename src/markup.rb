require 'cgi'

# Markup stuff. {{{1
module Markup

    # Base class. {{{2
    class Markup
        WIKILINK = %r{\[\[([^|\]]+)(\|([^\]]+))?\]\]}

        class << self
            attr_reader :description, :link

            def markups
                @@markups
            end

            def [] type
                @@markups ||= Hash.new
                @@markups[type]
            end

            def type id, description, link = nil
                @@markups ||= Hash.new
                @@markups[id] = self
                @description = description
                @link = link
            end

            def linkify page, display_name
                nexist = Page.first(:name => page).nil?

                klass = nexist ? 'bad' : 'good'
                title = nexist ? "Create page `#{page}'" : "Page `#{page}'"
                link = '/' + CGI::escape(page)
                text = display_name || page
                "<a href=#{link.inspect} title=#{title.inspect} class=#{klass.inspect}>#{text}</a>"
            end
        end

        def description
            self.class.description
        end

        def link
            self.class.link
        end

        def format text
            text.gsub Markup::WIKILINK do |match|
                Markup::linkify $1, $3
            end
        end
    end

    # Text. {{{2
    class MText < Markup
        type 'text', 'Simple text'

        def format text
            "<pre class='simple'>#{super}</pre>"
        end
    end

    # Markdown. {{{2
    class MMarkdown < Markup
        type 'markdown', 'Markdown', 'http://daringfireball.net/projects/markdown/'

        def initialize
            unless Object.const_defined?(:Markdown)
                begin
                    require 'rdiscount'
                    return
                rescue LoadError => boom
                end

                begin
                    require 'peg_markdown'
                    return
                rescue LoadError => boom
                end

                begin
                    require 'bluecloth'
                    Object.const_set(:Markdown, BlueCloth)
                    return
                rescue LoadError => boom
                    puts "Looks like you don't have a Markdown interpreter installed!"
                    puts "Please get one of the following gems:"
                    puts "* rdiscount"
                    puts "* rpeg-markdown"
                    puts "* bluecloth (not recommended)"
                    puts "Reverting to simple text markup"
                    throw :revert
                end
            end
        end

        def format text
            super(Markdown.new(text).to_html)
        end
    end
end
