<script src="http://www.openlayers.org/api/OpenLayers.js"></script>
<script type="text/javascript">
var jekyllMapping = (function () {
    'use strict';
    var settings = {% yaml_to_json mapping %};
    return {
        mappingInitialize: function() {
            var center,
            markers = new OpenLayers.Layer.Markers("Markers"),
            map = new OpenLayers.Map("jekyll-mapping");
            map.addLayer(new OpenLayers.Layer.OSM());
            map.addLayer(markers);

            if (typeof(settings.latitude) !== 'undefined' && typeof(settings.longitude) !== 'undefined') {
                center = new OpenLayers.LonLat(settings.longitude, settings.latitude).transform( new OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
                map.setCenter(center, settings.zoom);
                markers.addMarker(new OpenLayers.Marker(center));
            }

            if (settings.locations instanceof Array) {
                var s, l, m, bounds = new OpenLayers.Bounds();
                while (settings.locations.length > 0) {
                    s = settings.locations.pop();
                    l = new OpenLayers.LonLat(s.longitude, s.latitude).transform( new OpenLayers.Projection("EPSG:4326"), new OpenLayers.Projection("EPSG:900913"));
                    markers.addMarker(new OpenLayers.Marker(l))
                    bounds.extend(l);
                }
                map.zoomToExtent(bounds)
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
                    map.addLayer(m)
                }
            }
        }
    };
}());

jekyllMapping.mappingInitialize();
</script>