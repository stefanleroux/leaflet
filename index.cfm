<!doctype html>

<cfquery name="qLine" datasource="postgis">
SELECT DISTINCT
	mts_line."PL_NO",
	mts_line."PL_START",
	mts_line."PL_END",
	mts_line."D_VOLT",
	mts_line."O_VOLT",
	mts_line."LINE_NO" 
FROM
	mts_line 
WHERE 	mts_line."PL_NO" = 163 
ORDER BY
	mts_line."PL_START" ASC,
	mts_line."PL_END" ASC,
	mts_line."LINE_NO",
	mts_line."D_VOLT"
</cfquery>



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
        
        <cfloop query="qLine">
            <tr>
            <th>#qLine.PL_NO#</th>
            <td>Mark</td>
            <td>Otto</td>
            <td>@mdo</td>
            <td>@mdo</td>
            <td>@mdo</td>
          </tr>
        </cfloop>

        </tbody>
      </table>



    <script src="js/bootstrap.bundle.min.js"></script>



</cfoutput>  
</body>
</html>