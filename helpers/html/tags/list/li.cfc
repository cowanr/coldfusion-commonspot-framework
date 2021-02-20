/**
 * Renders a list item tag.
 *
 * Example:
 *
 * li = new li();
 * li.text = "foo";
 * li.addAttribute("class", "foo-class");
 * output = li.render(); // returns <li class="foo-class">foo</li>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
	
	/**
	 * The list item text
	 */	
	property string text;

	/**
 	 * The nested list settings
 	 */
 	property ul nestedList;

	/**
	 * Set defaults
	 */
	public function init() {
		text = "";
		nestedList = new "cs-customcf.ecu-cf-framework.helpers.html.tags.ul"();
		super.init();
	}

	/**
	 * Adds a nested UL element to the LI
	 *
	 * @param ul ul element that implements the html tag interface.
	 */
	public void function nestList(struct ul) {
		nestedList = ul;
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		return "<li " & stringifyAttributes() & ">" & text & nestedList.render() & "</li>";
	}
}