/**
 * Renders an option tag.
 *
 * Example:
 *
 * option = new option();
 * option.text = "foo";
 * option.addAttribute("value", "foo");
 * option.addAttribute("class", "option-class");
 * output = option.render(); // returns <option class="option-class">foo</option>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
	
	/**
	 * Set defaults
	 */
	public function init(string type = "") {
		super.init();
		if(Len(type)) {
			super.addAttribute("type", type);
		}		
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		return "<input " & stringifyAttributes() & ">";
	}
}