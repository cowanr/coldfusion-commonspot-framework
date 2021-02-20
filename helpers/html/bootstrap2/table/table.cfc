/**
 * Extends the tr html tag and adds the bootstrap 2 options for tables.
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.table" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
 	 
	/**
	 * Boostrap 2 condensed option.
	 * Default: false
	 */
	property name="condensed" type="boolean";

	/**
	 * Boostrap 2 hover option.
	 * Default: false
	 */
	property name="hover" type="boolean";

	/**
	 * Boostrap 2 bordered option.
	 * Default: false
	 */
	property name="bordered" type="boolean";

	/**
	 * Boostrap 2 striped option.
	 * Default: false
	 */
	property name="striped" type="boolean";

	/**
	 * Set default values.
	 */
	public function init() {
		condensed = false;
		hover = false;
		bordered = false;
		striped = false;
		super.init();
	}
	
	/**
	 * Renders the table tag with the specified options.
	 * 
	 * @return string a html table tag.
	 */
	public string function render () {	
		tableClasses = ArrayNew(1);
		ArrayAppend(tableClasses, "table");
		if (striped) {
			ArrayAppend(tableClasses, "table-striped");
		}
		if (bordered) {
			ArrayAppend(tableClasses, "table-bordered");
		}
		if (hover) {
			ArrayAppend(tableClasses, "table-hover");
		}
		if (condensed) {
			ArrayAppend(tableClasses, "table-condensed");
		}
		classes = ArrayToList(tableClasses, " ");
		if(isAttribute("class")) {
			classes = classes & " " & getAttribute("class");
		}
		addAttribute("class", classes);

		return super.render();
	}

}