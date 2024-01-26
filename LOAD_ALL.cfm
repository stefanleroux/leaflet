

<cfset VARIABLES.plnid = 343>

<cfset data_directory = "data/#VARIABLES.plnid#">

<cfif not directoryExists(expandpath(data_directory))>
    <cfdirectory action="create" directory="#data_directory#" />
</cfif>

<cfset geoJsonLine = createobject("component", "leaflet.com.tygerella.SerializeGeoJson").getLine(VARIABLES.plnid)>
<cfset file_name = "data/#VARIABLES.plnid#/mts_line_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var line = #toString(serializeJSON(geoJsonLine), "UTF-8")#" nameconflict="overwrite" />

<cfset geoJsonTowers = createobject("component", "leaflet.com.tygerella.SerializeGeoJson").getTowers(VARIABLES.plnid)>
<cfset file_name = "data/#VARIABLES.plnid#/mts_tower_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var towers = #toString(serializeJSON(geoJsonTowers), "UTF-8")#" nameconflict="overwrite" />

<cfset geoJsonSpans = createobject("component", "leaflet.com.tygerella.SerializeGeoJson").getSpans(VARIABLES.plnid)>
<cfset file_name = "data/#VARIABLES.plnid#/mts_span_#VARIABLES.plnid#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var spans = #toString(serializeJSON(geoJsonSpans), "UTF-8")#" nameconflict="overwrite" />

