
<cfset variables.power_line_number = 101>

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
	"LATM", 
	"LONGM", 
	"AUDIT_DATE", 
	"ID", 
	"BIRD_STATUS", 
	"CLNC", 
	"CIRCUIT", 
	"STANDARD_LABEL", 
	"FLOC_ID", 
	"SERIES_CAPACITOR"
FROM
	mts_line
WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#variables.power_line_number#" />
ORDER BY
	"PL_START" ASC, 
	"PL_END" ASC, 
	"D_VOLT" DESC, 
	"O_VOLT" DESC
</cfquery>


<cfquery name="qSpan" datasource="postgis" maxrows="20">
SELECT
	"TWR_PREF",
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
FROM
	mts_span 
WHERE
	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#variables.power_line_number#" />
	AND ( "TWR_START" <> 0 OR "TWR_END" <> 0 ) 
ORDER BY
	"TOWER_NO" ASC,
	"TWR_START" ASC,
	"TWR_END" ASC
</cfquery>

<cfquery name="qTower" datasource="postgis">
SELECT
	mts_tower."TWR_PREF", 
	mts_tower."TWR_NO", 
	mts_tower."PL_NO", 
	mts_tower."LAT", 
	mts_tower."LONGX", 
	mts_tower."HEIGHT", 
	mts_tower."ISABEND", 
	mts_tower."TWR_TYPE", 
	mts_tower."SUB_TYPE", 
	mts_tower."COND_ATT", 
	mts_tower."TUBE_NO", 
	mts_tower."SHT_NO", 
	mts_tower."CRD_TYPE", 
	mts_tower."DATA_SOURCE", 
	mts_tower."ACCURACY", 
	mts_tower."DATE_CAPTURED", 
	mts_tower."TOWER_NO", 
	mts_tower."GIS_ID", 
	mts_tower."FLOC_ID"
FROM
	mts_tower
WHERE
	mts_tower."PL_NO" = <cfqueryparam cfsqltype="bigint" value="#variables.power_line_number#" />
ORDER BY mts_tower."TOWER_NO"
</cfquery>



<!---
<cfdump var="#qLine#">
<cfdump var="#qSpan#">
<cfdump var="#qTower#">



<cfquery name="qSpanTower" dbtype="query">
SELECT      *
FROM        qSpan, qTower
WHERE       qSpan.PL_NO = qTower.PL_NO
AND         qSpan.TOWER_NO = qTower.TOWER_NO
ORDER BY    qSpan.TOWER_NO
</cfquery>

<cfdump var="#qSpanTower#">
--->



<cfloop query="qSpan">

	<cfquery name="qTowerStart" dbtype="query">
	SELECT	LAT, LONGX, HEIGHT
	FROM 	qTower
	WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#variables.power_line_number#" />
	AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qSpan.TWR_START#" />
	</cfquery>

	<cfquery name="qTowerEnd" dbtype="query">
	SELECT	LAT, LONGX, HEIGHT
	FROM	qTower
	WHERE	"PL_NO" = <cfqueryparam cfsqltype="bigint" value="#variables.power_line_number#" />
	AND		"TOWER_NO" = <cfqueryparam cfsqltype="bigint" value="#qSpan.TWR_END#" />
	</cfquery>

	<cfset spanArr = arraynew()>
	<cfset towerArr = arraynew()>
	<!---
	<cfoutput>
		START PL. #qSpan.PL_NO# > #qSpan.TOWER_NO# = LON: #qTowerStart.LONGX# and LAT: #qTowerStart.LAT# <br />
		END PL. #qSpan.PL_NO# > #qSpan.TOWER_NO# = LON: #qTowerEnd.LONGX# and LAT: #qTowerEnd.LAT# <br /><br />
	</cfoutput>
	--->
	<cfset arrayAppend(towerArr, [qTowerStart.LONGX,qTowerStart.LAT])>
	<cfset arrayAppend(towerArr, [qTowerEnd.LONGX,qTowerEnd.LAT])>
	<cfset arrayAppend(spanArr, towerArr)>

<cfdump var="#spanArr#" label="PL: #qSpan.TWR_START#">



</cfloop>