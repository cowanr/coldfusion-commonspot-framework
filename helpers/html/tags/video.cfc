/**
 * Renders a video tag.
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
 * ecuAsset = new "cs-customcf.ecu-cf-framework.helpers.ecu_asset"();
 * video.setPoster(ecuAsset.getImageSrc("foo.png", "foo"));
 *
 * video.addSource(source);
 * output = video.render(); 
 *
 * Ouput = <video controls="controls" preload="none" class="foo-class" poster="http://www.ecu.edu/ecuAssets/images/uploads/foo/foo.png">
 *           <source type="video/mp4" src="http://www.ecu.edu/ecuAssets/videos/uploads/foo/foo.mp4">
 *			Your browser does not support the video tag.
 *         </video>
 */
component extends="tag_abstract" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */
	
	/**
	 * Specifies that the video will start playing as soon as it is ready
	 */
	property boolean autoplay;

	/**
	 * Specifies that video controls should be displayed (such as a play/pause button etc).
	 */
	property boolean controls;

	/**
	 * Specifies that the video will start over again, every time it is finished
	 */
	property boolean loop;

	/**
	 * Specifies that the audio output of the video should be muted
	 */
	property boolean muted;

	/**
	 * Specifies if and how the author thinks the video should be loaded when the page loads
	 *
	 * auto
	 * metadata
	 * none
	 */
	property string preload;

	/**
	 * Full URL for poster image
	 */
	property string poster;

	/** 
	 * Array of source elements for video
	 */
	property array sources;

	/**
	 * Set defaults
	 */
	public function init() {
		controls = false;
		muted = false;
		preload = "none";
		autoplay = false;
		loop = false;
		poster = "";
		sources = ArrayNew(1);
		super.init();
	}

	/** 
	 * Emptys the source elements
	 */
	public function clearSources() {
		return ArrayClear(sources);
	}

	/**
	 * Adds a Source element to the video
	 *
	 * @param source source element that implements the html tag interface.
	 */
	public void function addSource(struct source) {
		ArrayAppend(sources, source);
	}

	/**
	 * Specifies if and how the author thinks the video should be loaded when the page loads
	 *
	 * auto
	 * metadata
	 * none
	 */
	public function setPreload(string setting) {

		switch(setting) {

			case "auto":
				preload = "auto";
				break;

			case "metadata":
				preload = "metadata";
				break;

			default:
				preload = "none";
				break;
		}
	}

	/**
	 * Renders the opening element.
	 *
	 * @return string the element.
	 */
	public string function render() {
		var attrs = Duplicate(attributes);
		if(controls) {
			attrs["controls"] = "controls";
		}
		if(muted) {
			attrs["muted"] = "muted";
		}
		if(autoplay) {
			attrs["autoplay"] = "autoplay";
		}
		if(loop) {
			attrs["loop"] = "loop";
		}
		attrs["preload"] = preload;

		if (LEN(poster)) { 
			attrs["poster"] = poster;		
		}

		output = "<video " & stringifyAttributes(attrs) & ">";
		for (s in sources) {
			output = output & s.render();
		}
		output = output & "Your browser does not support the video tag.";
		output = output & "</video>";

		return output;

	}
}