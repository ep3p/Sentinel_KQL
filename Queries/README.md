## Queries

Some of these queries are intended to be used in Analytics rules. If a ```query_frequency``` parameter appears in the KQL code, probably that query could be used in an Scheduled rule. On the contrary, NRT rules should not use any ```query_frequency``` or ```query_period``` parameters.

In the folder [Azure-Sentinel](https://github.com/ep3p/Sentinel_KQL/tree/main/Queries/Azure-Sentinel) you may find ***upgraded*** Microsoft content from [their repository](https://github.com/Azure/Azure-Sentinel/tree/master/Detections), which might not be worthy to commit in that repository, where I have contributed [several pull requests](https://github.com/Azure/Azure-Sentinel/pulls?q=is%3Apr+author%3Aep3p) and appeared in their [Threat Hunters leaderboard](https://github.com/Azure/Azure-Sentinel/blob/master/Tools/stats/stats.md) (the scores might not be updated for several months).

In the folder [Splunk Security Content](https://github.com/ep3p/Sentinel_KQL/tree/main/Queries/Splunk Security Content) you may find Splunk content from [their repository](https://github.com/splunk/security_content/tree/develop/detections), modified so it can be applied to KQL. Each detection might not be equivalent to the original one, because it might consider more event types than originally intended.

### Tips

Currently NRT rules don't allow multiple data types (tables) to be used in the same query. The *Analytics rule wizard* does not allow in the query two or more distinct strings that could be one of the table names. If, for example, ```Operation``` and ```OfficeActivity``` are the names of tables, you won't be able to use this query in a NRT rule:
```
OfficeActivity
| where Operation == "ExampleText"
```
The query has only called the table ```OfficeActivity```, but unfortunately ```Operation``` is *also* the name of a column in the table ```OfficeActivity```.

But there are certain ways to rewrite queries without using certain strings and **bypass the Analytics rule wizard**. So the previous query could be rewrited and used in a NRT rule like:
```
OfficeActivity
| where ['O''peration'] == "ExampleText"
...
| project ['O''peration']
```

Other kind of problems might arise also from the parser of the *Analytics rule wizard*, you may have a query that works flawlessly in Log Analytics, but when you try to create an analytics rule with it, the query won't be considered valid by the rule parser, due to a semantic error or alike. In this case I could recommend to add extra steps to the problematic part of your query. Maybe with a comment between some lines the parser won't detect the same behaviour, or using functions like ```coalesce``` will finally return the properties desired by the parser.
