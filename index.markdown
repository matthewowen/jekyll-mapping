---
layout: page
---

# Jekyll Mapping

Jekyll mapping is a plugin for Jekyll that takes away the pain of using Google Maps and OpenStreetMap on your site. Here are some of the things it makes it easy to do:

* Give each piece of content a location, allowing you to:
    * Display a map on each page, showing the location set for the content (perfect if you want to list events on your website, and embed a map showing where they are)
    * Display a map, with a marker for each piece of content linking users through to the page (perfect if you're a business and you want to list all of your locations so that users can click through to the nearest one)
* Set multiple locations on a single piece of content and map them all (perfect if you want a map showing all of your company's offices)
* Set a KML layer (or multiple KML layers) on a piece of content and display on a map. This one offers a world of possibilities:
    * Show directions or routes
    * Display up to the minute data coming from a continually updating feed
    * Display data overlays on map as a form of data presentation

## Examples

### Plot your Jekyll site's content on a map

Try clicking on the markers...

<div>
{% render_index_map %}
</div>

### Set multiple locations on a single piece of Jekyll content, and map them all:

[See the example...](/jekyll-mapping/2012/07/15/multiple-locations.html)

### Display a KML overlay on a piece of Jekyll content

[See the example...](/jekyll-mapping/2012/07/15/kml-layer.html)

## Supported providers

### Google static image

    mapping:
        provider: google_static

https://developers.google.com/maps/documentation/staticmaps/

Embeds a static image, centered on the specifced location, with a marker at the specified location. This provider doesn't have as much flexibilitity, but it's easy to set up

### Google JS API

    mapping:
        provider: google_js

https://developers.google.com/maps/documentation/javascript/

Embeds an interactive map using the V3 JS API. Using this requires an API key to be specified within \_config.yml (and you'll face usage limits if you don't want to pay money)

### OpenStreetMap

    mapping:
        provider: openstreetmap

Uses [OpenStreetMap](http://www.openstreetmap.org/) and [OpenLayers](http://openlayers.org/) to provide interactive maps. Doesn't require an API key, and doesn't come with usage limits (but use it responsibly)

## Basic usage

To use, include configuration information in \_config.yml. At minimum, specify a provider:

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

Set the relevant values in the YAML front matter of pages and posts:

    mapping:
        latitude: 51.101
        longitude: 0.1

Include the render_map tag in your templates where you'd like the map to appear:

    {{ "{% render_map " }}%}

Optionally, specify the width for the map here:

    {{ "{% render_map 500,500 " }}%}

Include the required JavaScript at the foot of your templates:

    {{ "{% include jekyll_mapping.html " }}%}
    </body>

You don't need to wrap the above in any if statements - jekyll-mapping won't output anything if it isn't supposed to.

Enjoy!

## Further usage

At it's most basic, you can just set a latitude and longitude for a piece of content. In this case, it'll just plot that location on a map. However, you can do some other exciting things too!

### Multiple Locations

If you set multiple locations, they'll all be mapped and the map will be zoomed and panned to fit them. You can even set a link on them (and have them link to content). Use like so:

    mapping:
        locations:
            - title: foo
              latitude: 10
              longitude: 10
            - title: bar
              link: /some/awesome/path
              latitude: -10
              longitude: -10

### KML

If you'd like to use KML, you can do that too. Just add 'layers' in a similar fashion:

    mapping:
        layers:
            - http://api.flickr.com/services/feeds/geo/?g=322338@N20&lang=en-us&format=feed-georss
            - http://gmaps-samples.googlecode.com/svn/trunk/ggeoxml/cta.kml

Right now, multiple locations works for both google_js and openstreetmap. KML definitely works for google_js and should work for openstreetmap, but needs more testing.

### Listing content

Use the following tag instead of {{ "{% render_map " }}%}:

    {{ "{% render_index_map " }}%}

This will plot a marker for every post on the site which has a latitude and longitude. Clicking on the marker will take you to the piece of content

Add configuration like so

    {{ "{% render_index_map 400,400:foo,bar " }}%}

This will render a 400x400 map, and only list posts from the categories 'foo' and 'bar'.

    {{ "{% render_index_map :foo,bar " }}%}

This will render a map at the default size, listing posts from the categories 'foo' and 'bar'

    {{ "{% render_index_map 400,400: " }}%}

This will render a 400x400 map, listing posts from all categories.