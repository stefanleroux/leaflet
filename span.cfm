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
    <script src="geojson_towers_#URL.pl_number#.geojson" type="text/javascript"></script>
    <script src="geojson_spans_#URL.pl_number#.geojson" type="text/javascript"></script>
</cfoutput>

<script>
//var MARKERS_MAX = 4;

<cfoutput>
//var map = L.map('map').setView([#middle_record.LAT#,#middle_record.LONGX#], 13);
let lineLat = #middle_record.LAT#;
let lineLon = #middle_record.LONGX#;
</cfoutput>

var map = L.map('map', {
    center: [lineLat, lineLon],
    zoom: 13,
    //layers: []
});

var spanGroup = L.layerGroup().addTo(map);

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
function onEachSpan(feature, layer) {
    //console.log(layer);
    // does this feature have a property named popupContent?
    L.layerGroup
    if (feature.properties && feature.properties.start) {
        layer.bindPopup(feature.properties.flocid);
        spanGroup.addLayer(layer);
    }
}



/* L.geoJSON(towers, {
    onEachFeature: onEachTower
}).addTo(map); */


L.geoJSON(spans, {
    onEachFeature: onEachSpan
}).addTo(map);

</script>