

<cfquery name="qLine" datasource="postgis" maxrows="10">
    SELECT
	mts_line."PL_NO",
	mts_line."PL_START",
	mts_line."PL_END",
	mts_line."LINE_NO",
	mts_line."D_VOLT",
	mts_line."O_VOLT",
	mts_line."SERV_WID",
	mts_line."LENGTH",
	mts_line."PLANT_ID",
	mts_line."CLNC_OLD",
	mts_line."STATUS",
	mts_line."LAT1",
	mts_line."LONG1",
	mts_line."LAT2",
	mts_line."LONG2",
	mts_line."LEGAL_AUDIT",
	mts_line."LATM",
	mts_line."LONGM",
	mts_line."AUDIT_DATE",
	mts_line."TECH_AUDIT",
	mts_line."ID",
	mts_line."BIRD_STATUS",
	mts_line."OPTIC_FIBRE",
	mts_line."CIRCUIT",
	mts_line."STANDARD_LABEL",
	mts_line."FLOC_ID",
	mts_line."SERIES_CAPACITOR",
	mts_line."AS_BUILT_DOC_REF",
	mts_line."AS_BUILT_CHECK",
	mts_line."COMMENTS",
	mts_line."CLNC" 
FROM
	mts_line 
WHERE
	mts_line."PL_NO" = 280
</cfquery>

<cfquery name="qPoint" datasource="postgis">
SELECT
    "LAT",
    "LONGX",
    "HEIGHT" 
FROM
    mts_tower 
WHERE
    "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#qLine.PL_NO#" />
ORDER BY
    "TOWER_NO"
</cfquery>

<cfset geoJsonObject = [:]>
<cfset geoJsonObject["type"] = "FeatureCollection">
<cfset geoJsonObject["features"] = []>

<cfset feature = structnew("ordered")>
<cfset feature["type"] = "Feature">
<cfset feature["geometry"] = [:]>
<cfset feature["geometry"]["type"] = "LineString">

<cfset feature["geometry"]["coordinates"] = arraynew()>
<cfloop query="qPoint">

    <cfset pointArr = arraynew()>
    <cfset pointArr[1] = qPoint.LONGX>
    <cfset pointArr[2] = qPoint.LAT>
    <!--- <cfset pointArr[3] = qPoint.HEIGHT> --->
    <cfset arrayappend(feature["geometry"]["coordinates"], pointArr)>
</cfloop>

<cfset feature["properties"] = [:]>
<cfset feature["properties"]["item"] = "Line">
<cfset feature["properties"]["number"] = qLine.LINE_NO>
<cfset feature["properties"]["start"] = qLine.PL_START>
<cfset feature["properties"]["end"] = qLine.PL_END>
<cfset feature["properties"]["LENGTH"] = qLine.length>


<cfset arrayappend(geoJsonObject["features"], feature)>
<cfset myGeoJasonObj = toString(serializeJSON(geoJsonObject), "UTF-8")>

   

<!--- <cfdump var="#geoJsonObject#"> --->
    <cfoutput>var line = #myGeoJasonObj#</cfoutput>