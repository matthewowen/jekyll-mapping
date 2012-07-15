
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
            @data = Jekyll.configuration({})['mapping']
            @engine = @data['provider']

            @config = Jekyll.configuration({})['mapping']
            @engine = @config['provider']
            @key = @data['api_key']
            @categories = nil
            if @data['dimensions']
                @width = @data['dimensions']['width']
                @height = @data['dimensions']['height']
            else
                @width = '600'
                @height = '400'
            end
            if not text.empty?
                dimensions = text.split(":").first.strip
                cat = text.split(":").last.strip
                if not dimensions.empty?
                    @width = dimensions.split(",").first.strip
                    @height = dimensions.split(",").last.strip
                end
                if not cat.empty?
                    @categories = []
                    for c in cat.split(",")
                        @categories << c
                    end
                end
            end
            super
        end

        def render(context)
            posts = []
            if @categories
                for cat in @categories
                    for post in context.registers[:site].categories[cat]
                        posts << post
                    end
                end
            else
                posts = context.registers[:site].posts
            end
            @data['pages'] = []
            for post in posts
                if post.data['mapping'].has_key?('latitude') && post.data['mapping'].has_key?('longitude')
                    postinfo = {}
                    postinfo['title'] = post.data['title']
                    if Jekyll.configuration({})['baseurl']
                        postinfo['link'] = "#{Jekyll.configuration({})['baseurl']}#{post.url.chars.first == "/" ? post.url[1..-1] : post.url}"
                    else
                        postinfo['link'] = post.url
                    end
                    postinfo['latitude'] = post.data['mapping']['latitude']
                    postinfo['longitude'] = post.data['mapping']['longitude']
                    @data['pages'] << postinfo
                end
            end

            if (@engine == 'google_js')
                return "
                    <div id='jekyll-mapping' style='height:#{@height}px;width:#{@width}px;'>
                    </div>
                    <script type='text/javascript'>
                        window.onload = function () { jekyllMapping.loadScript(#{@data.to_json}); };
                    </script>
                    "
            end   
            if (@engine == 'openstreetmap')
                return "
                    <div id='jekyll-mapping' style='height:#{@height}px;width:#{@width}px;'>
                    </div>
                    <script type='text/javascript'>
                        window.onload = function () { jekyllMapping.mappingInitialize(#{@data.to_json}); };
                    </script>
                    "
            end         
        end
    end
end

Liquid::Template.register_tag('render_map', Jekyll::MapTag)
Liquid::Template.register_tag('render_index_map', Jekyll::MapIndexTag)
