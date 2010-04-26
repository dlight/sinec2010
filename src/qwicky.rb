# App class. {{{1
class Qwicky
    attr_accessor :conf, :markup

    def initialize
        begin
            FileUtils.touch(CONF_FILE) unless File.exist?(CONF_FILE)
        rescue Errno::EACCES
            $stderr.puts "Unable to create `#{CONF_FILE}'"
            $stderr.puts "Please make directory writable or manually"
            $stderr.puts "create a readable config file."
            exit -1
        end

        @conf = {
            'homepage' => '',
            'markup' => 'text',
        }.merge(
            open(CONF_FILE) { |f|
                YAML::load(f) || Hash.new
            }
        )

        set_markup
    end

    def set_markup
        catch :revert do
            @markup = Markup::Markup[@conf['markup']].new
            return
        end

        @markup = Markup::Markup['text'].new
    end

    def format text
        markup.format(text)
    end
end
