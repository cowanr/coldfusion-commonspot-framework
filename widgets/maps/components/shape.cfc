component output="false" accessors="true" {

	property string id;

	property string type;

	property array points;

	property string strokeColor;

	property string fillColor;

	property string iconImage;

	property string iconName;

	public function init() {

		points = ArrayNew(1);
	}

	public function addPoint(map_point) {
		ArrayAppend(points, map_point);
	}
}
