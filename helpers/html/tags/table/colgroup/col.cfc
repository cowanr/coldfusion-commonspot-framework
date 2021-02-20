/**
 * Renders a table col tag.
 *
 * Example:
 *
 * col = new col();
 * col.addAttribute("class", "foo-class");
 * output = col.render(); // returns <col class="foo-class">
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
		
	/**
	 * Set defaults
	 */
	public function init() {
		super.init();
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		return "<col " & stringifyAttributes() & ">";
	}
}