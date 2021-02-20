/**
 * A grid filed that corrosponds to a field in the datasource row struct.
 *
 * Example:
 * 
 * field = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.query_field"();
 * field.setName("name");
 * field.setSortable(true);
 * field.setSortBy("name");
 */
 component extends="field_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * Returns the field from the row.
	 */
	public string function render(row) {
	 	return super.getRenderValue(row);
	}
}