### Unexpected Azure AD device

This query can help you to detect device addition/deletion events from Azure AD, that have predefined unexpected properties like: TrustType, Intune Group Tags, AD AAD Synchronization...

A partial view of example results:

![image](https://user-images.githubusercontent.com/2527990/185416414-c4275927-bb25-47c5-8385-0f0515237221.png)

The query checks different AuditLogs operations regarding an added device, and also the SignInLogs events that may happen from the same device id.

It is **recommended to check the different filter conditions along the query** ( ```| where not(``` statements), because they may not adapt to your needs.

Azure AD devices may be joined with different trust types:
- Workplace (indicates bring your own personal devices)
- AzureAd (Cloud only joined devices)
- ServerAd (on-premises domain joined devices joined to Azure AD)

In an enterprise you may not expect some trust types to happen depending on your processes, maybe there aren't AD on-premises devices being synchronized to Azure AD, or employees might use managed or personal devices exclusively, or the personal devices have to be enrolled on Intune... So the expected trust types, Intune Group Tags or other information could be defined in a Watchlist to compare against.

Sometimes threat actors may have to join their own devices to Azure AD to use compromised accounts or do other activity, or an employee unknowningly tries to join an external device when signing into their enterprise account in Windows, these devices could be considered anomalous, and it might be worth looking into them.
