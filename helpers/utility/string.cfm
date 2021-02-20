<cfscript>
	/**
	 * Breaks a Camel/Pascal string into space separated words.
	 * Replaces ., _, and - with spaces
	 * 
	 * @param str 	 String to use (Required)
	 * @return Returns a string 
	 */
	function caseToSpace(string str) {
		/**
		 * Regex Breakdown:  This will match against each word in Camel and Pascal case strings, while properly handling acronyms and 
		 * numbers.
		 *
		 * (^[a-z]+)                               Match against any lower-case letters at the start of the command.
		 * ([0-9]+)                                Match against one or more consecutive numbers (anywhere in the string, including at the start).
		 * ([A-Z]{1}[a-z]+)                        Match against Title case words (one upper case followed by lower case letters).
		 * ([A-Z]+(?=([A-Z][a-z])|($)|([0-9])))    Match against multiple consecutive upper-case letters, leaving the last upper case 
		 *                                         letter out the match if it is followed by lower case letters, and including it if it's
		 *                                         followed by the end of the string or a number.
		 */
		return trim(REReplace(str,"((^[a-z]+)|([0-9]+)|([A-Z]{1}[a-z]+)|([A-Z]+(?=([A-Z][a-z])|($)|([0-9]))))"," \1","ALL"));
	}
</cfscript>

<!---
 Capitalizes the first letter in each word.
 Made udf use strlen, rkc 3/12/02
 v2 by Sean Corfield.
 
 @param string      String to be modified. (Required)
 @return Returns a string. 
 @author Raymond Camden (ray@camdenfamily.com) 
 @version 2, March 9, 2007 
--->
<cffunction name="UCWords" returntype="string" output="false">
    <cfargument name="str" type="string" required="true" />
    
    <cfset var newstr = "" />
    <cfset var word = "" />
    <cfset var separator = "" />
    
    <cfloop index="word" list="#arguments.str#" delimiters=" ">
        <cfset newstr = newstr & separator & UCase(left(word,1)) />
        <cfif len(word) gt 1>
            <cfset newstr = newstr & right(word,len(word)-1) />
        </cfif>
        <cfset separator = " " />
    </cfloop>

    <cfreturn newstr />
</cffunction>