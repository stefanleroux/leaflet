
<cfset field_list ="twr_pref,
twr_start,
twr_end,
pl_no,
cond_type,
no_cond,
ew_type,
tem_temp,
constr_yr,
contr_no,
contractor,
length,
tower_no,
gis_id,
ew_type2,
fibre_owner,
attachment,
conductor_bundle_spacing,
floc_id,
span_clearance,
mutal_coupling,
mid_span_joint,
comments">


<cfoutput>

<cfloop index="i" list="#field_list#" delimiters=",">

*cfset this.#trim(i)# = qRead.#trim(i)#><br />

</cfloop>


</cfoutput>