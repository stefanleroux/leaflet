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
    <script src="leaflet/dist/leaflet.js"></script>
    <style>
      #map { width: 100%; height: 540px; }
    </style>
    <script src="htmx/dist/htmx.min.js"></script>
  </head>
  <body>


<!---
hx-get="create_geojson.cfm" hx-trigger="load"
--->

    <div id="map"></div>

    <cfoutput>
    <script src="geojson_towers_#URL.pl_number#.geojson" type="text/javascript"></script>
    <script src="geojson_spans_#URL.pl_number#.geojson" type="text/javascript"></script>
</cfoutput>

<script>

<cfoutput>
    let lineLat = #middle_record.LAT#;
    let lineLon = #middle_record.LONGX#;
</cfoutput>
    var map = L.map('map', {
        center: [lineLat, lineLon],
        zoom: 13,
        layers: []
    });  

    var spanGroup = L.layerGroup().addTo(map);
    var towerGroup = L.layerGroup().addTo(map);


    const tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
		maxZoom: 19,
		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	}).addTo(map);

    
    function forEachSpanFeature(feature, layer) {
        spanGroup.addLayer(layer);
        //var myLayerGroup = L.layerGroup();
        var latlngs = feature.geometry.coordinates;
        var towerSpan = L.polyline(latlngs).addTo(map);
        //console.log(typeof(towerSpan));
        //var towerSpan = L.polyline(latlngs).addTo(myLayerGroup);
    }

    function forEachTowerFeature(feature, layer) {
        spanGroup.addLayer(layer);
        //var myLayerGroup = L.layerGroup();
        var latlngs = feature.geometry.coordinates;
        var towerSpan = L.polyline(latlngs).addTo(map);
        //console.log(typeof(towerSpan));
        //var towerSpan = L.polyline(latlngs).addTo(myLayerGroup);
    }
    
    L.geoJSON(spans, {
        onEachFeature: forEachSpanFeature
    }).addTo(map);

    L.geoJSON(towers, {
        onEachFeature: forEachTowerFeature
    }).addTo(map);
    
      var overlayMaps = {
        "Spans": spanGroup,
        "Towers": towerGroup
      };
      
      L.control.layers(null, overlayMaps).addTo(map);
    
/*
    var myTowers = L.geoJSON().addTo(map);
    myTowers.addData(towers);

    var mySpans = L.geoJSON().addTo(map);
    mySpans.addData(spans);
*/
</script>