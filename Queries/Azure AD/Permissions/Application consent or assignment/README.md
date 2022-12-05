### Application consent or assignment

This query can help you to detect consents to applications and application assignments, in Azure AD, performed by *users* or *admins*. The query will try to show the scope of the operations, if it was consented for *one user* or *all users*, and which permissions were consented.

This query checks the following AuditLogs operations, and will try to group events by ```CorrelationId``` and omit redundant information:

- Consent to application
- Add delegated permission grant
- Add app role assignment grant to user
- Add app role assignment to service principal

The query will group the permissions by "Permission Resource API", like Microsoft Graph, Office 365 Exchange Online, Office 365 SharePoint Online, Windows Azure Active Directory...

For example, the permission User.Read may exist both in Microsoft Graph and Windows Azure Active Directory resources, and Azure AD will treat them as different permissions.

Additionally, if you have defined the consent risk of several permissions, in a dictionary or Watchlist, the query could look up the risk of each consented permission, or if the consented permission or its risk has not been defined yet in the dictionary.

A partial view of some example results:

![image](https://user-images.githubusercontent.com/2527990/184629573-5ef53f40-7c51-49ab-8bca-c373acbc04f5.png)

You could list Microsoft Graph permissions with [this query](https://github.com/ep3p/Sentinel_KQL/blob/main/Queries/Permissions/ExternalData-Microsoft%20Graph%20permissions.kql) and build your consent risk dictionary from there.
