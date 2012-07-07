module Jekyll
    class MapTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            @config = Jekyll.configuration({})['mapping']
            @engine = @config['provider']
            @key = @config['api_key']
            @zoom = @config['zoom']
            @size = text
            super
        end

        def render(context)
            @latitude = context['page']['latitude']
            @longitude = context['page']['longitude']
            if @engine == 'google_static'
                return "<img src=\"http://maps.googleapis.com/maps/api/staticmap?markers=#{@latitude},#{@longitude}&size=#{@size}&zoom=#{@zoom}&sensor=false\">"
            elsif @engine == 'google_js' || 'openstreetmap'
                return "<div id=\"jekyll-mapping\"></div>""
        end
    end
end

Liquid::Template.register_tag('render_map', Jekyll::MapTag)