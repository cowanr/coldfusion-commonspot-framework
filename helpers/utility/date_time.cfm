<cfscript>

/**
 * Convert CF day ordinal to PHP day ordinal
 *
 * PHP is 1 (Monday) - 7 (Sunday)
 * CF is 1 (Sunday) - 7 (Saturday)
 *
 * @param ordinal - CF day ordinal 
 * @return int - PHP day ordinal
 */
function convertToPhpDayOrdinal(ordinal) {
	if (ordinal == 1) {
	 	return 7;
	} 
	return ordinal - 1;
}

/**
 * Returns yesterday's ordinal.
 *
 * @param ordinal - todays ordinal number
 * @return int - yesterdays ordinal number
 */
function getYesterdayDayOrdinal(ordinal) {
	ordinal = ordinal - 1;
	if(ordinal == 0) {
		ordinal = 7;
	}
	return ordinal;
}

</cfscript>