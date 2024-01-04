<!doctype html>
<html lang="en">


  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LINE</title>
    <link rel="stylesheet" href="leaflet/dist/leaflet.css" />
    <script src="leaflet/dist/leaflet.js"></script>
    <style>
      #map { width: 100%; height: 550px; }
    </style>
    <script src="htmx/dist/htmx.min.js"></script>
    <script src="js/jquery-3.7.1.min.js"></script>
  </head>
  <body>


<!---
hx-get="create_geojson.cfm" hx-trigger="load"
--->

    <div id="map"></div>

    <cfoutput>
    <script src="geojson_line_STATIC.geojson" type="text/javascript"></script>

</cfoutput>

<script>
//var MARKERS_MAX = 4;

var map = L.map('map', {
    center: [-32.5374952,25.8337235],
    zoom: 13,
    //layers: []
});

// create and add osm tile layer
var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  });
  osm.addTo(map);
  
  // create osm humanitarian layer (not adding it to map)
  var osmHumanitarian = L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  });
  

var lineGroup = L.layerGroup().addTo(map);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);


/* function onEachTower(feature, layer) {
    // does this feature have a property named popupContent?
    if (feature.properties && feature.properties.prefix) {
        layer.bindPopup(feature.properties.prefix);
    }
}
 */
function onEachPoint(feature, layer) {
    layer.on('click', function(e) {
        e.target.setStyle({
            stroke: true,
            color: 'gold',
            weight: 7,
            opacity: 0.7,
          });
        layer.bindPopup(feature.properties.LENGTH);
        L.DomEvent.stopPropagation(e);
    });

    lineGroup.addLayer(layer);
    var bounds = layer.getBounds();
    var latLng = bounds.getCenter();
    map.setView(latLng, 12.5);
}

L.geoJSON(line, {
    onEachFeature: onEachPoint
}).addTo(map);

var basemaps = {
    "OSM": osm,
    "OSM Humanitarian": osmHumanitarian
  };
  

var overlayMaps = {
    "Towers": lineGroup
  };
  
  L.control.layers(basemaps, overlayMaps).addTo(map);

</script>