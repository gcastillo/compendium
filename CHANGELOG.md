# Change Log

## Future
* Add settings to `render_table` to specify the CSS classes to use for each element.
* Allow queries to be ordered and reversed via query options (:order and :reverse)
* Add default orders for count and sum queries
* Fix redefining a query so that it actually overrides the previous query instead of creating a new one with the same name

## 1.1.3
* Add `SumQuery` query type
* Fix option tooltip covering input elements in IE [rvracaric]
* Allow custom param validations to be specified
* Fix filters being overridden by subclassed queries

## 1.1.2
* Allow direct access to a chart object without having to render it (useful if the provider allows chart settings to be updated after initialization)
* Delegate missing methods from ChartProvider classes to the chart

## 1.1.1
* Fix crash regressions in Rails 3
* Added `CountQuery` query type which calls count on the result of the given block (for instance a query which is
  grouped by day and then counted)
* Added `ScalarParam` param type for collecting arbitrary data

## 1.1.0
* Added query filters (allow a result set to be filtered to remove/translate/etc. data)
* Extract chart providers into their own gems
* Queries can now be rendered with a remote data source
* Added `Report#url` and `Query#url` methods to get the JSON URL

## 1.0.7
* Added the ability to render a report or a specific query of a report as JSON

## 1.0.6
* Added a built-in renderer for metrics

## 1.0.5
* Fixed the `:only` and `:except` options to `Report#run`
* Give `ThroughQuery` access to params if the definition block has an arity of 2
* Fixed mutating results in a `ThroughQuery` block affecting the parent query
