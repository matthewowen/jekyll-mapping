require 'json'

module Jekyll
    class JSONTag < Liquid::Tag
        
        def initialize(tag_name, text, tokens)
            @key = text.strip
            @hash_to_jsonify = Jekyll.configuration({})[@key]
            super
        end
        def render(context)
            @data = context['page'][@key]
            # this isn't a sophisticated merge. if there are nested
            # hashes, it'll completely overwrite them (so if you have
            # deeply nested settings in _config.yml that aren't replicated
            # in your page's settings, they'll get blatted).
            @data.each_pair do |k,v|
                @hash_to_jsonify[k] = v
            end
            return @hash_to_jsonify.to_json
        end
    end
end

Liquid::Template.register_tag('yaml_to_json', Jekyll::JSONTag)