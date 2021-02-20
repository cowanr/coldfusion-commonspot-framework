/** 
 * A filter that displays a validated list in a select drop down. 
 *
 *
 */
component output="false" extends="filter_abstract" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
		
	public function init(config = {}) {
		input = new "cs-customcf.ecu-cf-framework.helpers.html.tags.form.input"();
		input = super.setUrlDataAttributes(input);
		input.addAttribute("type", "text");
		super.init(config);
	}

	public string function renderFilter() {
		
		input.addAttribute("id", "filter_" & inputName);
		value = getFilterValue();

		if(Len(value)) {
			input.addAttribute("value", value);
		}
		class = input.getAttribute("class");
		input.addAttribute("class", class & " gridFilterInput span12");
		input.addAttribute("name", inputName);
		formtag.addAttribute("class", "gridFilterInputForm");
		output = formTag.render() & input.render() & formTag.renderClose();

		return output;
	}
}