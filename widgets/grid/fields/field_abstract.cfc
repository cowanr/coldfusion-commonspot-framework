/**
 *	The abstract class that all field components should extend.
 *  Implements the field interface. 
 */
 component implements="field_interface" output="false" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * The title for the field
 	 * Default: Empty String
 	 */
 	property string label;

 	/**
 	 * The filter for this field.  Filters must implement the
 	 * filter_interface.
 	 */
 	property struct filter;

 	property boolean filterable;

 	/**
 	 * The name to identify the field
 	 * Default: Empty String
 	 */
 	property string name;

 	/**
 	 * Wether the field is sortable.
 	 * Default: false
 	 */
	property boolean sortable;
	
	/**
	 * What the field should be sorted by
	 * Default: Empty String
	 */
	property string sortBy;

	property boolean showMobile;

	property boolean encodeHtml;

	property struct format;

	/**
	 * Set the defaults
	 */
	public function init(config = {}) {

		format = {};
		showMobile = true;
		sortable = false;
		sortBy = "";
		filter = StructNew();
		filterable = false;
		name = "";
		label ="";
		encodeHtml = true;

		if(structKeyExists(config,"format")) {
			format = config.format;
		} 

		if(structKeyExists(config,"filterable")) {
			filterable = config.filterable;
		} 

		if(structKeyExists(config,"encodeHtml")) {
			encodeHtml = config.encodeHtml;
		} 

		if(structKeyExists(config,"showMobile")) {
			showMobile = config.showMobile;
		} 

		if(structKeyExists(config,"sortBy")) {
			sortBy = config.sortBy;
		} 	

		if(structKeyExists(config,"sortable")) {
			sortable = config.sortable;
		} 	

		if(structKeyExists(config,"name")) {
			name = config.name;
		} 

		if(structKeyExists(config,"label")) {
			label = config.label;
		} else {
			this.setLabelFromName();
		}
	}

	public boolean function isFilterable() {
		return filterable;
	}

	/** 
	 * Converts the field name to a title.  Camel cased words are 
	 * seperated by space and "._-)"" are replaced with spaces.
	 *
	 * @return string The title
	 */
	public void function setLabelFromName() {

		if (Len(name)) {
			Application.includeOnce("/cs-customcf/ecu-cf-framework/helpers/utility/string.cfm");
			label = caseToSpace(name);
			label = REReplace(label, "[._-]", " ",  "ALL");
			label = UCWords(label);	
		}
	}

	public boolean function hasFilter() {
		return (isStruct(filter) && StructKeyExists(filter, "renderFilter"));
	}

	public function setFilter(f) {
	
		if(StructKeyExists(f, "renderFilter")) {
			filter = f;
			filterable = true;
		}
	}

	/**
	 * Returns true if sortable, false otherwise.
	 *
	 * @return boolean
	 */
	public boolean function isSortable() {
		return sortable;
	}


	public void function setFormatType(type) {
		format = true;
		formatType = type;
	}

	/**
	 * Returns the field from the row encoded and formated as configured.
	 */
	private function getRenderValue(row) {
		if (StructKeyExists(row, name)) {

			// Get the value
			result = row[name];

			// Format if necessary
			if (structKeyExists(format,"format")) {
				result = format.format(result);
			}

			// Encode if necessary
		   	if(encodeHtml) {
				result = encodeForHTML(result);
			}

			return result;
		}
	}

	/**
	 * Returns the field from the row unencoded.   Can be used for value matching in the grid.  Look at the table.cfc for an example.
	 */
	public function getValue(row) {
		if (StructKeyExists(row, name)) {
		   	return row[name];
		}
	}

	/**
	 * Returns the string to display for the field.
	 * Should take into account the encodeHTML boolean and encode output based on it if necessary.  See the text field for an example.
	 * Must be overriden
	 *
	 * @retrun string
	 */
	public string function render(row) {
		throw(type="Application",message="Method Must Be Overridden",detail="The render method must be overridden in a specific field component.");
	}
}