component output="false" accessors="true"{

	property string type;

	property string mask;

	property string lsType;

	property string lsLocale;

	public function intit(config = {}) {

		type = "";
		mask = "";
		lsType = "";
		lsLocale = "";

		if(structKeyExists(config,"type")) {
			type = config.type;
		} 

		if(structKeyExists(config,"mask")) {
			mask = config.mask;
		} 

		if(structKeyExists(config,"lsType")) {
			lsType = config.lsType;
		} 

		if(structKeyExists(config,"lsLocale")) {
			lsLocale = config.lsLocale;
		} 

	}

	public function format(output) {

		switch (type) {

			// Yes/No format 
			case "yesNo":
				output = yesNoFormat(output);
			break;

			// Format a number
			case "number":
				output = numberFormat(output, mask);
				break;

			// Format a date time
			case "dateTime":
				output = DateTimeFormat(output, mask);
				break;

			// format a date
			case "date":
				output = DateFormat(output, mask);
				break;	

			// format a time
			case "time":
				output = TimeFormat(output, mask);
				break;	

			// format a decimal number
			case "decimal":
				output = DecimalFormat(output);
				break;

			// format a dollar amount
			case "dollar":
				output = DollarFormat(output);
				break;

			// format International currency amount
			case "lsCurrency":
				output = LSCurrencyFormat(output, lsType, lsLocale);
				break;

			// format International date
			case "lsDate":
				output = LSDateFormat(output, mask, lsLocale);
				break;

			// format International euro currency amount
			case "lsEuroCurrency":
				output = LsEuroCurrencyFormat(output, lsType, lsLocale);
				break;

			// format International time
			case "lsTime":
				output = LSTimeFormat(output, mask);
				break;

			// format International number
			case "lsNumber":
				output = LSNumberFormat(output, mask, lsLocale);
				break;												

		}

		return output;
	}
}