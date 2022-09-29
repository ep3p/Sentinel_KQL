## Queries

Some of these queries are intended to be used in Analytics rules, if you see ```query_frequency``` that query probably could be used in an Scheduled rule. NRT rules should not use any ```query_frequency``` or ```query_period``` parameter.

### NRT Rules

Currently NRT rules don't allow multiple data types (tables) to be used in the same query. The *Analytics rule wizard* does not allow in the query 2 or more distinct strings that could be one of the table names. If ```Operation``` and ```OfficeActivity``` are the names of tables, you won't be able to use this query in a NRT rule:
```
OfficeActivity
| where Operation == "ExampleText"
```
And the query has only called the table ```OfficeActivity```, but ```Operation``` is the name of a table *and also* a column in another table. But there are certain ways to rewrite queries without using certain strings and bypass the *Analytics rule wizard*. So the previous query could be rewrited and used in a NRT rule like:
```
OfficeActivity
| where ['O''peration'] == "ExampleText"
...
| project ['O''peration']
```
