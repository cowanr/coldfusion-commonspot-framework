<cfscript>
// The "action" that should be executed. Determined via URL query string.
if ( StructKeyExists(URL, "action")) {
	action = URL.action;
}  else {
	action = ""
}

switch(action) {

	default:
	case "clearGridFilters":
		clearFilter = new "cs-customcf.ecu-cf-framework.widgets.grid.filters.clear"();
		clearFilter.clearAllFilterValues(); // Will clear any cached filters for this session
		break;
}

</cfscript>