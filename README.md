# <p align="center">Sentinel KQL</p>
In this repository you may find KQL (Kusto Query Language) queries and Watchlist schemes for data sources related to Microsoft Sentinel (a SIEM tool).

I will be commenting the queries in [this Twitter thread](https://twitter.com/ep3p/status/1556248792269066241).

You could check other resources like:
| GitHub |
| ---- |
| [reprise99/awesome-kql-sentinel](https://github.com/reprise99/awesome-kql-sentinel) (start here)|
| [reprise99/Sentinel-Queries](https://github.com/reprise99/Sentinel-Queries) |
| [rod-trent/SentinelKQL](https://github.com/rod-trent/SentinelKQL) |
| [FalconForceTeam/FalconFriday](https://github.com/FalconForceTeam/FalconFriday) |
| [Cyb3r-Monk/Threat-Hunting-and-Detection](https://github.com/Cyb3r-Monk/Threat-Hunting-and-Detection) |
| [Bert-JanP/Hunting-Queries-Detection-Rules](https://github.com/Bert-JanP/Hunting-Queries-Detection-Rules) |
| [alexverboon/Azure-Threat-Research-Matrix-KQL](https://github.com/alexverboon/Azure-Threat-Research-Matrix-KQL) |
| [eshlomo1/Microsoft-Sentinel-4-SecOps](https://github.com/eshlomo1/Microsoft-Sentinel-4-SecOps) |
| [Kaidja/Azure-Sentinel](https://github.com/Kaidja/Azure-Sentinel) |
| [samilamppu/Sentinel-queries](https://github.com/samilamppu/Sentinel-queries) |
| [ashwin-patil/blue-teaming-with-kql](https://github.com/ashwin-patil/blue-teaming-with-kql) |
| [le0li9ht/Microsoft-Sentinel-Queries](https://github.com/le0li9ht/Microsoft-Sentinel-Queries) |
| ... |

Other links:
| Tags | Link |
| ---- | ---- |
| [KQL] | [Kusto Query Language (KQL) Shortcuts](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-explorer-shortcuts) <br /> [Kusto Query Language (KQL) Regular Expressions Library](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/re2-library) |
| [Data sources] | [sreedharande/IngestOffice365AuditLogs](https://github.com/sreedharande/IngestOffice365AuditLogs) <br /> [techcommunity.microsoft.com External Data Sources in Sentinel](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/using-external-data-sources-to-enrich-network-logs-using-azure/ba-p/1450345) <br /> [Threat Indicator MISP](https://github.com/Cyberlorians/Articles/blob/main/MISPTISetup.md) |
| [Rules] | [Microsoft Sentinel Analytics Rules Browser](https://analyticsrules.exchange/) <br /> [garybushey.com Markdown in Analytics Rules description](https://garybushey.com/2022/08/07/use-an-analytic-rules-description-for-remediation-steps/) <br /> [medium.com/@tokesisr Mitigate High Ingestion times](https://medium.com/@tokesisr/ingestion-time-will-tell-df7845170e53) |
| [Playbooks] | [Azure Logic Apps functions reference](https://docs.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference) <br /> [Incident Response Playbooks](https://docs.microsoft.com/en-us/security/compass/incident-response-playbooks) <br /> [adr.iaan.be Query LogAnalytics from Logic App](https://adr.iaan.be/blog/querying-log-analytics-from-logic-apps/) <br /> [adr.iaan.be Forward Directory Activity Logs User Access Administrator](https://adr.iaan.be/blog/adding-directory-activity-logs-to-microsoft-sentinel/) <br /> [Accelerynt-Security/AS-IP-Blocklist Logic App IP Address Alert to Conditional Access](https://github.com/Accelerynt-Security/AS-IP-Blocklist) <br /> [Accelerynt-Security/AS-Teams-Integration Logic App to Teams channel](https://github.com/Accelerynt-Security/AS-Teams-Integration) <br /> [Accelerynt-Security/AS-Domain-Watchlist Logic App Alert Entity to Watchlist](https://github.com/Accelerynt-Security/AS-Domain-Watchlist) <br /> [briandelmsft/SentinelAutomationModules triage incidents](https://github.com/briandelmsft/SentinelAutomationModules) |
| [Notebooks] | [microsoft/msticpy](https://github.com/microsoft/msticpy) |
| [UEBA] | [https://github.com/oshezaf/Sentinel-Custom-Analytics](https://github.com/oshezaf/Sentinel-Custom-Analytics) <br /> [cloudbrothers.info UEBA in Microsoft Sentinel](https://cloudbrothers.info/en/microsoft-sentinel-ueba/)|
| [Azure AD] | [Azure AD audit activity reference](https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/reference-audit-activities) <br /> [Azure AD security operations guide](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/security-operations-introduction) <br /> [Microsoft SignInLogs Error Codes (ResultType)](https://login.microsoftonline.com/error) <br /> [acalarch/azure-signinlog-results](https://github.com/acalarch/azure-signinlog-results/blob/main/signinlog-results.txt) <br /> [merill.net Microsoft Graph Permission Explorer](https://graphpermissions.merill.net/index.html) (Old permissions may appear if you write them in the URI path) <br /> [msandbu/azuread Azure AD ecosystem picture](https://github.com/msandbu/azuread/blob/main/AzureAD%20Big%20picture.jpg) |
| [Defender for Cloud] | [Defender for Cloud alerts](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-reference) <br /> [Defender for Cloud recommendations](https://learn.microsoft.com/en-us/azure/defender-for-cloud/recommendations-reference) |
| [Defender for Endpoint] | [Defender for Endpoint exclusions](https://cloudbrothers.info/en/guide-to-defender-exclusions/) <br /> [Defender for Endpoint performance analyzer](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/tune-performance-defender-antivirus) <br /> [Defender for Endpoint performance analyzer](https://twitter.com/SwiftOnSecurity/status/1575625955766194176)|
| [Defender for Identity] | [Defender for Identity alerts](https://learn.microsoft.com/en-us/defender-for-identity/alerts-overview) |
| [Blog] | [garybushey.com Blog Gary Bushey](https://garybushey.com/) <br /> [azurecloudai.blog Blog Microsoft](https://azurecloudai.blog/) <br /> [techcommunity.microsoft.com Blog Microsoft Sentinel](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/bg-p/MicrosoftSentinelBlog) |
| [Training] | [https://detective.kusto.io/ Game Azure Data Explorer Kusto KQL](https://detective.kusto.io/) <br /> [Microsoft Sentinel training](https://learn.microsoft.com/en-us/azure/sentinel/skill-up-resources) <br /> [Microsoft Sentinel Ninja training](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/become-a-microsoft-sentinel-ninja-the-complete-level-400/ba-p/1246310) <br /> [OTRF/Microsoft-Sentinel2Go](https://github.com/OTRF/Microsoft-Sentinel2Go)  <br /> [tomwechsler/Microsoft_Cloud_Security](https://github.com/tomwechsler/Microsoft_Cloud_Security) <br /> [kkneomis/kc7](https://github.com/kkneomis/kc7)|
| [Control] | [sreedharande/Microsoft-Sentinel-As-A-Code](https://github.com/sreedharande/Microsoft-Sentinel-As-A-Code) <br /> [www.infernux.no Create templates from your Analytics Rules to start a repository](https://www.infernux.no/MicrosoftSentinel-TemplateAnalyticRules/) <br /> [sreedharande/MS-Sentinel-Bulk-Delete-Threat-Indicators](https://github.com/sreedharande/MS-Sentinel-Bulk-Delete-Threat-Indicators)|
