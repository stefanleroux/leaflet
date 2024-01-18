
<cfquery name="qSites" datasource="postgis">
SELECT
	site_name, 
	site_type, 
	date_captured, 
	site_no, 
	lat, 
	longx,
	clnc_old, 
	voltage, 
	facility_id, 
	abbrev, 
	floc_id, 
	clnc
FROM
	txs_site
	--where site_no = 2199
</cfquery>

<cfset sites = getSites()>

<cfdump var="#sites#"> --->



<!--- <cfdump var="#qSites#"> --->
<!--- <cfabort> --->


<cffunction name="getSites" access="public" returntype="any">

    <cfset var  geoJsonObject = structNew("ordered")>
    <cfset var  geoJsonObject["type"] = "FeatureCollection">
    <cfset var  geoJsonObject["features"] = arraynew(1)>

    <cfloop query="qSites">
        <cfset currentSite = queryGetRow(qSites,qSites.currentrow)>
        <cfset feature = structnew("ordered")>
        <cfset feature["type"] = "Feature">
        <cfset feature["geometry"] = structNew("ordered")>
        <cfset feature["geometry"]["type"] = "Point">
        <cfset feature["geometry"]["coordinates"] = [currentSite.longx, currentSite.lat]>
        <cfset feature["properties"] = currentSite>
        <cfset arrayappend(geoJsonObject["features"], feature)>
    </cfloop>

    <cfreturn geoJsonObject>
    

</cffunction>






