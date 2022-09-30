### Automation Rules or Log Analytics stopped working

These queries can help you to detect when the Automation Rules or the Log Analytics workspace from a Microsoft Sentinel resource are not working as expected. Microsoft Sentinel may have brief moments where it does not work correctly, and then resumes its activity. Microsoft might acknowledge later the malfunction through a Service Health Alert (setting up notifications of these health alerts is recommended).

In this folder there is a "generating" rule and a "notification" rule, both are needed and use SecurityIncident table events. Additionally (and not included here) for this use case to work **you will need**:

- An Automation Rule that automatically closes the incidents from the "generating" rule.
- A playbook with the trigger kind "Microsoft Sentinel Alert", with the actions/notifications you want to happen should this malfunction happen, that will be attached to the "notification" rule.

#### The assumed steps to set up this use case should be:

1. Create the "generating" rule, in a disabled state (pay close attention to the rule settings).
2. Create an Automation Rule that will close incidents from the "generating" rule as "Benign Positive", in an enabled state.
3. Enable the "generating" rule, check the incidents are being automatically closed.
4. Create the "notification" rule, in an enabled state, and in the settings attach to it the "Microsoft Sentinel Alert"-trigger playbook.
5. Wait for a malfunction to happen, or disable temporarily the Automation Rule, to check if the notification happens.

#### Remarks:
- The "notification" rule does not need to create incidents, only alerts.
- The query frequency of both rules should be the same.
- The generating rule will stop generating incidents for a specified period, if the last created incident does not appear as automatically closed in the table SecurityIncident (and an incident may have been closed but you may not have the SecurityIncident event of the closed incident).
