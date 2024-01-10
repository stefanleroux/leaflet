

<cfparam name="URL.pl_number" type="numeric" default="341" />

<cfset geoJsonLine = createobject("component", "SerializeGeoJson").getLine(URL.pl_number)>
<!--- <cfset file_name = "geojson_line_#URL.pl_number#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var spans = #geoJson#" nameconflict="overwrite" /> --->


<cfdump var="#serializejson(geoJsonLine)#">