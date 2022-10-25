## Threat Intelligence Indicator detections

This folder contains queries created with the help of the function [TIMapQueryGenerator.kql](https://github.com/ep3p/Sentinel_KQL/blob/main/Functions/TIMapQueryGenerator.kql).

The rules created by Microsoft for threat intelligence indicators can't be expected to adjust to each Sentinel workspace and their indicators, and some of the rules might contain unexpected mistakes. For example, Microsoft has developed a rule that matches Windows Security AppLocker Events with file hashes, but AppLocker does not generate SHA256 hashes, it generates PE256 hashes for executables files, unless you ingest PE256 hashes, this rule will never work.

Also, the default rules check activity that happens *after* you ingest an indicator. When possible, if you ingest a threat indicator you should also check the events that happened *before* the ingestion. Because of this, each Sentinel workspace should adapt, develop and review their own Threat Intelligence Indicator detections.

Many data types or tables have several columns that could be matched to a certain indicator type, like email address, domain, url, file hash, IP address... And so each indicator type could also be matched with several data types. The query (or algorithm) that matches a certain indicator type with a certain data type should have common elements regardless of the indicator and data types.

Developing +40 queries with common elements between them without making mistakes is a difficult task, so it would be beneficial to develop a function or a generator for these queries, where you pick an indicator type and a data type and the function generates the appropiate query, reusing and defining only once the common query parts. The part of the query that is unique to each pair indicatortype-datatype should be small.

Usually developing this query generator would require a programming language, but you can also define functions in KQL. You could define:
1. A datatable of indicator types.
2. A datatable of data types (or event tables).
3. A datatable of pair indicatortype-datatype.
4. A query scheme with some variables (or placeholders), which will be substituted by query code depending on the indicator and data types.

The generator only needs to check the third datatable and substitute parts of the query scheme, and a query will be generated for each indicator and data type.

One example of this generator function is [TIMapQueryGenerator.kql](https://github.com/ep3p/Sentinel_KQL/blob/main/Functions/TIMapQueryGenerator.kql).

An advantage of this generator is that all the information related to threat indicator queries is contained in a single file, and is easier to search and replace similar query parts.

One example query scheme could be:
```
Query:string=
    ```// This query assumes a feed of threat indicators is ingested/synchronized periodically, and each synchronization ingests all the indicators that are to be monitored.
    // Additionally, threat indicators that were added manually in Sentinel are renovated as ThreatIntelligenceIndicator events every ~12 days.
    // Matching indicators with table events will require taking into account these different processes.
    // The function defined below has some datetime parameters, these will affect only the feed threat indicators, not the manually added indicators.
    let query_frequency = 1h;
    let query_period = 14d;
    let ti_feed_sync_frequency = 1d;
    let ti_feed_sync_duration = 6h;
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
    let _TITableMatch = (ti_start:datetime, only_new_ti:boolean, table_start:datetime, table_end:datetime) {
        // Scheduled Analytics rules have a query period limit of 14d
        let ti_feed_start = max_of(ago(query_period), ti_start - iff(only_new_ti, ti_feed_sync_frequency + ti_feed_sync_duration, 0s));
        let ti_feed_end = now();
        let _Indicators =// materialize(
            union
                // Manually added indicators
                (ThreatIntelligenceIndicator
                | where TimeGenerated > ago(query_period) and ExternalIndicatorId has "indicator--"
                ),
                // Feed ingested indicators
                (ThreatIntelligenceIndicator
                | where TimeGenerated between (ti_feed_start .. ti_feed_end) and not(ExternalIndicatorId has "indicator--")
                )
            // Take the earliest TimeGenerated and the latest column info
            | summarize hint.strategy=shuffle
                minTimeGenerated = min(TimeGenerated),
                arg_max(TimeGenerated, Active, Description, ActivityGroupNames, IndicatorId, ThreatType, DomainName, Url, ExpirationDateTime, ConfidenceScore, AdditionalInformation, ExternalIndicatorId<<<TIProjectColumns>>>)
                by IndicatorId
            // Remove inactive or expired indicators
            | where not(not(Active) or ExpirationDateTime < ti_feed_end)
            // Remove feed indicators not received in the specified period
            | where not(TimeGenerated < ti_start and not(ExternalIndicatorId has "indicator--"))
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
        // Match      all indicators available                                    with current table events
        _TITableMatch(ago(ti_feed_sync_frequency + ti_feed_sync_duration), false, ago(query_frequency), now()),
        // Match      new indicators since last query execution                   with past table events
        _TITableMatch(ago(query_frequency), true,                                 ago(table_query_lookback), ago(query_frequency))
    | summarize arg_max(<<<TableName>>>_TimeGenerated, *) by IndicatorId<<<TableGroupByColumn>>>
    | extend
        timestamp = <<<TableName>>>_TimeGenerated<<<TableCustomEntityExtend>>><<<TICustomEntityExtend>>>```
```
You can observe this "query" has some placeholders between the characters <<< xxxxx >>>, it won't work as a KQL query in this state. The three defined datatables contain the query parts that will substitute these placeholders. The datatables are called:
```
_IndicatorTypesDatatable = datatable(EntityType:string, IndicatorDictionary:dynamic)
_TablesDatatable = datatable(EntityType:string, TableDictionary:dynamic)
_IndicatorXTableDatatable = datatable(IndicatorType:string, TableType:string, TITableConditions:dynamic)
```
Each datable *element* has a dictionary that contains the placeholders, an example element for the third datatable would be:
```
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
        //| where not(_IndicatorsPrefilterLength < 10000 and not(SyslogMessage has_any (_IndicatorsPrefilter))) // valid TLD ~1500 , "has_any" limit 10000
        | extend Urls = todynamic(dynamic_to_json(extract_all(_URLRegex, dynamic([1]), SyslogMessage)))
        | mv-expand Url = Urls
        | extend Url = tostring(Url[0])
        | where isnotempty(Url)
        | extend Url = trim_end(@"\/", Url)
        //| where not(_IndicatorsLength < 1000000 and not(Url in (toscalar(_Indicators | summarize make_list(Url))))) // "in" limit 1.000.000```
})
,
```
In this case ```TITableLookback```, ```TITableAdditionalLets``` and ```TITableConditions``` are placeholders in the query scheme. *Each element of the datatables should have a dictionary with the same placeholders*, even if some of them are empty.

This generator at the end tries to substitute, in the query scheme, any placeholder found in the datatable dictionaries, with the help of the ```scan``` KQL operator.

You could call the generator only once, and generate a query for each indicatortype-datatype defined in the third datatable.
![image](https://user-images.githubusercontent.com/2527990/197820399-c4b7e18a-5211-480e-a65d-8b29ac2df468.png)

Then, you can copy and paste the generated query in a new tab and press "Format query", and you will have one query ready to use for an Analytics Rule.

![image](https://user-images.githubusercontent.com/2527990/197820972-5d9aa918-17ca-44f1-9369-8c229613477f.png) ![image](https://user-images.githubusercontent.com/2527990/197821197-f25ce94e-3a3d-480e-a464-59e1ab3f5616.png)
