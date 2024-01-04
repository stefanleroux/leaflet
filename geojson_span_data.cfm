
<cfparam name="URL.pl_number" type="numeric" default="101" />

<cfset geoJson = createobject("component", "SerializeGeoJson").getSpans(URL.pl_number)>
<cfset file_name = "geojson_spans_#URL.pl_number#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var spans = #geoJson#" nameconflict="overwrite" />


<cfdump var="#serializejson(geoJson)#">