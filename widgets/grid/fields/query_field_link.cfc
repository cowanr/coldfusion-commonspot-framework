/**
 * A grid field that is linked that corrosponds to a field in the datasource row struct.
 *
 * Example:
 * 
 * column = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.query_field_link"();
 * column.setField("name");
 * column.setSortable(true);
 * 
 * column.getLink().addAttribute("href", "http://www.google.com");
 * column.getLink().addAttribute("target", "_blank");
 * column.addQueryParameter("view", "program");
 * column.addQueryParameter("id", "field.id");
 * 
 * column.setSortBy("name");
 */
 component extends="query_field" output="false" accessors="true"{

	/** 
	 * The linked field from the query to display.
	 */
	property link;

	/** 
	 * An array of unpared query parameters.
	 * Default: Empty struct
	 */
	property struct unparsedQueryParameters;

	/**
	 * Sets default values
	 */
	public function init(config = {}) {
		unparsedQueryParameters = StructNew();

		if(structKeyExists(config,"link")) {
			link = config.link;
		} else {
			link = new "cs-customcf.ecu-cf-framework.helpers.html.tags.a"();
		}

		super.init(config);
	}

	/**
	 * Overrides the addQueryParameter to add to the unparsed struct
	 *
	 * @param string key
	 * @param string value
	 */
	public void function addQueryParameter(string key, string value) {
		StructInsert(unparsedQueryParameters, key, value, true);
	}

	/**
	 * Converts any string that starts with "field." to the 
	 * value in the corresponding row field.
	 * 
	 * field.FIELD_NAME == row[FIELD_NAME]
	 */
	private void function parseQueryParameters(row) {
		for(parameter in unparsedQueryParameters) {
			pos = Find("field.", unparsedQueryParameters[parameter]);
			if ( pos > 0) {
	    		fieldName = Right(unparsedQueryParameters[parameter], Len(unparsedQueryParameters[parameter]) - 6);
	    		if (StructKeyExists(row, fieldName)) {
	    			link.addQueryParameter(fieldName, row[fieldName]);
	    		} 
	    	} else {
	    		link.addQueryParameter(parameter, unparsedQueryParameters[parameter]);
	    	}
		}
	}

	/**
	 * Returns the field from the row.
	 */
	public string function render(row) {
		if (StructKeyExists(row, field)) {
			parseQueryParameters(row);
			link.setLabel(super.getValue(row));
			return link.render();
		}
	}
}