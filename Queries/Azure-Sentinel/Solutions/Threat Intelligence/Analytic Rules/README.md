## Threat Intelligence Indicator detections

This folder contains queries created with the help of the function [TIMapQueryGenerator.kql](https://github.com/ep3p/Sentinel_KQL/blob/main/Functions/TIMapQueryGenerator.kql).

The [default rules created by Microsoft](https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Threat%20Intelligence/Analytic%20Rules) for threat intelligence indicators can't be expected to adapt to each Sentinel workspace and their indicators, and some rules might behave unexpectedly.

For example, Microsoft developed a [rule that matches Windows Security AppLocker Events with file hashes](https://github.com/Azure/Azure-Sentinel/blob/master/Solutions/Threat%20Intelligence/Analytic%20Rules/FileHashEntity_SecurityEvent.yaml), but *AppLocker does not generate SHA256 hashes*, it generates PE256 hashes for executables files, unless you ingest PE256 hashes, this rule will never work for your workspace.

Another example is when comparing reached domains to a domain indicator. An indicator might be "example.com", if your organization made a DNS request of "backup.example.com", in this case the Microsoft default rules would not match your event to the indicator because they only look for exact matches, when all domain levels should be checked. Moreover, the default rules might not check all the columns where an indicator may appear.

Also, these default rules check events that happen *after* ingesting an indicator. When possible, it should also check events that happened *before* ingesting an indicator. Because of this, **each Sentinel workspace should adapt, develop and review their own threat intelligence indicator detections**.

Some data types (tables) have several columns that could be matched to indicator types like: email address, domain, url, file hash, IP address... And also each indicator type could be matched with several tables. Regardless of the indicator type and table checked, every detection query of this type (or algorithm) will have common elements with the rest of the queries of this type.

Developing and maintaining +40 detections with common elements, without making mistakes or keeping track of changes, is a difficult task. It would be beneficial to develop a function that generates all the detection queries, one query for each indicator type and table combination. This way the common query parts are defined only once, and reused when needed. The query part that is unique to each indicatortype-table combination should be relativelly small. Another advantage of this function is that all the information related to threat intelligence indicator queries is contained in a single file, thus facilitating the search and replacement of similar detection parts.

Developing this generative function would usually require a programming language, but KQL is also capable of solving this problem. You could define a KQL function with:
1. A datatable of your indicator types.
2. A datatable of your ingested tables.
3. A datatable of indicatortype-table combinations.
4. A query scheme (the common algorithm) with some variables (or placeholders), which will be substituted by query parts, depending on the indicator type and table.

This function checks the third datatable to know which indicators and tables have to be matched, and to substitute the appropiate parts in the query scheme, generating a query for each combination.

One example of this generative function is [TIMapQueryGenerator.kql](https://github.com/ep3p/Sentinel_KQL/blob/main/Functions/TIMapQueryGenerator.kql). The query scheme in this example is:
```kql
// This query assumes a feed of threat indicators is ingested/synchronized periodically, and each synchronization ingests new indicators and only old indicators that have been modified.
// Active threat indicators in Sentinel are renovated as ThreatIntelligenceIndicator events every ~12 days.
let query_frequency = 1h;
let query_period = 14d;
let query_wait = <<<TableQueryWait>>>;
let table_query_lookback = <<<TITableLookback>>>;
let _TIBenignProperty =
    _GetWatchlist('ID-TIBenignProperty')
    | where Notes has_any (<<<TIWatchlistNoteType>>>)
    | project IndicatorId, BenignProperty
;
let _TIExcludedSources = toscalar(
    _GetWatchlist('Activity-ExpectedSignificantActivity')
    | where Activity == "ThreatIndicatorSource"
    | summarize make_list(Auxiliar)
);<<<TIAdditionalLets>>><<<TableAdditionalLets>>><<<TITableAdditionalLets>>>
let _TITableMatch = (table_start:datetime, table_end:datetime, only_new_ti:boolean, ti_start:datetime = datetime(null)) {
    // Scheduled Analytics rules have a query period limit of 14d
    let _Indicators =// materialize(
        ThreatIntelligenceIndicator
        | where TimeGenerated > ago(query_period)
        // Take the earliest TimeGenerated and the latest column info
        | summarize hint.strategy=shuffle
            minTimeGenerated = min(TimeGenerated),
            arg_max(TimeGenerated, Active, Description, ActivityGroupNames, IndicatorId, ThreatType, DomainName, Url, ExpirationDateTime, ConfidenceScore, AdditionalInformation, ExternalIndicatorId<<<TIProjectColumns>>>)
            by IndicatorId
        // Remove inactive or expired indicators
        | where not(not(Active) or ExpirationDateTime < now())
        // Pick indicators that contain the desired entity type<<<TIOperators>>>
        // Remove indicators from specific sources
        | where not(AdditionalInformation has_any (_TIExcludedSources))
        // Remove excluded indicators with benign properties
        | join kind=leftanti _TIBenignProperty on IndicatorId, $left.<<<TIGroupByColumn>>> == $right.BenignProperty
        // Deduplicate indicators by <<<TIGroupByColumn>>> column, equivalent to using join kind=innerunique afterwards
        | summarize hint.strategy=shuffle
            minTimeGenerated = min(minTimeGenerated),
            take_any(*)
            by <<<TIGroupByColumn>>>
        // If we want only new indicators, remove indicators received previously
        | where not(only_new_ti and minTimeGenerated < ti_start)
    //)
    ;<<<TIPrefilter>>>
    let _TableEvents =
        <<<TableName>>>
        | where <<<TableTimeColumn>>> between (table_start .. table_end)<<<PreTableOperators>>>
        // Filter events that may contain indicators<<<TITableConditions>>><<<PostTableOperators>>>
        | project-rename <<<TableName>>>_TimeGenerated = TimeGenerated
    ;
    _Indicators
    | join kind=inner hint.strategy=shuffle _TableEvents on <<<TIGroupByColumn>>>
    // Take only a single event by key columns
    //| summarize hint.strategy=shuffle take_any(*) by <<<TIGroupByColumn>>><<<TableGroupByColumn>>>
    | project
        <<<TableName>>>_TimeGenerated,
        Description, ActivityGroupNames, IndicatorId, ThreatType, DomainName, Url, ExpirationDateTime, ConfidenceScore, AdditionalInformation<<<TIExtendColumns>>><<<TIProjectColumns>>>,
        <<<TableColumns&LookUp>>>
};
union// isfuzzy=true
    // Match      current table events                                all indicators available
    _TITableMatch(ago(query_frequency + query_wait), ago(query_wait),                           false),
    // Match      past table events                                                          new indicators since last query execution
    _TITableMatch(ago(table_query_lookback + query_wait), ago(query_frequency + query_wait),    true, ago(query_frequency))
| summarize arg_max(<<<TableName>>>_TimeGenerated, *) by IndicatorId<<<TableGroupByColumn>>>
| extend
    timestamp = <<<TableName>>>_TimeGenerated<<<TableCustomEntityExtend>>><<<TICustomEntityExtend>>><<<TableExclusion>>>
```
You can notice this query scheme has some placeholders indicated by the strings ```<<< xxxxx >>>```, this "query" won't work in this state. But the defined datatables contain the query parts that substitute the placeholders. In this example the datatables have been named as the following:
```kql
_IndicatorTypesDatatable = datatable(EntityType:string, IndicatorDictionary:dynamic)
_TablesDatatable = datatable(EntityType:string, TableDictionary:dynamic)
_IndicatorXTableDatatable = datatable(IndicatorType:string, TableType:string, TITableConditions:dynamic)
```
Each datable *element* has a dictionary that will contain the placeholders.

An example element for the ```_IndicatorXTableDatatable``` datatable, that represents the combination of *URL indicators* with the *Syslog table*, would be:
```kql
'URL', 'Syslog',
dynamic({
    "TITableLookback":
        '2d'
    ,
    "TITableAdditionalLets":
        ``````
    ,
    "TITableConditions":
        ```
        | where isnotempty(SyslogMessage)
        | extend Urls = todynamic(dynamic_to_json(extract_all(_URLRegex, dynamic([1]), SyslogMessage)))
        | mv-expand Url = Urls
        | extend Url = tostring(Url[0])
        | where isnotempty(Url)
        | extend Url = trim_end(@"\/", Url)```
})
,
```
```TITableLookback```, ```TITableAdditionalLets``` and ```TITableConditions``` are placeholders in the query scheme. Each element should have a dictionary with the *same placeholders keys*, even if the placeholders values are empty.

At the end, this function tries to substitute, in the query scheme, any placeholder found in the dictionaries of each datatable. **If you need to change the threat intelligence indicator detections**, you just need to change the query scheme or some datatable elements, and make sure the placeholder keys are named the same everywhere. **You can add or remove as many placeholders as you want**, the ```scan``` KQL operator will try to replace *all* the placeholder keys found in the dictionaries.

You can call the function only once, and it will return a query for each indicatortype-table combination defined in the third datatable.
![image](https://user-images.githubusercontent.com/2527990/197820399-c4b7e18a-5211-480e-a65d-8b29ac2df468.png)

The next step would be to copy-paste the generated query in a new tab, press "Format query" for readability, and you will have one query ready to use in an Analytics rule.

![image](https://user-images.githubusercontent.com/2527990/197820972-5d9aa918-17ca-44f1-9369-8c229613477f.png) ![image](https://user-images.githubusercontent.com/2527990/197821197-f25ce94e-3a3d-480e-a464-59e1ab3f5616.png)

For example, check the generated [URL-Syslog query](https://github.com/ep3p/Sentinel_KQL/blob/main/Queries/Azure-Sentinel/Solutions/Threat%20Intelligence/Analytic%20Rules/Multiple-URLEntity_Syslog.kql).

In this example, the generative function matches 5 indicator types with 27 tables, generating 46 queries. The function contains ~2200 lines (mostly empty), and the 46 queries contain ~4600 lines in total.
