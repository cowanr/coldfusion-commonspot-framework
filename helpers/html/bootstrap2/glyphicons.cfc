/**
 * Allows you to choose and print from the 140 icons provided in bootstrap 2.  All icons are 
 * available.
 *
 * http://getbootstrap.com/2.3.2/base-css.html#icons
 *
 * Example:
 *
 * infoIcon = new "cs-customcf.ecu-cf-framework.helpers.html.bootstrap2.glyphicons"();
 * infoIcon.setIcon("icon-info-sign");
 * infoIcon.showPurpleIcon();
 * output = infoIcon.render() // returns <i class="icon-purple icon-info-sign"></i>
 */
component extends="cs-customcf.ecu-cf-framework.helpers.html.tags.i" output="false" accessors="true"{

	/**
	 * ColdFusion generates the accessor methods (getter and setter) for each property in this CFC that can be invoked. 
 	 * See: http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec0999c-7ff5.html#WS1E722CDD-3AA0-4e17-86DB-EF6D12FC6750
 	 */

	/**
	 * A validated array of all the incons names from bootstrap 2 documentation.
	 */
	property array icons;

	/**
	 * The icon name to use.
	 * Must be one of the valid icons names from bootstrap 2 documentation.
	 * Default: Empty String
	 */
	property string icon;

	/**
	 * The color to use.  
	 * Available choices are white, purple, or black.
	 * Defaults: black
	 */
	property struct color;

	/**
	 * Sets the color to use.
	 * 
	 * @param string c The color to use.
	 */
	public function setColor(string c) {
		if ((c == "white") || (c == "purple") || (c == "black")) {
			color = c;
		} 
	}

	/**
	 * Set the color to black
	 */
	public function showBlackIcon() {
		color = "black";
		
	}

	/**
	 * Set the color to white
	 */
	public function showWhiteIcon() {
		color = "white";
		
	}

	/**
	 * Set the color to purple
	 */
	public function showPurpleIcon() {
		color = "purple";
		
	}

	/**
	 * Sets the icon to use.  Throws an exception if 
	 * it is not a valid icon.
	 * 
	 * @param string i The icon name from the bootstap 2 docs
	 */
	public function setIcon(string i) {
		if (!isGlyphicon(i)) {
			throw(type="Application",message="Not a valid Glyphicon",detail="Must be a valid Bootstrap 2 Glyphicon.  ie. icon-info-sign.");
		}

		icon = i;
	}

	/**
	 * Renders the glyphicon based on the settings.
	 *
	 * @return string The icon html.
	 */
	public string function render() {

		var class = icon;

		switch (color) {
			case "white":
				class = class & " icon-white";
				break;

			case "purple":
				class = class & " icon-purple";
				break;
		}

		addAttribute("class", class);

		return super.render() & renderClose();
	}

	/**
	 * Checks if icon name is a valid name.
	 *
	 * @param string name The icon name to check
	 * @returns boolean True if name is valid, false otherwise.
	 */
	public boolean function isGlyphicon(string name) {
		return ArrayContains(icons, name);
	}

	/**
	 * Set defaults and icon array
	 */
	public function init() {
		icon = "";
		color = "black";
		icons = ArrayNew(1);
		ArrayAppend(icons, "icon-adjust");
		ArrayAppend(icons, "icon-align-center");
		ArrayAppend(icons, "icon-align-justify");
		ArrayAppend(icons, "icon-align-left");
		ArrayAppend(icons, "icon-align-right");
		ArrayAppend(icons, "icon-arrow-down");
		ArrayAppend(icons, "icon-arrow-left");
		ArrayAppend(icons, "icon-arrow-right");
		ArrayAppend(icons, "icon-arrow-up");
		ArrayAppend(icons, "icon-asterisk");
		ArrayAppend(icons, "icon-backward");
		ArrayAppend(icons, "icon-ban-circle");
		ArrayAppend(icons, "icon-barcode");
		ArrayAppend(icons, "icon-bell");
		ArrayAppend(icons, "icon-bold");
		ArrayAppend(icons, "icon-book");
		ArrayAppend(icons, "icon-bookmark");
		ArrayAppend(icons, "icon-briefcase");
		ArrayAppend(icons, "icon-bullhorn");
		ArrayAppend(icons, "icon-calendar");
		ArrayAppend(icons, "icon-camera");
		ArrayAppend(icons, "icon-certificate");
		ArrayAppend(icons, "icon-check");
		ArrayAppend(icons, "icon-chevron-down");
		ArrayAppend(icons, "icon-chevron-left");
		ArrayAppend(icons, "icon-chevron-right");
		ArrayAppend(icons, "icon-chevron-up");
		ArrayAppend(icons, "icon-circle-arrow-down");
		ArrayAppend(icons, "icon-circle-arrow-left");
		ArrayAppend(icons, "icon-circle-arrow-right");
		ArrayAppend(icons, "icon-circle-arrow-up");
		ArrayAppend(icons, "icon-cog");
		ArrayAppend(icons, "icon-comment");
		ArrayAppend(icons, "icon-download");
		ArrayAppend(icons, "icon-download-alt");
		ArrayAppend(icons, "icon-edit");
		ArrayAppend(icons, "icon-eject");
		ArrayAppend(icons, "icon-envelope");
		ArrayAppend(icons, "icon-exclamation-sign");
		ArrayAppend(icons, "icon-eye-close");
		ArrayAppend(icons, "icon-eye-open");
		ArrayAppend(icons, "icon-facetime-video");
		ArrayAppend(icons, "icon-fast-backward");
		ArrayAppend(icons, "icon-fast-forward");
		ArrayAppend(icons, "icon-file");
		ArrayAppend(icons, "icon-film");
		ArrayAppend(icons, "icon-filter");
		ArrayAppend(icons, "icon-fire");
		ArrayAppend(icons, "icon-flag");
		ArrayAppend(icons, "icon-folder-close");
		ArrayAppend(icons, "icon-folder-open");
		ArrayAppend(icons, "icon-font");
		ArrayAppend(icons, "icon-forward");
		ArrayAppend(icons, "icon-fullscreen");
		ArrayAppend(icons, "icon-gift");
		ArrayAppend(icons, "icon-glass");
		ArrayAppend(icons, "icon-globe");
		ArrayAppend(icons, "icon-hand-down");
		ArrayAppend(icons, "icon-hand-left");
		ArrayAppend(icons, "icon-hand-right");
		ArrayAppend(icons, "icon-hand-up");
		ArrayAppend(icons, "icon-hdd");
		ArrayAppend(icons, "icon-headphones");
		ArrayAppend(icons, "icon-heart");
		ArrayAppend(icons, "icon-home");
		ArrayAppend(icons, "icon-inbox");
		ArrayAppend(icons, "icon-indent-left");
		ArrayAppend(icons, "icon-indent-right");
		ArrayAppend(icons, "icon-info-sign");
		ArrayAppend(icons, "icon-italic");
		ArrayAppend(icons, "icon-leaf");
		ArrayAppend(icons, "icon-list");
		ArrayAppend(icons, "icon-list-alt");
		ArrayAppend(icons, "icon-lock");
		ArrayAppend(icons, "icon-magnet");
		ArrayAppend(icons, "icon-map-marker");
		ArrayAppend(icons, "icon-minus");
		ArrayAppend(icons, "icon-minus-sign");
		ArrayAppend(icons, "icon-move");
		ArrayAppend(icons, "icon-music");
		ArrayAppend(icons, "icon-off");
		ArrayAppend(icons, "icon-ok");
		ArrayAppend(icons, "icon-ok-circle");
		ArrayAppend(icons, "icon-ok-sign");
		ArrayAppend(icons, "icon-pause");
		ArrayAppend(icons, "icon-pencil");
		ArrayAppend(icons, "icon-picture");
		ArrayAppend(icons, "icon-plane");
		ArrayAppend(icons, "icon-play");
		ArrayAppend(icons, "icon-play-circle");
		ArrayAppend(icons, "icon-plus");
		ArrayAppend(icons, "icon-plus-sign");
		ArrayAppend(icons, "icon-print");
		ArrayAppend(icons, "icon-qrcode");
		ArrayAppend(icons, "icon-question-sign");
		ArrayAppend(icons, "icon-random");
		ArrayAppend(icons, "icon-refresh");
		ArrayAppend(icons, "icon-remove");
		ArrayAppend(icons, "icon-remove-circle");
		ArrayAppend(icons, "icon-remove-sign");
		ArrayAppend(icons, "icon-repeat");
		ArrayAppend(icons, "icon-resize-full");
		ArrayAppend(icons, "icon-resize-horizontal");
		ArrayAppend(icons, "icon-resize-small");
		ArrayAppend(icons, "icon-resize-vertical");
		ArrayAppend(icons, "icon-retweet");
		ArrayAppend(icons, "icon-road");
		ArrayAppend(icons, "icon-screenshot");
		ArrayAppend(icons, "icon-search");
		ArrayAppend(icons, "icon-share");
		ArrayAppend(icons, "icon-share-alt");
		ArrayAppend(icons, "icon-shopping-cart");
		ArrayAppend(icons, "icon-signal");
		ArrayAppend(icons, "icon-star");
		ArrayAppend(icons, "icon-star-empty");
		ArrayAppend(icons, "icon-step-backward");
		ArrayAppend(icons, "icon-step-forward");
		ArrayAppend(icons, "icon-tag");
		ArrayAppend(icons, "icon-tags");
		ArrayAppend(icons, "icon-tasks");
		ArrayAppend(icons, "icon-text-height");
		ArrayAppend(icons, "icon-text-width");
		ArrayAppend(icons, "icon-th");
		ArrayAppend(icons, "icon-th-large");
		ArrayAppend(icons, "icon-th-list");
		ArrayAppend(icons, "icon-thumbs-down");
		ArrayAppend(icons, "icon-thumbs-up");
		ArrayAppend(icons, "icon-time");
		ArrayAppend(icons, "icon-tint");
		ArrayAppend(icons, "icon-trash");
		ArrayAppend(icons, "icon-upload");
		ArrayAppend(icons, "icon-user");
		ArrayAppend(icons, "icon-volume-down");
		ArrayAppend(icons, "icon-volume-off");
		ArrayAppend(icons, "icon-volume-up");
		ArrayAppend(icons, "icon-warning-sign");
		ArrayAppend(icons, "icon-wrench");
		ArrayAppend(icons, "icon-zoom-in");
		ArrayAppend(icons, "icon-zoom-out");
		super.init();		
	}
}