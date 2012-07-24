<script src="http://www.openlayers.org/api/OpenLayers.js"></script>
<script type="text/javascript">
var jekyllMapping = (function () {
    'use strict';
    var settings;
    var that = {
        plotArray: function(locations) {
            function jekyllMapListen (m, s) {
                if (s.link) {
                    m.events.register('click', m, function() {
                        window.location.href = s.link;
                    });
                }
            }
            var s, l, m, bounds = new OpenLayers.Bounds();
            while (locations.length > 0) {
                s = locations.pop();
                l = new OpenLayers.LonLat(s.longitude, s.latitude).transform( new OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
                m = new OpenLayers.Marker(l)
                that.markers.addMarker(m)
                bounds.extend(l);
                jekyllMapListen(m, s);
            }
            that.map.zoomToExtent(bounds)
        },
        indexMap: function () {
            that.plotArray(settings.pages);
        },
        pageToMap: function () {
            if (typeof(settings.latitude) !== 'undefined' && typeof(settings.longitude) !== 'undefined') {
                that.center = new OpenLayers.LonLat(settings.longitude, settings.latitude).transform( new OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
                that.map.setCenter(that.center, settings.zoom);
                that.markers.addMarker(new OpenLayers.Marker(that.center));
            }     

            if (settings.locations instanceof Array) {
                that.plotArray(settings.locations);
            }
            
            if (settings.layers) {
                while (settings.layers.length > 0){
                    var m = new OpenLayers.Layer.Vector("KML", {
                            strategies: [new OpenLayers.Strategy.Fixed()],
                            protocol: new OpenLayers.Protocol.HTTP({
                                url: settings.layers.pop(),
                                format: new OpenLayers.Format.KML({
                                    extractStyles: true,
                                    extractAttributes: true,
                                    maxDepth: 2
                                })
                            })
                        });
                    that.map.addLayer(m)
                }
            }
        },
        mappingInitialize: function (set) {
            settings = set;

            that.markers = new OpenLayers.Layer.Markers("Markers"),
            that.map = new OpenLayers.Map("jekyll-mapping");
            that.map.addLayer(new OpenLayers.Layer.OSM());
            that.map.addLayer(that.markers);

            if (settings.pages) {
                that.indexMap();
            } else {
                that.pageToMap();
            }
        }        
    };
    return that
}());
</script>