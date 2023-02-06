## Functions

Functions can be saved in a Log Analytics workspace, to be used in any KQL query just by calling the function name.
They can be reused in Scheduled Analytics Rules, you could edit the code of a function that is called in several rules, and the rules won't have to be edited.

NRT Analytics Rules can't use functions defined in the Log Analytics workspace, because the function could call multiple tables and saturate the workspace, but to surpass this limitation a function can be defined in the same query of the NRT rule, where the function code can be validated.
Some of the queries in this repository are expected to be used in NRT rules and they use functions defined here, to deploy the NRT rules you will have to prepend the function code to each query.
