/**
 * Renders a div tag.
 *
 * Example:
 *
 * div = new div();
 * div.addAttribute("class", "foo-class");
 * output = div.render() & "foo" & div.renderClose(); // returns <div class="foo-class">foo</div>
 */
component extends="tag_abstract" output="false" accessors="true"{

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
	 * Renders the opening element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		return "<div " & stringifyAttributes() & ">";
	}

	/**
	 * Renders the closing element.
	 *
	 * @return string the element.
	 */
	public string function renderClose() {
		return "</div>";
	}
}