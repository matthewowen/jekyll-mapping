<script src="http://www.openlayers.org/api/OpenLayers.js"></script>
<script type="text/javascript">
var jekyllMapping = (function () {
    'use strict';
    var settings;
    var obj = {
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
                this.markers.addMarker(m)
                bounds.extend(l);
                jekyllMapListen(m, s);
            }
            this.map.zoomToExtent(bounds);
        },
        indexMap: function () {
            this.plotArray(settings.pages);
        },
        pageToMap: function () {
            if (typeof(settings.latitude) !== 'undefined' && typeof(settings.longitude) !== 'undefined') {
                this.center = new OpenLayers.LonLat(settings.longitude, settings.latitude).transform( new OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
                this.map.setCenter(this.center, settings.zoom);
                this.markers.addMarker(new OpenLayers.Marker(this.center));
            }     

            if (settings.locations instanceof Array) {
                this.plotArray(settings.locations);
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
                    this.map.addLayer(m)
                }
            }
        },
        mappingInitialize: function (set) {
            settings = set;

            this.markers = new OpenLayers.Layer.Markers("Markers"),
            this.map = new OpenLayers.Map("jekyll-mapping");
            this.map.addLayer(new OpenLayers.Layer.OSM());
            this.map.addLayer(this.markers);

            if (settings.pages) {
                this.indexMap();
            } else {
                this.pageToMap();
            }
        }        
    };
    return obj;
}());
</script>
