/**
 * Renders a img tag.
 *
 * Example non ecu asset:
 *
 * img = new img();
 * img.addAttribute("src", "/images/foo.png");
 * output = img.render(); // returns <img src="/images/foo.png" />
 *
 * Example ecu asset:
 * img = new img();
 * img.addAttribute("src", "foo.png");
 * img.setEcuAssetDir("foo");
 * output = img.render(); // returns <img src="http://www.ecu.edu/ecuAssets/images/foo/foo.png" />
 */
component extends="tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
	
	/**
	 * True if the assets is located in the ecu asset folder, false otherwise.
	 * Default: false
	 */
	property boolean ecuAsset;

	/**
	 * The ECU asset directory that the image is located
	 */
	property string ecuAssetDir;

	/**
	 * Set defaults
	 */
	public function init() {
		ecuAsset = false;
		ecuAssetDir = "";
		super.init();
		
	}

	/**
	 * Sets the ecu directory and set ecuAsset to true.
	 * 
	 * @param string dir The directory the image is located at.
	 */
	public function setEcuAssetDir(string dir) {
		ecuAssetDir = dir;
		ecuAsset = true;
	}

	/**
	 * Renders the opening element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		var attrs = Duplicate(attributes);
		if(ecuAsset) {
			//Used to get file paths for videos/images/etc
			cdn = new "cs-customcf.ecu-cf-framework.helpers.ecu_asset"();

			attrs["src"] = cdn.getImageSrc(attrs["src"], ecuAssetDir);
		}
		return "<img " & stringifyAttributes(attrs) & "/>";
	}
}
