<cfscript>
/**
 * Return a single row from a query.
 * 
 * @param qry      Query to inspect. (Required)
 * @param row      Numeric row to retrieve. (Required)
 * @return Returns a query. 
 */
function getRowFromQuery(qry,row){
    var result = queryNew();
    var cols = listToArray(qry.columnList);
    
    for(col in cols) {
    	queryAddColumn(result, col, listToArray(qry[col][row]));
    }

    return result;
}
</cfscript>