
ECU-Framework
-------------

This is meant to be a framework upon which to build custom scripts for Common Spot pages.


Object Oriented Programming
---------------------------

The framework uses OOP techniques and best practices.

Interfaces and Abstract components are used to ensure reusability and scalability of the code.

What are abstract components and interfaces?

An abstract component can have shared state or functionality. An interface is only a promise to provide the state or functionality. A good abstract component will reduce the amount of code that has to be rewritten because it's functionality or state can be shared via extending the component. The interface has no defined information to be shared, it only defines functions that must be implemented.

Cold Fusion doesn't actually support abstract components.  Per Ben Nadel the convention is to make a component that has a private contructor and throw exceptions for functions that have to be overriden.

http://www.bennadel.com/blog/1523-creating-an-abstract-base-class-in-coldfusion.htm

All abstract components filename ends in _abstract and interfaces filenames end in _interface.


Directories
-----------

- widgets are stand alone and should not rely on other widgets.  Think a table grid ( widget ) with the data being provided by a data source ( helper ).
- helpers are meant to provide discreet generic features to the widgets and can be used by one or more widgets.  Think the pager control to paginate the table grid and its data source.
- libraries are third party such as Select2 or HTML Purifier

All widget and helpers should have a readme.md file that explains their purpose and example usuage.

Within these top level directories your code should be orgainized to show dependencies and reduce clutter. As an example lets look at the grid widget.

/grid<br/>
&nbsp;&nbsp;/components<br/>
&nbsp;&nbsp;&nbsp;&nbsp;grid_abstract.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;grid_function.cfc<br/>
&nbsp;&nbsp;/fields<br/>
&nbsp;&nbsp;&nbsp;&nbsp;/actions<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;action_interface.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;link_action.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;actions.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;field_interface.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;field_abstract.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;query_field.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;selection.cfc<br/>
&nbsp;&nbsp;/filters<br/>
&nbsp;&nbsp;&nbsp;&nbsp;clear.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;filter_abstract.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;filter_interface.cfc<br/>
&nbsp;&nbsp;&nbsp;&nbsp;select.cfc<br/>
readme.md<br/>
table.cfc<br/>

It is easy to see that main component for the widget is the table.cfc in the top level.  The directories contains all the components that table.cfc uses to build the grid.  The structure allows a developer coming behind to quickly understand that the table.cfc is where to start looking and that everything else in the directories is supporting that cfc.  Also note the action.cfc and the action dir in the fields directory.  The components in the action dir are only used by the action.cfc.   The use of interfaces clearly define what the supporting components must do and the abstract classes provides common functionality.   Right now the grid widget only supports a table layout, but it would be a simple matter to add a list layout by creating a new list.cfc in the top level that could use the same components to build the grid without using an html table.


Coding Standards
----------------

Follow all standards as outlined in the ActiveCollab Code & Design Standards and Development Practices Documentation Notebook
