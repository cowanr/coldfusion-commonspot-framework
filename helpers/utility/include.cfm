<cfscript>
	/**
	 * Checks if the file has already been included, and if so, not include it again.
	 */
	function includeOnce(string file) {
		if (!StructKeyExists(variables, "ECU_Includes")) {
			variables.ECU_Includes = ArrayNew(1);
		}
		if (!ArrayContains(variables.ECU_Includes, file)) {
			ArrayAppend(variables.ECU_Includes, file);
			include file;
		}
	}
</cfscript>