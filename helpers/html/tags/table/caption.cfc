/**
 * Renders a caption tag for a table.
 *
 * Example:
 *
 * caption = new caption();
 * caption.addAttribute("class", "foo-class");
 * caption.setText("catpion foo");
 * output = caption.render(); // returns <caption class="foo-class">caption foo</caption>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
		
	/**
	 * The catpion text
	 */
	property string text;

	/**
	 * Set Defaults
	 */
	public function init() {
		text = "";
		super.init();
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		if (Len(text)) {
			return "<caption " & stringifyAttributes() & ">" & EncodeForHTML(text) & "<caption/>";
		} else {
			return "";
		}
	}
}