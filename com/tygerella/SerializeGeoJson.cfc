<cfcomponent extends="leaflet.com.tygerella.geometry.FeatureCollection">


    <cffunction name="init" access="public" returntype="leaflet.com.tygerella.SerializeGeoJson">

        <cfset this = super.init()>
        <cfreturn this />

    </cffunction>

    <!--- FEATURE: LINE --->
    <cffunction name="getLine" access="public" returntype="struct">
        <cfargument name="power_line_number" type="numeric" required="true">

        <cfset var qRead = "">

        <cfquery name="qLine" datasource="postgis">
        SELECT
            "PL_NO", 
            "PL_START", 
            "PL_END", 
            "LINE_NO", 
            "D_VOLT", 
            "O_VOLT", 
            "SERV_WID", 
            "LENGTH", 
            "PLANT_ID", 
            "CLNC_OLD", 
            "STATUS", 
            "LAT1", 
            "LONG1", 
            "LAT2", 
            "LONG2", 
            "LEGAL_AUDIT", 
            "LATM", 
            "LONGM", 
            "AUDIT_DATE", 
            "TECH_AUDIT", 
            "ID", 
            "BIRD_STATUS", 
            "OPTIC_FIBRE", 
            "CIRCUIT", 
            "STANDARD_LABEL", 
            "FLOC_ID", 
            "SERIES_CAPACITOR", 
            "AS_BUILT_DOC_REF", 
            "AS_BUILT_CHECK", 
            "COMMENTS", 
            "CLNC"
        FROM
            mts_line
        WHERE
            "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
        </cfquery>

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

        <cfset var  geoJsonLineString = structNew("ordered")>
        <cfset var  geoJsonLineString["type"] = "FeatureCollection">
        <cfset var  geoJsonLineString["features"] = arraynew(1)>
        
        <cfset feature = structnew("ordered")>
        <cfset feature["type"] = "Feature">
        <cfset feature["geometry"] = structnew("ordered")>
        <cfset feature["geometry"]["type"] = "LineString">
        <cfset feature["geometry"]["coordinates"] = arraynew(1)>
        <cfloop query="qRead">
            <cfset point = [qRead.LONGX, qRead.LAT, qRead.HEIGHT]>
            <cfset arrayappend(feature["geometry"]["coordinates"], point)>
        </cfloop>

        <cfswitch expression="#qLine.O_VOLT#">
            <cfcase value="800">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="765">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="533">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="400">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="275">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="220">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="132">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="110">
                <cfset line_color = "">
            </cfcase>
            <cfcase value="88">
                <cfset line_color = "">
            </cfcase>
            <cfdefaultcase>
                <cfset line_color = "##999">
            </cfdefaultcase>
        </cfswitch>



        <cfset feature["properties"]["item"] = "Transmission Line">
        <cfset feature["properties"]["item_selected"] = false>
        <cfset VARIABLES.props = queryGetRow(qLine,1)>
        <cfset structAppend(feature["properties"], VARIABLES.props, true)>

        <cfset arrayappend(geoJsonLineString["features"], feature)>
        
        <!---<cfreturn toString(serializeJSON(geoJsonLineString), "UTF-8")>--->
        <cfreturn geoJsonLineString>

    </cffunction>

    <!--- FEATURE: TOWERS --->
    <cffunction name="getTowers" access="public" returntype="struct">
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
            <!--- FEATURE --->
            <cfset feature = structnew("ordered")>
            <cfset feature["type"] = "Feature">
            <cfset feature["geometry"] = [:]>
            <cfset feature["geometry"]["type"] = "Point">
            <cfset feature["geometry"]["coordinates"] = []>
            <cfset feature["geometry"]["coordinates"][1] = qRead.LONGX>
            <cfset feature["geometry"]["coordinates"][2] = qRead.LAT>
            <cfset feature["geometry"]["coordinates"][3] = qRead.HEIGHT>
            <!--- FEATURE PROPERTIES --->
            <cfset feature["properties"] = [:]>
            <cfset feature["properties"]["item"] = "Tower">
            <cfset feature["properties"]["item_selected"] = false>
            <cfset VARIABLES.props = queryGetRow(qRead,1)>
            <cfset structAppend(feature["properties"], VARIABLES.props, true)>
            <cfset arrayappend(geoJsonObject["features"], feature)>
        </cfloop>
        
        <!---<cfreturn toString(serializeJSON(geoJsonObject), "UTF-8")>--->
        <!---<cfdump var="#geoJsonObject#">--->
        <cfreturn geoJsonObject />

    </cffunction>

    <!--- FEATURE: SPANS --->
    <cffunction name="getSpans" access="public" returntype="struct">
        <cfargument name="power_line_number" type="numeric" required="true">

        <cfset var qRead = "">
        <cfset var report_error = false>

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
            
            <cftry>
                <cfquery name="qTowerStart" dbtype="query" maxrows="1" timeout="300">
                SELECT	LAT, LONGX, HEIGHT
                FROM 	qTower
                WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
                AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qRead.TWR_START#" />
                </cfquery>
            
                <cfquery name="qTowerEnd" dbtype="query" maxrows="1" timeout="300">
                SELECT	LAT, LONGX, HEIGHT
                FROM	qTower
                WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#ARGUMENTS.power_line_number#" />
                AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qRead.TWR_END#" />
                </cfquery>
            
            <cfcatch>
                <cfset report_error = true>
                <cfbreak />
            </cfcatch>
            </cftry>

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
            <cfset feature["properties"]["selected"] = false>            
            <cfset feature["properties"]["color"] = span_color>

            <cfset arrayappend(geoJsonObject["features"], feature)>
        </cfloop>

        <!--- if there was any issue what so ever in adding a feature/layer to this group ...  --->
        <!--- rather clean out everything and report an error ...  --->
        <cfif report_error>
            <cfset arrayclear(geoJsonObject["features"])>
        </cfif>
        
        <cfreturn geoJsonObject>


    </cffunction>

    <!--- FEATURE: SITES --->
    <cffunction name="getSites" access="public" returntype="string" returnformat="JSON">

        <cfset var  geoJsonObject = structNew("ordered")>
        <cfset var  geoJsonObject["type"] = "FeatureCollection">
        <cfset var  geoJsonObject["features"] = arraynew(1)>
        
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

        <cfreturn toString(serializeJSON(geoJsonObject), "UTF-8")>
        <!--- <cfabort> --->

    </cffunction>


</cfcomponent>