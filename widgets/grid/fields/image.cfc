/** 
 *
 */
component output="false" extends="field_abstract" accessors="true" {

	property img;

	property filePath;

	public function init(config = {}) {
		img = new "cs-customcf.ecu-cf-framework.helpers.html.tags.img"();
		filePath = "";
	
		if(structKeyExists(config,"filePath")) {
			filePath = config.filePath;
		} 
		
		if(structKeyExists(config,"ecuAssetDir")) {
			this.setEcuAssetDir(config.ecuAssetDir);
		} 

		if(!structKeyExists(config,"showMobile")) {
			config.showMobile = false;
		} 	
		
		// Defaults to true for a field.  Need to force off since the img component
		// encodes all data when rendering.  Don't encode twice!
		config.encodeHtml = false;
		
		super.init(config);
	}

	public function img() {
		return img;
	}

	public function setEcuAssetDir(dir) {
		img.setEcuAssetDir(dir);
	}

	/**
	 * Returns the field from the row.
	 */
	public string function render(row) {
		img.addAttribute("src", filePath & super.getValue(row));
		return img.render();
	}

}