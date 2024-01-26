<!doctype html>
<html lang="en">

    <cfparam name="URL.pl_number" type="numeric" default="18" />

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
   
    <style>
      #map { width: 750px; height: 250px; }
    </style>

  </head>
  <body>





<div id="map" style="width:100%;height:500px;"></div>



<script src="leaflet/dist/leaflet.js"></script>


<cfoutput>
  <script src="geojson_towers_#URL.pl_number#.geojson"></script>
<script src="geojson_spans_#URL.pl_number#.geojson"></script>
<script src="geojson_line_#URL.pl_number#.geojson"></script>
</cfoutput>
<script src="geojson_sites_ALL.geojson"></script>

<script>


  <cfoutput>
      var lineLat = #middle_record.LAT#;
      var lineLon = #middle_record.LONGX#;
  </cfoutput>

  var map = L.map('map').setView([lineLat, lineLon], 14); // Set the initial center and zoom level


  
  var selection;
  var selectedLayer;
  var selectedFeature;


  var geojsonLineGroup = L.layerGroup();
  var geojsonSpanGroup = L.layerGroup();
  var geojsonTowerGroup = L.layerGroup();
  var geojsonSiteGroup = L.layerGroup();
    
    

function onEachSpan(feature, layer) {

  layer.on('click', function(e) {

    selection = e.target;
    selectedLayer = layer;
    selectedFeature = feature;
    //map.fitBounds(layer.getBounds());
    //map.flyToBounds(layer.getBounds(), 12);
    
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

}


function onEachTower(feature, layer) {
    layer.on('click', function(e) {
      
      //layer.bindPopup(feature.properties.LENGTH);
      //console.log(layer);
      //L.DomEvent.stopPropagation(e);
  });
  //console.log(layer);
  // does this feature have a property named popupContent?
  layer.bindPopup("Wow!");
  //layer.draggable = true;
  geojsonTowerGroup.addLayer(layer);
}

function onEachLine(feature, layer) {
  layer.on('click', function(e) {
      e.target.setStyle({
          stroke: true,
          color: "#FF10F0",
          //weight: 7,
          //opacity: 1,
        });
      //layer.bindPopup(feature.properties.LENGTH);
      //console.log(feature);
      //L.DomEvent.stopPropagation(e);
    });
  geojsonLineGroup.addLayer(layer);
  //var bounds = layer.getBounds();
  //map.fitBounds(bounds);

}


function onEachSite(feature, layer) {
  layer.on('click', function(e) {
        //console.log(layer);
    });
    layer.bindPopup(feature.properties.site_type);
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
	maxZoom: 19,
	attribution: 'Map <a href="https://memomaps.de/">memomaps.de</a> <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
});


var line_400V = {
  "color": "#39FF14",
  //"weight": 10
};

L.geoJSON(line, {
  onEachFeature: onEachLine
}).addTo(map);

var geojsonMarkerOptions = {
    radius: 8,
    fillColor: "#000",
    color: "#000",
    weight: 1,
    opacity: 1,
    fillOpacity: 0.8
};

L.geoJSON(towers, {
  onEachFeature: onEachTower,
  pointToLayer: function (feature, latlng) {
        return L.circleMarker(latlng, geojsonMarkerOptions);
    }
});

L.geoJSON(spans, {
    onEachFeature: onEachSpan
});

L.geoJSON(sites, {
    onEachFeature: onEachSite
}).addTo(map);


var basemaps = {
  "OPNV Karte": OPNVKarte,
  "OSM": osm,
  "OSM Humanitarian": osmHumanitarian
};

var overlayMaps = {
  "Line": geojsonLineGroup,
  "Towers": geojsonTowerGroup,
  "Spans": geojsonSpanGroup,
  "Sites": geojsonSiteGroup
};
  
  L.control.layers(basemaps, overlayMaps).addTo(map);
  L.control.scale().addTo(map);



</script>

</body>
</html>

