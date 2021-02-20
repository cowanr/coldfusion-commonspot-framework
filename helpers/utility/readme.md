These are standalone functions that perform tasks like converting a camelCase word into camel case.

The functions should be grouped together by functionality.  e.g. all string functions in the string.cfm

There is now a handy includeOnce function available in the application scope to include these files only once. 

Example:

Application.includeOnce("/cs-customcf/ecu-cf-framework/helpers/utility/string.cfm");

