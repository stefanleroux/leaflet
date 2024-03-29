<!doctype html>
<html lang="en">

    <cfparam name="URL.pl_number" type="numeric" default="280" />

    <cfquery name="qTower" datasource="postgis">
        SELECT
            "TWR_PREF",
            "TWR_NO",
            "PL_NO",
            "ISABEND",
            "TWR_TYPE",
            "SUB_TYPE",
            "COND_ATT",
            "TUBE_NO",
            "SHT_NO",
            "CRD_TYPE",
            "DATA_SOURCE",
            "ACCURACY",
            "TOWER_NO",
            "LAT",
            "LONGX",
            "HEIGHT" 
        FROM
            mts_tower 
        WHERE
            "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#URL.pl_number#" /> 
        ORDER BY
            "TOWER_NO"
        </cfquery>
    
        <cfset middle_point = round(qTower.recordCount/2)>
    
        <cfset middle_record = queryGetRow(qTower, middle_point)>
    <!---
    <cfset geoJson = createobject("component", "SerializeGeoJson").getPoints("FeatureCollection", qTower)>
    <cfset file_name = "span_#url.pl_number#.geojson">
    <cffile action="write" file="#expandpath(file_name)#" output="var tower_line = #geoJson#" nameconflict="overwrite" />
    --->

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link rel="stylesheet" href="leaflet/dist/leaflet.css" />
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <script src="htmx/dist/htmx.min.js"></script>
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
    </div>

    <button class="btn btn-primary"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#featureDetailsRight"
            aria-controls="featureDetailsRight"
            hx-get="details/?tnid=11"
            hx-target="#feature_details"
            hx-swap="innerHTML">Feature details
    </button>

    <div class="offcanvas offcanvas-end" tabindex="-1" id="featureDetailsRight" aria-labelledby="offcanvasRightLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasRightLabel">Feature details</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div class="offcanvas-body" id="feature_details"></div>
    </div>

</div>


<script src="leaflet/dist/leaflet.js"></script>
<script src="js/leaflet/dist/leaflet.textpath.js"></script>

<cfoutput>
<script src="geojson_towers_#URL.pl_number#.geojson"></script>
<script src="geojson_spans_#URL.pl_number#.geojson"></script>
<script src="geojson_line_STATIC.geojson" type="text/javascript"></script>
</cfoutput>
<script src="js/bootstrap/bootstrap.bundle.min.js" type="text/javascript"></script>

<script>


  <cfoutput>
      var lineLat = #middle_record.LAT#;
      var lineLon = #middle_record.LONGX#;
  </cfoutput>

  var map = L.map('map').setView([lineLat, lineLon], 13); // Set the initial center and zoom level
  const myFeatureProperties = document.getElementById("featureDetailsRight");
  var propsOffcanvas = new bootstrap.Offcanvas(myFeatureProperties);
  const myFeaturePropertiesLabel = document.getElementById("offcanvasRightLabel");
  
  var selection;
  var selectedLayer;
  var selectedFeature;

  var geojsonLineGroup = L.layerGroup().addTo(map);
  var geojsonSpanGroup = L.layerGroup().addTo(map);
  var geojsonTowerGroup = L.layerGroup();//.addTo(map);
    
    

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
    console.log(selection);
    //L.DomEvent.stopPropagation(e);  
  });
  geojsonSpanGroup.addLayer(layer);
}


function onEachTower(feature, layer) {
  layer.on('click', function(e) {
    htmx.ajax('GET', 'details/?tnid='+feature.properties.number, '#feature_details');
    myFeaturePropertiesLabel.innerHTML = feature.properties.item;
    propsOffcanvas.show();
  });
  geojsonTowerGroup.addLayer(layer);
}

function onEachLine(feature, layer) {
  layer.on('click', function(e) {
      e.target.setStyle({
          stroke: true,
          color: '#fe01b1',
          weight: 7,
          opacity: 0.7,
        });
        console.log("Line click!!!");
      //layer.bindPopup(feature.properties.LENGTH);
      console.log(layer);
      //L.DomEvent.stopPropagation(e);
  }); 

  layer.setStyle({
      stroke: true,
      color: '#65FE08',
      weight: 5,
      opacity: 0.7,
  });
  layer.setText('Woooooow', { attributes: {stroke: 'black'}});
  geojsonLineGroup.addLayer(layer);
  //var bounds = layer.getBounds();
  //var latLng = bounds.getCenter();
  //map.setView(latLng, 12.5);
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



L.geoJSON(line, {
  onEachFeature: onEachLine
}).addTo(map);

L.geoJSON(towers, {
  onEachFeature: onEachTower
})//.addTo(map);

L.geoJSON(spans, {
    onEachFeature: onEachSpan
}).addTo(map);


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


</script>

</body>
</html>

