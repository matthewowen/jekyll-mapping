# Jekyll Mapping

Jekyll mapping is a plugin for Jekyll that lets you easily set a Lat/Long location for a page or post, and then embed a map based on that position.

## Supported providers

### Google static image

    mapping:
        provider: google_static

https://developers.google.com/maps/documentation/staticmaps/

Embeds a static image, centered on the specificed location, with a marker at the specified location

### Google JS API

    mapping:
        provider: google_js

https://developers.google.com/maps/documentation/javascript/

Embeds an interactive map using the V3 JS API. Using this requires an API key to be specified within _config.yml

### OpenStreetMap

    mapping:
        provider: openstreetmap

Uses [OpenStreetMap](http://www.openstreetmap.org/) and [OpenLayers](http://openlayers.org/) to provide interactive maps. Doesn't require an API key.

## Configuration

To use, include configuration information in _config.yml. At minimum, specify a provider:

    mapping:
        provider: google_static

If desired, set default dimensions for maps and a custom zoom level (the default zoom level is 10):

    mapping:
        provider: openstreetmap
        zoom: 8
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

Put the contents of '_includes' in your '_includes' directory and the contents of '_plugins' in your '_plugins' directory (or just copy the directories if you don't have those directories yet).

Set 'latitude' and 'longitude' values in the YAML front matter of pages and posts:

    latitude: 51.101
    longitude: 0.1

Include the render_map tag in your templates where you'd like the map to appear:

    {% render_map %}

Optionally, specify the width for the map here:
    
    {% render_map 500,500 %}

Include the required JavaScript at the foot of your templates:

    {% include jekyll-mapping %}
    </body>

You don't need to wrap the above in any if statements - jekyll-mapping won't output anything if the page doesn't have both a latitude and longitude set.

Enjoy!

## Future things to do

* Allow for custom markers to be set (both for the site as a whole and for specific pieces of content)
* More mapping providers (Bing?)
* More flexibility (allow specific zoom levels to be set for individual content items, if desired)
* Any more ideas? Please suggest them.