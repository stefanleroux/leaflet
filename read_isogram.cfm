

<cfset isoList = ["eleven",
    "subdermatoglyphic",
"lumberjacks",
"background",
"downstream",
"six-year-old"
]>

<cfset myIsogram = createObject("component", "Isogram")>


<cfscript>

    for(ig in isoList) {
        writeOutput(ig&": "&myIsogram.isIsogram(ig)&"<br /><br /><br />");
    }


</cfscript>
