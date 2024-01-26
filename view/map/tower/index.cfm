

<cfset myTower = createObject("component", "gis.com.eskom.tx.model.Tower").init()>
<cfset tower = myTower.load(URL.plnid, URL.twrid)>
