<script type="text/javascript">
var jekyllMapping = (function () {
    'use strict';
    var settings;
    var obj = {
        plotArray: function(locations) {
            function jekyllMapListen (m, s) {
                if (s.link) {
                    google.maps.event.addListener(m, 'click', function() {
                        window.location.href = s.link;
                    });
                }
            }
            var bounds = new google.maps.LatLngBounds(), markers = [], s, l, m;
            while (locations.length > 0) {
                s = locations.pop();
                l = new google.maps.LatLng(s.latitude, s.longitude);
                m = new google.maps.Marker({
                    position: l,
                    map: this.map,
                    title: s.title
                });
                markers.push(m);
                bounds.extend(l);                
                jekyllMapListen(m, s);
            }
            this.map.fitBounds(bounds);
        },
        indexMap: function () {
            this.plotArray(settings.pages);
        },
        pageToMap: function () {
            if (typeof(settings.latitude) !== 'undefined' && typeof(settings.longitude) !== 'undefined') {
                this.options.center = new google.maps.LatLng(settings.latitude, settings.longitude);

                var mainMarker = new google.maps.Marker({
                    position: this.options.center,
                    map: this.map,
                    title: "{{ page.title }}"
                });
                this.map.setCenter(this.options.center);
            }     

            if (settings.locations instanceof Array) {
                this.plotArray(settings.locations);
            }

            if (settings.kml) {
                var mainLayer = new google.maps.KmlLayer(settings.kml);
                mainLayer.setMap(this.map);
            }
            
            if (settings.layers) {
                var layers = [];
                while (settings.layers.length > 0){
                    var m = new google.maps.KmlLayer(settings.layers.pop());
                    layers.push(m);
                    m.setMap(this.map);
                }
            }
        },
        mappingInitialize: function () {
            this.options = {
                zoom: 10,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                center: new google.maps.LatLng(0, 0)
            };

            this.map = new google.maps.Map(document.getElementById("jekyll-mapping"), this.options);

            if (settings.pages) {
                this.indexMap();
            } else {
                this.pageToMap();
            }
        },
        loadScript: function (set) {
            settings = set;
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.src = "http://maps.googleapis.com/maps/api/js?key=" + settings.api_key + "&sensor=false&callback=jekyllMapping.mappingInitialize";
            document.body.appendChild(script);
        }
    };
    return obj;
}());
</script> 