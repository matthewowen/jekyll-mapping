var jekyllMapping = (function () {
    'use strict';
    return {
        mappingInitialize: function () {
            var maps = document.getElementsByClassName("jekyll-mapping");
            for ( var i = 0; i < maps.length; i++ ) {

                var config    = JSON.parse(maps[i].getAttribute("data-mapinfo")),
                    options   = {
                    zoom: zoom,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                    }, 
                    mainMarker;

                if (config.lat && config.lon) {
                    options.center = new google.maps.LatLng(lat, lon);
                    map = new google.maps.Map(maps[i], options);
                    mainMarker = new google.maps.Marker({
                        position: options.center,
                        map: map,
                        title: title
                    });
                } else {
                    options.center = new google.maps.LatLng(0, 0);
                    map = new google.maps.Map(maps[i], options);
                }

                if (config.locations) {
                    var bounds = new google.maps.LatLngBounds(), markers = [], s, l, m;
                    while (config.locations.length > 0) {
                        s = config.locations.pop();
                        l = new google.maps.LatLng(s.latitude, s.longitude);
                        m = new google.maps.Marker({
                            position: l,
                            map: map,
                            title: s.title
                        });
                        markers.push(m);
                        bounds.extend(l);
                    }
                    map.fitBounds(bounds);
                }


                if (config.layers) {
                    var mapLayers = [];
                    while (layers.length > 0){
                        var m = new google.maps.KmlLayer(layers.pop());
                        mapLayers.push(m);
                        m.setMap(map);
                    }
                }
            }
        },
        loadScript: function () {
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.src = "http://maps.googleapis.com/maps/api/js?key=" +
                jekyllMappingAPIKey +
                "&sensor=false&callback=jekyllMapping.mappingInitialize";
            document.body.appendChild(script);
        }
    };
}());

window.onload = function() { jekyllMapping.loadScript(); };