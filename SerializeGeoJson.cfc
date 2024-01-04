<cfcomponent>

    <!---
    <cffunction name="init" access="public" returntype="struct">

        


        <cfreturn this />
    </cffunction>
--->

    <cffunction name="getLine" access="public" returntype="string" returnformat="JSON">
        <cfargument name="power_line_number" type="numeric" required="true">

        <cfset var qRead = "">

        <cfquery name="qRead" datasource="postgis">
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
            "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
        ORDER BY
            "TOWER_NO"
        </cfquery>
        
        <cfset var geoJsonObject = [:]>
        <cfset geoJsonObject["type"] = "FeatureCollection">
        <cfset geoJsonObject["features"] = []>

        <cfloop query="qRead">
            <cfset feature = structnew("ordered")>
            <cfset feature["type"] = "Feature">
            <cfset feature["geometry"] = [:]>
            <cfset feature["geometry"]["type"] = "Point">
            <cfset feature["geometry"]["coordinates"] = []>
            <cfset feature["geometry"]["coordinates"][1] = qRead.LONGX>
            <cfset feature["geometry"]["coordinates"][2] = qRead.LAT>
            <cfset feature["geometry"]["coordinates"][3] = qRead.HEIGHT>
            <cfset feature["properties"] = [:]>
            <cfset feature["properties"]["item"] = "Tower">
            <cfset feature["properties"]["prefix"] = toString(qRead.TOWER_NO)>
            <cfset feature["properties"]["number"] = qRead.TOWER_NO>
            <cfset feature["properties"]["status"] = "Active">
            <cfset arrayappend(geoJsonObject["features"], feature)>
        </cfloop>
        
        <cfreturn toString(serializeJSON(geoJsonObject), "UTF-8")>
        
        <!---<cfdump var="#geoJsonObject#">--->

    </cffunction>

    <cffunction name="getPoints" access="public" returntype="string" returnformat="JSON">
        <cfargument name="power_line_number" type="numeric" required="true">

        <cfset var qRead = "">

        <cfquery name="qRead" datasource="postgis">
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
            "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
        ORDER BY
            "TOWER_NO"
        </cfquery>
        
        <cfset var geoJsonObject = [:]>
        <cfset geoJsonObject["type"] = "FeatureCollection">
        <cfset geoJsonObject["features"] = []>

        <cfloop query="qRead">
            <cfset feature = structnew("ordered")>
            <cfset feature["type"] = "Feature">
            <cfset feature["geometry"] = [:]>
            <cfset feature["geometry"]["type"] = "Point">
            <cfset feature["geometry"]["coordinates"] = []>
            <cfset feature["geometry"]["coordinates"][1] = qRead.LONGX>
            <cfset feature["geometry"]["coordinates"][2] = qRead.LAT>
            <cfset feature["geometry"]["coordinates"][3] = qRead.HEIGHT>
            <cfset feature["properties"] = [:]>
            <cfset feature["properties"]["item"] = "Tower">
            <cfset feature["properties"]["prefix"] = toString(qRead.TOWER_NO)>
            <cfset feature["properties"]["number"] = qRead.TOWER_NO>
            <cfset feature["properties"]["status"] = "Active">
            <cfset arrayappend(geoJsonObject["features"], feature)>
        </cfloop>
        
        <cfreturn toString(serializeJSON(geoJsonObject), "UTF-8")>
        
        <!---<cfdump var="#geoJsonObject#">--->

    </cffunction>



    <cffunction name="getSpans" access="public" returntype="string" returnformat="JSON">
        <cfargument name="power_line_number" type="numeric" required="true">

        <cfset var qRead = "">

        <cfquery name="qRead" datasource="postgis">
        SELECT      "TWR_PREF",
                    "TWR_START",
                    "TWR_END",
                    "PL_NO",
                    "COND_TYPE",
                    "NO_COND",
                    "CONTRACTOR",
                    "LENGTH",
                    "TOWER_NO",
                    "EW_TYPE",
                    "CONSTR_YR",
                    "CONTR_NO",
                    "FLOC_ID" 
        FROM        mts_span 
        WHERE       "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
        AND ( "TWR_START" != 0 ) 
        AND ( "TWR_END" != 0 )
        ORDER BY    "TOWER_NO" ASC,
                    "TWR_START" ASC,
                    "TWR_END" ASC
        </cfquery>

        <cfquery name="qTower" datasource="postgis">
        SELECT      "PL_NO",
                    "LAT", 
                    "LONGX", 
                    "HEIGHT",
                    "TOWER_NO"
        FROM        mts_tower
        WHERE       "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
        </cfquery>
        
        <cfset var geoJsonObject = [:]>
        <cfset geoJsonObject["type"] = "FeatureCollection">
        <cfset geoJsonObject["features"] = []>

        <cfloop query="qRead">
            <cfset feature = structnew("ordered")>
            <cfset feature["type"] = "Feature">
            <cfset feature["geometry"] = [:]>
            <cfset feature["geometry"]["type"] = "LineString">
            
            <cfquery name="qTowerStart" dbtype="query" maxrows="1">
            SELECT	LAT, LONGX, HEIGHT
            FROM 	qTower
            WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
            AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qRead.TWR_START#" />
            </cfquery>
        
            <cfquery name="qTowerEnd" dbtype="query" maxrows="1">
            SELECT	LAT, LONGX, HEIGHT
            FROM	qTower
            WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
            AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qRead.TWR_END#" />
            </cfquery>
        
            <cfset spanArr = arraynew()>
            <cfset towerArr = arraynew()>
            <cfif currentrow mod 2 eq 1>
                <cfset span_color = "yellow">
            <cfelse>
                <cfset span_color = "green">
            </cfif>
            <!---
            <cfoutput>
                START PL. #qSpan.PL_NO# > #qSpan.TOWER_NO# = LON: #qTowerStart.LONGX# and LAT: #qTowerStart.LAT# <br />
                END PL. #qSpan.PL_NO# > #qSpan.TOWER_NO# = LON: #qTowerEnd.LONGX# and LAT: #qTowerEnd.LAT# <br /><br />
            </cfoutput>
            --->
            <cfset arrayAppend(towerArr, [qTowerStart.LONGX,qTowerStart.LAT])>
            <cfset arrayAppend(towerArr, [qTowerEnd.LONGX,qTowerEnd.LAT])>
            <cfset arrayAppend(spanArr, towerArr)>

            <cfset feature["geometry"]["coordinates"] = towerArr>

            <cfset feature["properties"] = [:]>
            <cfset feature["properties"]["item"] = "Span">
            <cfset feature["properties"]["flocid"] = qRead.FLOC_ID>
            <cfset feature["properties"]["start"] = qRead.TWR_START>
            <cfset feature["properties"]["end"] = qRead.TWR_END>
            <cfset feature["properties"]["selected"] = false>
            <cfset feature["properties"]["color"] = span_color>
            <cfset arrayappend(geoJsonObject["features"], feature)>
        </cfloop>


        
        <cfreturn toString(serializeJSON(geoJsonObject), "UTF-8")>
        
        <!---<cfdump var="#geoJsonObject#">--->

    </cffunction>


</cfcomponent>