


<cfquery name="qMtsLineAll" datasource="postgis">
SELECT      DISTINCT "PL_NO"
FROM        mts_line
ORDER BY    "PL_NO"
</cfquery>


<cfset objSerializeGeoJson = createobject("component", "leaflet.com.tygerella.SerializeGeoJson").init()>

<!---
<cfdump var="#objSerializeGeoJson#">
<cfabort>
--->

<cfoutput>
<cfloop query="qMtsLineAll">

    <cfset id_buffer = 5>
    <cfset data_directory = expandpath("data")>
    <cfset id_length = id_buffer-len(qMtsLineAll.PL_NO)>

    <cfset id_name = qMtsLineAll.PL_NO>
    <cfloop index="b" from="1" to="#id_length#">
        <cfset id_name = listPrepend(id_name, "0", "", true)&id_name>
    </cfloop>

    <cfset line_name = "mts_span_"&id_name&".geojson">

    <cftry>
        <cfset geo_line_data = objSerializeGeoJson.getSpans(qMtsLineAll.PL_NO)>
        <cfset geojson_line_data = toString(serializeJSON(geo_line_data), "UTF-8")>
        <cffile action="write" file="#expandpath('data/'&line_name)#" output="#geojson_line_data#" nameconflict="overwrite" />
        #id_name# : GOOD <br /> 
    <cfcatch>
        #id_name# : BAD <br />
    </cfcatch>
    </cftry>


</cfloop>
</cfoutput>








