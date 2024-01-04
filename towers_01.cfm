<!doctype html>





<cfquery name="qRead" datasource="postgis" maxrows="9">
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
	"PL_NO" = 101 
ORDER BY
	"TOWER_NO"
</cfquery>


<cfloop query="qRead">
    
    <cftry>
        <cfset qNext = queryGetRow(qRead, (qRead.TOWER_NO+1))>
        <cfset span =arraynew()>
        <cfset tower = arraynew()>
        <cfset tower[1] = [qRead.LONGX,qRead.LAT]>
        <cfset tower[2] = [qNext.LONGX,qNext.LAT]>
        <cfset arrayAppend(span, tower)>
        <cfdump var="#span#">
    <cfcatch type="any">
        <cfbreak />
    </cfcatch>
    </cftry>
    


    <!---<cfset arrayAppend(line, span)>--->

    

</cfloop>

<!---
<cfdump var="#line#">--->
<cfabort>



<cfset geoJson = createobject("component", "SerializeGeoJson").getSpans("FeatureCollection", qTower)>


<cfdump var="#geoJson#">
<cfabort>


<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="css/bootstrap.min.css" />
  </head>
  <body>
    <cfoutput>
    <h1>Hello, world!</h1>

    <table class="table">
        <thead>
          <tr>
            <th scope="col">PL_NO</th>
            <th scope="col">START</th>
            <th scope="col">END</th>
            <th scope="col">Distribution Voltage</th>
            <th scope="col">Operational Voltage</th>
            <th scope="col">LINE NO</th>
          </tr>
        </thead>
        <tbody>
        
        <cfloop query="qTower">
            <tr>
            <th>#qTower.TWR_PREF#</th>
            <td>#qTower.TWR_NO#</td>
            <td>#qTower.ISABEND#</td>
            <td>#qTower.TWR_TYPE#</td>
            <td>#qTower.SUB_TYPE#</td>
            <td>#qTower.TOWER_NO#</td>
          </tr>
        </cfloop>

        </tbody>
      </table>



    <script src="js/bootstrap.bundle.min.js"></script>



</cfoutput>  
</body>
</html>