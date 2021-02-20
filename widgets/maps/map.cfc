/**
 * Creates and displays a goolge map
 *
 * Example:
 * map = new "cs-customcf.ecu-cf-framework.widgets.maps.map"();
 * map.setDisableDefaultUI(true);
 * map.setDraggable(false);
 * map.setMaxZoom(17);
 * map.setMinZoom(17);
 * mapItem = new "cs-customcf.ecu-cf-framework.widgets.maps.components.item"();
 * mapItem.loadItem(lab.getBuildingId(), 1); // layer 1 is the building data.
 * map.addItem(mapItem);
 * map.render();
 *
 * https://developers.google.com/maps/documentation/javascript/reference
 */
component output="false" accessors="true" {

	//google Maps API, defaults to ours
	property string key;

	//id of the map div, defaults to map-canvas
	property string div;

    //map center, Defaults to ECU copula
	property string center;

	property boolean centerOnItems;
	property int zoom;
	property int maxZoom;
	property int minZoom;
	property boolean forceZoom;
	property boolean zoomControl;
	property string zoomControlOptions;
	property boolean panControl;
	property string panControlOptions;
	property boolean mapTypeControl;
	property string mapTypeControlOptions;
	property boolean scaleControl;
	property string height;
	property string width;
	property string padding;
	property boolean draggable;
	property boolean scrollwheel;
	property string margin;
	property array items;
	property boolean disableDefaultUI;
	property string elementId;


	public function init() {
		key = "AIzaSyDcdtCHhQ34IxoOlSBw_GnQwiG6JfcP2KM";	//google Maps API, required
		div = "map-canvas";												//id of the map div
		elementId = rereplacenocase(div, '[^a-z0-9]', '', 'all');
		center = "35.607329, -77.366581";									//map center, manually set to ECU cupola
		zoom = "17";														//default zoom level
		draggable = true;
		scrollWheel = true;
		height = "300px";
		width = "100%";
		margin = 0;
		padding = 0;
		items = ArrayNew(1);
		zoomControl = true;
		zoomControlOptions = "{ style: google.maps.ZoomControlStyle.LARGE }";
		panControl = true;
		panControlOptions = "{ position: google.maps.ControlPosition.RIGHT_TOP }";
		centerOnItems = true;
		mapTypeControl = true;
		mapTypeControlOptions = "{ style: google.maps.MapTypeControlStyle.DROPDOWN_MENU }";
		scaleControl = true;
		forceZoom = true;
		disableDefaultUI = false;
	}

	public function addItem(item) {
		ArrayAppend(items, item);
	}

	private string function addMarker(item) {

	}

	private string function addMarkerIcon(item) {

	}

	private string function addPolygon(shape) {

		js = "
		// Define the LatLng coordinates for the polygon.
		var coordinates_" & elementId & " = [";

		for(point in shape.getPoints()) {
			js = js & " new google.maps.LatLng(" & point.getLat() & "," & point.getLng() & "),";
		}

		js = js & "	];
		allLatLng_" & elementId & " = allLatLng_" & elementId & ".concat(coordinates_" & elementId & ");

		// Construct the polygon.
		var polygon = new google.maps.Polygon({
			paths: coordinates_" & elementId & ",
	    	strokeColor: '" & shape.getStrokeColor() & "',
	    	strokeOpacity: 0.8,
	    	strokeWeight: 2,
	    	fillColor: '" & shape.getFillColor() & "',
	    	fillOpacity: 0.35,
		});

		polygon.setMap(map_" & elementId & ");
		";

		//if (item.getClickable()) {
		//	js = js & "
		//	google.maps.event.addListener(polygon, 'click', " & item.getClickFunction() & ");
		//	";
		//}

		return js;
	}

	private string function addPolylines(item) {

	}

	public string function render() {

		// CSS to style div
		css = "
		<style>
			##" & div & " {
				width: " & width & ";
				height: " & height & ";
				margin: " & margin & ";
				padding: " & padding & ";
			}
		</style>";

		// Map JS
		if(!StructKeyExists(REQUEST,"IncludedGoogleMapApi")) {
			js = '<script src="https://maps.googleapis.com/maps/api/js?key=#key#&"></script>';
			REQUEST.IncludedGoogleMapApi = true;
		} else {
			js = "";
		}

		js = js & "
		<script>
			var allLatLng_" & elementId & " = [];

      		var mapOptions_" & elementId & " = {
          		center: new google.maps.LatLng(" & center & "),
          		zoom: " & zoom & ",
          		draggable: " & draggable & ",
          		";

	      	if (isDefined("maxZoom")) {
			    js = js & "maxZoom: " & maxZoom & ",
			    ";
			}

			if (isDefined("minZoom")) {
			    js = js & "minZoom: " & minZoom & ",
		   		";
		   	}

	      	if (disableDefaultUI) {
	      		js = js & "
	      		disableDefaultUI: " & disableDefaultUI;
	      	} else {
				js = js & "
	      		panControl: " & panControl & ",
			    panControlOptions: " & panControlOptions & ",
			    mapTypeControl: " & mapTypeControl & ",
				mapTypeControlOptions: " & mapTypeControlOptions & ",
			    zoomControl: " & zoomControl & ",
			    zoomControlOptions: " & zoomControlOptions & ",
			    scrollwheel: false,
			    scaleControl: " & scaleControl;
	    	}

			js = js & "
				};
				var map_" & elementId & " = new google.maps.Map(document.getElementById('" & div & "'),mapOptions_" & elementId & ");";

			// Create markers/polygons/etc

			for(item in items) {
				for(shape in item.getShapes()) {

					switch (shape.getType()) {
						case "marker":
							js = js & addMaker(shape);
							break;

						case "markerIcon":
							js = js & addMakerIcon(shape);
							break;

						case "polyline":
							js = js & addPolyline(shape);
							break;

						case "polygon":
							js = js & addPolygon(shape);
							break;
					}
				}
			}

			// recenter the map if neccessary
			if (centerOnItems) {

				js = js & "
					var latlngbounds_" & elementId & " = new google.maps.LatLngBounds();
					var i;
					for (i = 0; i < allLatLng_" & elementId & ".length; i++) {
					   latlngbounds_" & elementId & ".extend(allLatLng_" & elementId & "[i]);
					}

					// The Center of the polygon
					";

				if (forceZoom) {
					js = js & " map_" & elementId & ".setCenter(latlngbounds_" & elementId & ".getCenter()); ";
				} else {
					js = js & " map_" & elementId & ".setCenter(latlngbounds_" & elementId & ".getCenter(),map_" & elementId & ".fitBounds(latlngbounds_" & elementId & ")); ";
				}
			}

		js = js & "</script>";

		// Div
		mapDiv = "<div title='ECU Google Map' id='" & div & "'></div>";

		return css & mapDiv & js;
	}
}
