/**
 * A grid filed that corrosponds to a field in the datasource row struct.
 *
 * Example:
 * 
 * column = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.query_field"();
 * column.setField("name");
 * column.setSortable(true);
 * column.setSortBy("name");
 */
 component extends="field_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/** 
	 * The field from the query to display.
	 */
	property string field;

	/**
	 * Sets default values
	 */
	public function init() {
		field = "";
		super.init();
	}

	/**
	 * Returns the field from the row.
	 */
	public string function render(row) {
		if (StructKeyExists(row, field)) {
		   	return row[field];
		}
	}

	/**
	 * Returns the field from the row.
	 */
	public function getValue(row) {
		if (StructKeyExists(row, field)) {
		   	return row[field];
		}
	}
	
	/** 
	 * Converts the field name to a title.  Camel cased words are 
	 * seperated by space and "._-)"" are replaced with spaces.
	 *
	 * @return string The title
	 */
	public string function getLabelFromField() {
	
		Application.includeOnce("/cs-customcf/ecu-cf-framework/helpers/utility/string.cfm");
		title = caseToSpace(field);
		title = REReplace(title, "[._-]", " ",  "ALL");
		title = UCWords(title);
		
		return title;
	}
}