/**
 * Extends the function helper. Calls a function on a component with the specified arguments.
 * Adds ability to specify arguments that should be used from the row struct data.
 * field.FIELD_NAME == row[FIELD_NAME]
 *
 * Example:
 *
 * foo = new "cs-customcf.ecu-cf-framework.helpers.function"();
 * foo.setComponent("commponent");
 * foo.setName("function");
 * foo.addArgument("id","field.id");
 * foo.invoke(); // This is will call the component.function(id)
 */
component extends="cs-customcf.ecu-cf-framework.helpers.function" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * Unparsed arguments for the fuction.
	 */
	property struct unparsedArgs;

	/**
	 * Set defaults
	 */
	public function init() {
		unparsedArgs = StructNew();
		super.init();
	}

	/**
	 * Converts any string that starts with "field." to the
	 * value in the corresponding row field.
	 *
	 * field.FIELD_NAME == row[FIELD_NAME]
	 */
	private void function parseArguments(row) {
		for(arg in unparsedArgs) {
			pos = Find("field.", unparsedArgs[arg]);
			if ( pos > 0) {
	    		fieldName = Right(unparsedArgs[arg], Len(unparsedArgs[arg]) - 6);
	    		if (StructKeyExists(row, fieldName)) {
	    			args[arg] = row[fieldName];
	    		}
	    	}
		}
	}

	/**
 	 * Adds an argument.
 	 *
 	 * @param key arguement name
 	 * @param value arguement value
 	 */
 	public void function addArgument(string key, string value) {
		if(!isDefined("unparsedArgs")) {
			unparsedArgs = StructNew();
		}
		StructInsert(unparsedArgs, key, value, true);
	}

	/**
	 * Invokes the function
	 *
	 * @return mixed Returns what is returned by the invoked method.
	 */
	public function invoke(struct row = "") {
		parseArguments(row);
		return super.invoke();
	}
}