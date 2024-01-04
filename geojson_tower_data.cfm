
<cfparam name="URL.pl_number" type="numeric" default="280" />

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
WHERE
    "PL_NO" = <cfqueryparam cfsqltype="bigint" value="#URL.pl_number#" /> 
ORDER BY
    "TOWER_NO"
</cfquery>

<cfset middle_point = round(qTower.recordCount/2)>

<cfset middle_record = queryGetRow(qTower, middle_point)>

<cfset geoJson = createobject("component", "SerializeGeoJson").getPoints(URL.pl_number)>
<cfset file_name = "geojson_towers_#url.pl_number#.geojson">
<cffile action="write" file="#expandpath(file_name)#" output="var towers = #geoJson#" nameconflict="overwrite" />
<!------>



<!---
<cfset geojsonstring = '{ "type": "FeatureCollection",
  "features": [
    { "type": "Feature",
      "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
      "properties": {"prop0": "value0"}
      }
    ]
  }'>
  
  <cfdump var="#deserializejson(geojsonstring, true)#">
--->


<!---
backup Linestring


<cfset geojsonstring = '{ "type": "FeatureCollection",
  "features": [
    { "type": "Feature",
      "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
      "properties": {"prop0": "value0"}
      },
    { "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
          ]
        },
      "properties": {
        "prop0": "value0",
        "prop1": 0.0
        }
      },
    { "type": "Feature",
       "geometry": {
         "type": "Polygon",
         "coordinates": [
           [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
             [100.0, 1.0], [100.0, 0.0] ]
           ]

       },
       "properties": {
         "prop0": "value0",
         "prop1": {"this": "that"}
         }
       }
    ]
  }'>


--->