# Jekyll Mapping

Jekyll mapping is a plugin for Jekyll that lets you easily add maps to content.

## Supported providers

### Google static image

provider: google_static
https://developers.google.com/maps/documentation/staticmaps/

Embeds a static image, centered on the specificed location, with a marker at the specified location

### Google JS API

provider: google_js
https://developers.google.com/maps/documentation/javascript/

Embeds an interactive map using the V3 JS API. Using this requires an API key to be specified within _config.yml

### OpenStreetMap
Uses [OpenStreetMap](http://www.openstreetmap.org/) and [OpenLayers](http://openlayers.org/) to provide interactive maps. Doesn't require an API key.

## Configuration

To use, include configuration information in _config.yml. At minimum, specify a provider:

    mapping:
        provider: google_static

If desired, set default dimensions for the map, and/or a zoom level for maps:

    mapping:
        provider: openstreetmap
        zoom: 10
        dimensions:
            width: 600
            height: 400

If using Google JS API, include an API key:

    mapping:
        provider: google_js
        api_key: 123456
        zoom: 10
        dimensions:
            width: 600
            height: 400

Set 'latitude' and 'longitude' values in the YAML front matter of pages and posts:

    latitude: 51.101
    longitude: 0.1

Include the render_map tag in your templates where you'd like the map to appear:

    {% render_map %}

Optionally, specify the width for the map here:
    
    {% render_map 500,500 %}

Include any required JavaScript at the foot of your templates:

    {% include jekyll-mapping %}

Enjoy!

