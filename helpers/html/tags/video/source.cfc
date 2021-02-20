/**
 * Renders a source tag.
 *
 * Example non ecu asset:
 *
 * video = new "cs-customcf.ecu-cf-framework.helpers.html.tags.video"();
 * video.addAttribute("class", "foo-class");
 * video.setControls(true);
 *
 * source = new "cs-customcf.ecu-cf-framework.helpers.html.tags.video.source"();
 * source.addAttribute("type", "video/mp4");
 * source.addAttribute("src", "foo.mp4");
 * source.setEcuAssetDir('foo');
 *
 * video.addSource(source);
 * output = video.render(); 
 *
 * Ouput = <video controls="controls" preload="none" class="foo-class">
 *           <source type="video/mp4" src="http://www.ecu.edu/ecuAssets/videos/uploads/foo/foo.mp4">
 *			Your browser does not support the video tag.
 *         </video>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.tag_abstract" output="false" accessors="true"{

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
			cdn = new "cs-customcf.ecu-cf-framework.helpers.ecu_asset"();
			attrs["src"] = cdn.getVideoSrc(attrs["src"], ecuAssetDir);
		}
		return "<source " & stringifyAttributes(attrs) & "/>";
	}
}
