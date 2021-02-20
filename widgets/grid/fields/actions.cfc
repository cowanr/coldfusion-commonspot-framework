/**
 * An action field can contain one or more "actions" such as update, view, delete for 
 * a given row.
 *
 * Example:
 *
 *  Create an Action to add
 * 	infoIcon = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.glyphicons"();
 *	infoIcon.setIcon("icon-info-sign");
 *	infoIcon.showPurpleIcon();
 *	infoAction = new "cs-customcf.ecu-cf-framework.widgets.grid.table.fields.actions.link_action"();
 *	infoAction.setImage(infoIcon);
 *	infoAction.setLabel("Lab Information");
 *	infoAction.addAttribute("href","lab.cfm");
 *	infoAction.addAttribute("target","_blank");
 *	infoAction.addQueryParameter("id", "field.id");
 *
 *  Add the action to the field
 *	actionColumn = new "cs-customcf.ecu-cf-framework.widgets.grid.table.fields.actions"();
 *	actionColumn.addAction(infoAction);
 */
 component extends="field_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

 	/**
 	 * An array of all actions for the field
 	 * Default: Empty array
 	 */
	property array actions;

	/**
	 * Set default values
	 */
	public function init() {
		actions = ArrayNew(1);
		super.init();
	}

	/**
	 * Adds the action to the actions array.
	 * 
	 * @param action a component that implements the action_interface.
	 */
	public void function addAction(struct action) {
		metaData = GetMetaData(action);
		if (StructKeyExists(metadata, "implements") && StructKeyExists(metadata.implements, "action_interface")) {
			ArrayAppend(actions, action);
		}
	}

	/**
	 * Returns the value for the field to use in match the table row options.
	 * Must be overriden.
	 */
	public function getValue(row) {
		return "";
	}

	/**
	 * Creates the action for the field
	 * 
	 * @param row  
	 */
	public string function render(row) {
		var output = "";
		for(action in actions) {
			output = output & action.renderAction(row);
		}
		return output;
	}

}