
module Jekyll
    class MapTag < Liquid::Tag
        
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
            if context['page']['mapping']
                latitude = context['page']['mapping']['latitude']
                longitude = context['page']['mapping']['longitude']
                if @engine == 'google_static'
                    return "<img src=\"http://maps.googleapis.com/maps/api/staticmap?markers=#{latitude},#{longitude}&size=#{@width}x#{@height}&zoom=#{@zoom}&sensor=false\">"
                elsif (@engine == 'google_js' || @engine == 'openstreetmap')
                    return "<div id=\"jekyll-mapping\" style=\"height:#{@height}px;width:#{@width}px;\"></div>"
                end
            end
        end
    end

    class MapIndexTag < Liquid::Tag
        
        def initialize(tag_name, text, tokens)
            @config = Jekyll.configuration({})['mapping']
            @engine = @config['provider']
            @key = @config['api_key']
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
            if (@engine == 'google_js' || @engine == 'openstreetmap')
                return "<div id=\"jekyll-mapping-index\" style=\"height:#{@height}px;width:#{@width}px;\"></div>"
            end            
        end
    end
    class MapIndexScriptData < Liquid::Tag
        
        def initialize(tag_name, text, tokens)
            @data = {}
            @data['config'] = Jekyll.configuration({})['mapping']
            super
        end

        def render(context)
            @data['posts'] = []
            for post in context.registers[:site].posts
                if post.data.has_key?('mapping')
                    postinfo = {}
                    postinfo['title'] = post.data['title']
                    postinfo['link'] = post.url
                    postinfo['mapping'] = post.data['mapping']
                    @data['posts'] << postinfo
                end
            end
            if (@engine == 'google_js' || @engine == 'openstreetmap')
                return @data.to_json
            end            
        end
    end
end

Liquid::Template.register_tag('render_map', Jekyll::MapTag)
Liquid::Template.register_tag('render_index_map', Jekyll::MapIndexTag)
Liquid::Template.register_tag('map_index_data', Jekyll::MapIndexScriptData)