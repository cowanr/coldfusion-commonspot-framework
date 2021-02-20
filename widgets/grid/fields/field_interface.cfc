/**
 * Defines the field objects that are used by a grid
 */
interface {

	/**
	 * Returns the printable label.
	 */
	public string function getLabel();

	/**
	 * The name used to identify the field to the grid.  Should be unique with only letters.
	 */
	public string function getName();

	/**
	 * Returns the output to display for this field.
	 *
	 * @param row - a struct where the key is the field being rendered
	 */
	public string function render(row);

	/**
	 * A true / false if the field is sortable
	 */
	public boolean function isSortable();

	/**
	 * How the field should be sorted.
	 */
	public string function getSortBy();

	/**
	 * The value to match against for matching options.
	 */
	public function getValue(row);

	public struct function getFilter();
}