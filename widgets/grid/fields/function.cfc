/**
 * A field that displays what is returned from a function in the field cell.
 *
 * Example:
 * 	seatsFunction = new "cs-customcf.ecu-cf-framework.widgets.grid.components.grid_function"();
 * 	seatsFunction.setComponent("components.lab");
 * 	seatsFunction.setName("getSeatSummary");
 * 	seatsFunction.addArgument("id", field.id);
 *
 * 	seats = new "cs-customcf.ecu-cf-framework.widgets.grid.fields.function"();
 * 	seats.setLabel("Seats Open");
 * 	seats.setFunction(seatsFunction);
 *
 */
component output="false" extends="field_abstract" {

	/**
	 * The function whose value to show in the field.  Should be a grid_function component.
	 * Default: Empty Struct
	 */

	property struct func;

	public function init(config = {}) {
		func = new "cs-customcf.ecu-cf-framework.widgets.grid.components.grid_function"();

		if(structKeyExists(config,"name")) {
			func.setName(config.name);
		}

		if(structKeyExists(config,"cmpt")) {

			func.setComponent(config.cmpt);
		}

		if(structKeyExists(config,"arguments")) {
			for (key in config.arguments) {
				func.addArgument(key, config.arguments[key]);
			}
		}

		super.init(config);
	}

	public void function setFunction(f) {
		func = f;
	}

	public struct function getFunction() {
		return func;
	}

	public function getValue(row) {
		if ( StructKeyExists(func, "invoke")) {
			return func.invoke(row);
		}
	}

	public string function render(row) {
		if ( StructKeyExists(func, "invoke")) {
			return func.invoke(row);
		}
	}

}