/**
 * Defines the filter objects that are used by the table grid
 */
interface {

	/** 
	 * Returns the output to display for this column.
	 * 
	 * @param row - a struct where the key is the column being rendered 
	 */
	public string function renderFilter();

}