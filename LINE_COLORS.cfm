
<cfset lineColorArray = ['220,220,220','200,200,200','180,180,180','160,160,160','140,140,140','120,120,120','100,100,100','80,80,80','60,60,60']>

<cfdump var="#lineColorArray#">

<cfoutput>
<table>
    <th>
        <tr>
            
        </tr>
    </th>
    <tbody>
 <cfloop index="c" array="#lineColorArray#">
    <cfset rgbAddopacity = listappend(c, 1, ",")>
   
    <tr width="800px" style="background-color:rgba(#rgbAddopacity#)">
        <td>NEXT</td>
    </tr>
    </cfloop>
    </tbody>
</table>




</cfoutput>