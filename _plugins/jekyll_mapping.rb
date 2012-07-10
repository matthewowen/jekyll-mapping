module Jekyll
    class MapTag < Liquid::Tag
        safe: true
        
        def initialize(tag_name, text, tokens)
            @config = Jekyll.configuration({})['mapping']
            @engine = @config['provider']
            @key = @config['api_key']
            if @config.has_key?('zoom')
                @zoom = @config['zoom']
            else
                @zoom = '10'
            end
            if text.empty?
                if @config['dimensions']
                    @width = @config['dimensions']['width']
                    @height = @config['dimensions']['height']
                else
                    @width = '600'
                    @height = '400'
                end
            else
                @width = text.split(",").first.strip
                @height = text.split(",").last.strip
            end
            super
        end

        def render(context)
            if context['page']['mapping'].has_key?('latitude') && context['page']['mapping'].has_key?('longitude')
                latitude = context['page']['mapping']['latitude']
                longitude = context['page']['mapping']['longitude']
                if @engine == 'google_static'
                    return "<img src=\"http://maps.googleapis.com/maps/api/staticmap?markers=#{latitude},#{longitude}&size=#{@width}x#{@height}&zoom=#{@zoom}&sensor=false\">"
                elsif @engine == 'google_js' || 'openstreetmap'
                    return "<div id=\"jekyll-mapping\" style=\"height:#{@height}px;width:#{@width}px;\"></div>"
                end
            end
        end
    end
end

Liquid::Template.register_tag('render_map', Jekyll::MapTag)