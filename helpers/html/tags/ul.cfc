/**
 * Renders a ul tag to include the li items.
 *
 * Example:
 *
 * ul = new ul();
 * ul.addAttribute("class", "foo-class");
 *
 * li = new li();
 * li.text = "foo";
 * li.addAttribute("class", "li-class");
 *
 * ul.addLi(li);
 * output = ul.render(); // returns <ul class="foo-class"><li class="li-class">foo</li></ul>
 */
 component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
		
	/** 
	 * Array of LI elements for UL
	 */
	property array lis;

	/**
	 * Set Defaults
	 */
	public function init() {
		lis = ArrayNew(1);
		super.init();
	}

	/** 
	 * Emptys the li elements
	 */
	public function clearItems() {
		return ArrayClear(lis);
	}

	/**
	 * Adds and LI element to the UL
	 *
	 * @param li li element that implements the html tag interface.
	 */
	public void function addLi(struct li) {
		ArrayAppend(lis, li);
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		if (ArrayIsEmpty(lis)) {
			return "";
		}
		output =  "<ul " & stringifyAttributes() & ">";

		for (li in lis) {
			output = output & li.render();
		}

		return output & "</ul>";
	}
}