<!doctype html>
<html lang="en">

    <cfparam name="URL.pl_number" type="numeric" default="343" />

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link rel="stylesheet" href="../../js/leaflet/dist/leaflet.css" />
    <link rel="stylesheet" href="../../css/bootstrap.min.css" />
    <script src="../../htmx/dist/htmx.min.js"></script>
    <style>
      #map { width: 100%; height: 550px; }
    </style>

  </head>
  <body>


    
<div class="container">
  <div class="row">
    <div class="col-sm-12">
      <div id="map"></div>
    </div>
    <div class="col-sm-4">Zoom: <span id="zoom_level"></span></div>
    <div class="col-sm-4">B</div>
    <div class="col-sm-4">C</div>
  </div>

    <div class="offcanvas offcanvas-end" tabindex="-1" id="featureDetailsRight" aria-labelledby="offcanvasRightLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasRightLabel">Feature details</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div class="offcanvas-body" id="feature_details"></div>
    </div>

</div>


<script src="../../js/leaflet/dist/leaflet.js"></script>
<script src="../../js/leaflet/dist/leaflet.marker-resize-svg.js"></script>
<script src="../../js/leaflet/dist/leaflet.textpath.js"></script>
<script src="../../js/bootstrap/bootstrap.bundle.min.js"></script>
<script src="../../js/leaflet/dist/leaflet.geometryutil.js"></script>


<cfoutput>
<script src="../../data/343/mts_line_#URL.pl_number#.geojson"></script>
<script src="../../data/343/mts_span_#URL.pl_number#.geojson"></script>
<script src="../../data/343/mts_tower_#URL.pl_number#.geojson" type="text/javascript"></script>
</cfoutput>


<script>

  var map = L.map('map');
  const myFeatureProperties = document.getElementById("featureDetailsRight");
  var propsOffcanvas = new bootstrap.Offcanvas(myFeatureProperties);
  const myFeaturePropertiesLabel = document.getElementById("offcanvasRightLabel");
  
  var selection;
  var selectedLayer;
  var selectedFeature;

  var geojsonLineGroup = L.layerGroup().addTo(map);
  var geojsonSpanGroup = L.layerGroup();
  var geojsonTowerGroup = L.layerGroup();
 
  var towerIcon = L.icon({
    iconUrl: '../../img/tower_warning_sml.svg',
    iconSize: [35, 35],
    iconAnchor: [5, 25],
    popupAnchor: [-3, -12]
  });


function onEachSpan(feature, layer) {

  layer.on('click', function(e) {

    selection = e.target;
    selectedLayer = layer;
    selectedFeature = feature;


    //if(selectedFeature.filter())

    /*e.target.feature.properties.selected = true;
    e.target.setStyle({
      stroke: true,
      color: '#C2CB00',
      weight: 7,
      opacity: 0.7,
    });*/
    //console.log(selection);
    //L.DomEvent.stopPropagation(e);  
  });

  geojsonSpanGroup.addLayer(layer);
}


function onEachTower(feature, layer) {
  layer.on('mouseover', function(m) {
    //console.log(feature);
    //marker
  });
  layer.on('click', function(e) {
    htmx.ajax('GET', 'tower/index.cfm?plnid='+feature.properties.PL_NO+'&twrid='+feature.properties.TWR_NO, '#feature_details');
    //myFeaturePropertiesLabel.innerHTML = feature.properties.item;
    propsOffcanvas.show();
  });
  //console.log(layer)
  //L.marker(layer.feature.geometry.coordinates,{icon:towerIcon}).addTo(map);
  layer.bindPopup(feature.properties.TWR_PREF);
  geojsonTowerGroup.addLayer(layer);
}

  function onEachLine(feature, layer) {
    layer.on('click', function(e) {
      var selected = e.target;
      console.log(selected);
      //selection.setStyle({stroke: true, color: '#fe01b1',});
      selected.setStyle({stroke: true, color: '#fe01b1',});
      /*
      if(selected) {
        lineGeoJson.resetStyle(selected);
      }else{
        selection.setStyle({stroke: true, color: '#fe01b1',});
      }
      */      
  }); 
  layer.setStyle({
    stroke: true,
    color: '#65FE08',
  });

  //console.log(feature);
  layer.setText(feature.properties.STANDARD_LABEL, {center:true, orientation:180, attributes: {stroke: 'black'}});
  geojsonLineGroup.addLayer(layer);
  var bounds = layer.getBounds();
  map.fitBounds(bounds);
}

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

//supplied by memomaps.de
var OPNVKarte = L.tileLayer('https://tileserver.memomaps.de/tilegen/{z}/{x}/{y}.png', {
	maxZoom: 18,
	attribution: 'Map <a href="https://memomaps.de/">memomaps.de</a> <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
});

//var mCenter = L.getBounds(line);

var lineGeoJson = L.geoJSON(line, {
  onEachFeature: onEachLine
}).addTo(map);


L.geoJSON(towers, {
  onEachFeature: onEachTower,
   pointToLayer: function (feature, latlng) {
      return L.marker(latlng, {icon: towerIcon});
    }
});

L.geoJSON(spans, {
    onEachFeature: onEachSpan
});


var basemaps = {
  "OPNV Karte": OPNVKarte,
  "OSM": osm,
  "OSM Humanitarian": osmHumanitarian
};

var overlayMaps = {
  "Line": geojsonLineGroup,
  "Towers": geojsonTowerGroup,
  "Spans": geojsonSpanGroup
};
  
L.control.layers(basemaps, overlayMaps).addTo(map);
L.control.scale(200,true,false,false).addTo(map);


var geojsonMarkerOptions = {
    radius: 8,
    fillColor: "#FFEF00",
    color: "#FFEF00",
    weight: 1,
    opacity: 1,
    fillOpacity: 0.8
};


map.on('zoomend', function() {
  var currentZoom = map.getZoom();
  document.getElementById("zoom_level").innerHTML = currentZoom;
});



 
/*
var ar_icon_1 = ...;
var ar_icon_2 = ...;
var ar_icon_1_double_size = ...;
var ar_icon_2_double_size = ...;


map.on('zoomend', function() {
    var currentZoom = map.getZoom();
    if (currentZoom > 12) {
        all_testptLayer.eachLayer(function(layer) {
            if (layer.feature.properties.num < 0.5)
                return layer.setIcon(ar_icon_1);
            else if (feature.properties.num < 1.0)
                return layer.setIcon(ar_icon_2);
        });
    } else {
        all_testptLayer.eachLayer(function(layer) {
            if (layer.feature.properties.num < 0.5)
                return layer.setIcon(ar_icon_1_double_size);
            else if (feature.properties.num < 1.0)
                return layer.setIcon(ar_icon_2_double_size);
        });
    }
});
*/

/*
Todo: 20240119 - Show a context menu here like a button dropdown to select nearby objects of tolerance did not allow
map.on('click', function(p) {
  console.log(p);
    pointToLayer: function findNearbyFeatures() {
        return L.circleMarker(latlng, geojsonMarkerOptions);
    }
});
*/


</script>

</body>
</html>

