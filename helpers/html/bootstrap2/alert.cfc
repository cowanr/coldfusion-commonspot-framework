/**
 * Allows you to choose and print an alert provided in bootstrap 2.  
 *
 * http://getbootstrap.com/2.3.2/components.html#alerts
 *
 * Example:
 *
 * alert = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.alert"();
 * alert.setMessage("Heads up! This alert needs your attention, but it's not super important.");
 * alert.setType("info");
 * output = alert.render() 
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	 property string message;

 	 property boolean closable;

 	 property string type;

 	 public function init() {
		message = "";
		closable = true;
		type = "success";
	}

	/**
	 * Sets the type to use.
	 * 
	 * @param string t The type to use.
	 */
	public function setColor(string t) {
		if ((t == "success") || (t == "info") || (t == "error")) {
			type = t;
		}
	}

	public string function render() {

		output = "<div class='alert alert-" & type & "'>";
		if(closable) {
			output = output & "<script>$('.alert').alert();</script>";
			output = output & "<button type='button' class='close' data-dismiss='alert'>&times;</button>";
		}
		output = output & message & "</div>";
		return output;
	}
}