/**
 * Renders an a tag.
 *
 * Example link text:
 *
 * a = new a();
 * a.addAttribute("class", "foo-class");
 * a.setText(foo);
 * a.addAttribute("href", "http://www.ecu.edu");
 * a.render();  // returns <a class="foo-class" href="http://www.ecu.edu">foo</a>
 *
 * Example link element:
 *
 * Example link text:
 *
 * a = new a();
 * a.addAttribute("class", "foo-class");
 * a.addAttribute("href", "http://www.ecu.edu");
 *
 * img = new img();
 * img.addAttribute("src", "/images/foo.png");
 *
 * a.setElement(img);
 * a.render();  // returns <a class="foo-class" href="http://www.ecu.edu"><img src="/images/foo.png" /></a>
 */
component extends="tag_abstract" output="false" accessors="true"{
	
	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * The label for the link
	 */	
	property string label;

	/**
	 * An element to be linked
	 */
	property struct element;

	/**
	 * The url query parameters for the query string
	 */
	property struct queryParameters;

	/**
	 * Set defaults
	 */
	public function init() {
		super.init();
		queryParameters = StructNew();
		label = "";
		element = StructNew();	
	}

	/**
	 * Add parameters for the query string
	 *
	 * @param key the parameter name
	 * @param value the parameter value
	 */
	public void function addQueryParameter(key, value) {
		StructInsert(queryParameters, key, value, true);
	}

	/**
	 * Renders the element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		Application.includeOnce("/cs-customcf/ecu-cf-framework/helpers/utility/struct.cfm");
		var attrs = Duplicate(attributes);

		if (!StructIsEmpty(queryParameters)) {
			if(!StructKeyExists(attrs, "href")) {
				attrs.href = "";
			}
			attrs.href = attrs.href & "?" & encodeForURL(structToList(queryParameters,"&"), true);
		}

		// if cfc has a render function then call it.
		if (StructKeyExists(element, "render")) {
			label = element.render();
   		} else {
   			label = encodeForHTML(label, true);
   		}
				
		return "<a " & stringifyAttributes(attrs) & ">" & label & "</a>";
	}
}