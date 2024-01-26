

<cfset VARIABLES.plnid = 343>

<cfset geoJsonLine = createobject("component", "SerializeGeoJson").getLine(VARIABLES.plnid)>
<cfset file_name = "geojson_line_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var line = #geoJsonLine#" nameconflict="overwrite" />


<cfset geoJsonTowers = createobject("component", "SerializeGeoJson").getPoints(VARIABLES.plnid)>
<cfset file_name = "geojson_tower_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var towers = #geoJsonTowers#" nameconflict="overwrite" />

<cfset geoJsonSpans = createobject("component", "SerializeGeoJson").getSpans(VARIABLES.plnid)>
<cfset file_name = "geojson_span_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var spans = #geoJsonSpans#" nameconflict="overwrite" />

