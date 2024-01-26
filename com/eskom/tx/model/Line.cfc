<cfcomponent displayname="MTS Line">

    <cffunction name="init" access="public" returntype="void">
        <cfreturn this />
    </cffunction>

    <cffunction name="load" access="public" returntype="leaflet.com.tx.model.Line">
        <cfargument name="power_line_number" type="numeric" required="true" />
        <cfset var qRead = "">

        <cfquery name="qRead" datasource="postgis">
        SELECT
                pl_no,
                pl_start,
                pl_end,
                d_volt,
                o_volt,
                line_no,
                LENGTH AS line_length,
                plant_id,
                clnc,
                status,
                tech_audit,
                lat1,
                legal_audit,
                latm,
                longm,
                standard_label,
                optic_fibre,
                series_capacitor,
                as_built_doc_ref,
                as_built_check,
                comments,
                birdguard,
                feature_id 
        FROM
                lines_with_birdguards 
        WHERE   (pl_no = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.power_line_number#" />)
        </cfquery>

        <cfif qRead.recordCount>
            <cfset this.pl_no = qRead.pl_no>
            <cfset this.pl_start = qRead.pl_start>
            <cfset this.pl_end = qRead.pl_end>
            <cfset this.d_volt = qRead.d_volt>
            <cfset this.o_volt = qRead.o_volt>
            <cfset this.line_no = qRead.line_no>
            <cfset this.line_length = qRead.line_length>
            <cfset this.plant_id = qRead.plant_id>
            <cfset this.clnc = qRead.clnc>
            <cfset this.status = qRead.status>
            <cfset this.tech_audit = qRead.tech_audit>
            <cfset this.lat1 = qRead.lat1>
            <cfset this.legal_audit = qRead.legal_audit>
            <cfset this.latm = qRead.latm>
            <cfset this.longm = qRead.longm>
            <cfset this.standard_label = qRead.standard_label>
            <cfset this.optic_fibre = qRead.optic_fibre>
            <cfset this.series_capacitor = qRead.series_capacitor>
            <cfset this.as_built_doc_ref = qRead.as_built_doc_ref>
            <cfset this.as_built_check = qRead.as_built_check>
            <cfset this.comments = qRead.comments>
            <cfset this.birdguard = qRead.birdguard>
            <cfset this.feature_id = qRead.feature_id>
            <cfreturn this>
        <cfelse>
            <cfthrow type="Database" message="Line (#arguments.power_line_number#) does not exist in the database." />
        </cfif>


    </cffunction>






    <cffunction name="getStartTower" access="private" returntype="gis.com.eskom.tx.model.Tower">
        
    </cffunction>


</cfcomponent>