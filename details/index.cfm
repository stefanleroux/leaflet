

<cfquery name="qTower" datasource="postgis">
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
WHERE "PL_NO" = 280 AND "TWR_NO" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.tnid#" /> 
        </cfquery>

        <cfdump var="#qTower#">