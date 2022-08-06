### Activity with monitored Office file

This query can help you to detect activity with an Office 365 file in SharePoint/OneDrive, the monitored files could be specified in a Sentinel Watchlist (or try to edit ```_MonitoredOfficeFiles``` value in the query as you want).

![image](https://user-images.githubusercontent.com/2527990/183267252-6e6cdd3c-cd9b-405e-9b4d-b1845d2854b9.png)


The UUID (a identification string) of the SharePoint site (Teams, Sites, OneDrive, etc.) you want to monitor should be specified.

You will find this value in the column ```Site_``` of ```OfficeActivity``` table. So previously, check events with the files you want to monitor in LogAnalytics with:

```
OfficeActivity
| search "stringtolookfor"
```
There will be a unique ```Site_``` value for each ```Site_Url``` value.

You have an [example of the used Watchlist here](https://github.com/ep3p/Sentinel_KQL/blob/main/Watchlists/UUID-AuditOfficeFiles.csv), that matches several columns of ```OfficeActivity``` table.

![image](https://user-images.githubusercontent.com/2527990/183267217-9e8c1f99-30e3-4f9f-9bf9-df2178731d18.png)

If you want to monitor a full folder or Site, you can simply omit the folder or file name columns (```SourceRelativeUrl``` & ```SourceFileName```), the query will try to detect operations only with the filled path columns.

If you want to monitor only the operation ```FileDownloaded``` with a certain file, you should specify that in the Watchlist column ```MonitoredOperation```. Or if you want to monitor all operations but ```FilePreviewed```, you could write ```"-FilePreviewed"```.

You may specify an ```Auditor``` column for reporting purposes, and later forward a notification depending on this value.
