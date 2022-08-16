### Azure AD role assignment

This query can help you to detect and group Azure AD role assignments made through PIM or CoreDirectory services (PIM will use CoreDirectory internally).

A partial view of example results:

![image](https://user-images.githubusercontent.com/2527990/184909897-18503caf-4c1a-4816-96c9-a50a36a9af14.png)


The query checks many different operations because PIM offers several types of conditional assignments (permanent, timebound, eligible, activation...), and Azure AD allows to use built-in roles and custom role definitions.

A example set of checked operations:

![image](https://user-images.githubusercontent.com/2527990/184901612-b6bccf47-7747-46e0-a3a2-441f91eb6385.png)

The events are grouped by several characteristics to try to summarize information, the query will group:
- *PIM* events with their associated *CoreDirectory* events
- *requested* events and *completed* events by ```CorrelationId```
- events with the same role and account (for example an admin that activates repeatedly the same eligible role for a few hours)

When several events are grouped the query will display the variable information of the last event. This may limit information of some columns like ```ResultReason```, but you can always modify the summarize operation according to your needs.

The query will try to assess the kind and severity of the operations, depending on if it is a permanent operation, an eligible operation, a remove operation, if the role is predefined as privileged, if the operation happened during working hours, if it was performed automatically by PIM...
