/**
 * Calls a function on a component with the specified arguments
 *
 * Example:
 *
 * foo = new "cs-customcf.ecu-cf-framework.helpers.function"();
 * foo.setComponent("commponent");
 * foo.setName("function");
 * foo.addArgument("id",1);
 * foo.invoke(); // This is will call the component.function(id)
 */
component output="false" accessors="true" {

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked.
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * (Required) A component that has the fuction to be called.
	 */
	property string component;

 	/**
 	 * (Required) The fuction to call.
 	 */
 	property string name;

 	/**
 	 * (Required) The arguments to pass to the function.   The key is the argument
 	 * name in the function and the value is it's value.
 	 */
 	property struct args;

 	/**
 	 * Set defaults
 	 */
 	public function init() {
 		args = StructNew();
 	}

 	/**
 	 * Adds an argument.
 	 *
 	 * @param key arguement name
 	 * @param value arguement value
 	 */
 	public void function addArgument(key, value) {
		StructInsert(args, key, value, true);
	}

	/**
	 * Invokes the function
	 *
	 * @return mixed Returns what is returned by the invoked method.
	 */
	public function invoke() {
		var obj = createObject("component", component);
		return invoke(obj,name,args);
	}
}