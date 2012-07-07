module Jekyll
    class MapTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            @config = Jekyll.configuration({})['mapping']
            @engine = @config['provider']
            @key = @config['api_key']
            @zoom = @config['zoom']
            @textif = text
            if text == ""
                @width = "600"
                @height = "400"
            else
                @width = text.split(",").first
                @height = text.split(",").last
            end
            super
        end

        def render(context)
            @latitude = context['page']['latitude']
            @longitude = context['page']['longitude']
            if @engine == 'google_static'
                return "<img src=\"http://maps.googleapis.com/maps/api/staticmap?markers=#{@latitude},#{@longitude}&size=#{@width}x#{@height}&zoom=#{@zoom}&sensor=false\">"
            elsif @engine == 'google_js' || 'openstreetmap'
                return "<div id=\"jekyll-mapping\"></div>"
            end
        end
    end
end

Liquid::Template.register_tag('render_map', Jekyll::MapTag)