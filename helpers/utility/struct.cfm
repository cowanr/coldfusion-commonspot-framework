<cfscript>
	/**
	 * Converts struct into delimited key/value list.
	 * 
	 * @param s 	 	Structure. (Required)
	 * @param delim     List delimeter. Defaults to a comma. (Optional)
	 * @return Returns a string. 
	 */
	function structToList(struct s, string delim = "") {
		arr = ArrayNew(1);
		for(key in s) {
			ArrayAppend(arr, key & "=" & s[key]);
		}

		return ArrayToList(arr,delim);
	}
</cfscript>