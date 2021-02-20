/**
 * Returns a file paths to assets stored in the ECU Assets
 * web space.  Useful for when need to load assets in views.
 *
 * Example:
 * 
 * ecuAsset = new "cs-customcf.ecu-cf-framework.helpers.ecu_asset"();
 * writeOutput("<img src='" & ecuAsset.getImageSrc(i.getIcon(), "labs-os") & "' title='" & i.getName() & "' /> ");
 */
component output="false" accessors="true" {
	
	// The ecu asset directory.  
	// ex: PATH_TO_ECUASSET/images/ASSETDIR 	
	property string assetDir;

	public function init(dir = "") {
		assetDir = dir;
	}

	/**
	 * returns a valid src for an asset stored in the ecu assests images
	 * 
	 * @param filename 	 	Structure. (Required)
	 * @param dir     		ecu asset directory. Defaults to property or nothing. (Optional)
	 * @param uploaded      determins if the asset is in the uploads folder.  Defaults to true. (Optional)
	 * @return Returns a string.  //www.ecu.edu/ecuAssets/images/uploads/assetdir/filename
	 */
	public string function getImageSrc(fileName, dir = "", uploaded = true) {
		src = "https://" & application.CDNHost & "/images";
		
		if (Len(dir)) {
			src = src & "/" & dir;
		} else if (Len(assetDir)) {
			src = src & "/" & assetDir;
		}
		src = src & "/" & fileName;

		return src;
	}

	/**
	 * returns a valid src for an asset stored in the ecu assests videos
	 * 
	 * @param filename 	 	Structure. (Required)
	 * @param dir     		ecu asset directory. Defaults to property or nothing. (Optional)
	 * @param uploaded      determins if the asset is in the uploads folder.  Defaults to true. (Optional)
	 * @return Returns a string.  //www.ecu.edu/ecuAssets/images/uploads/assetdir/filename
	 */
	public string function getVideoSrc(fileName, dir = "", uploaded = true) {
		src = "https://" & application.CDNHost & "/videos";
	
		if (Len(dir)) {
			src = src & "/" & dir;
		} else if (Len(assetDir)) {
			src = src & "/" & assetDir;
		}
		src = src & "/" & fileName;

		return src;
	}


}
