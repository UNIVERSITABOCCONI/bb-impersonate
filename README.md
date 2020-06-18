Blackboard Impersonate
======================

This Blackboard Building Block (B2) allows for System Administrators and Support
Staff to impersonate other users in Blackboard. This project is derived from
the original Impersonate B2, which was developed by [SDSU]() and [USF](http://www.usf.edu/).

This version of the B2 uses entitlements (AKA Permissions) to determine who can
request to impersonate a user, and which users they are allowed to impersonate.

The latest Release can be downloaded from the [Releases Tab](https://github.com/sdsu-its/bb-impersonate/releases),
which includes the  changes and improvements made to the version. It is
installed just like a standard B2.

## Historical Releases
||handle|version|notes
|---|---|---|---|
|Bocconi|boc|1.4|SaaS compatible, prevents escalations priviledges for system roles, does not log impersonate logins|
|SDSU|sdsu|1.3|not working on SaaS, prevents escalations priviledges for system roles, logs impersonate logins|
|USF|usf|1.0.12|SaaS compatible, only sys admin priviledges, does not log impersonate logins|

## Entitlements
There are 2 entitlements that are included with the Building Block, each allows
the user to which the entitlement is assigned to view the tool link in the
Administrator Panel under 'Tools and Utilities', however they control whom the
user is allowed to impersonate.

### Administrator Panel (Tools and Utilities) > Impersonate User w/ Less than or Equal Role
Restricts impersonations to users with an equal or lesser system role. For
example, a `System Support` user is allowed to impersonate an Instructor, but
not a `System Administrator`. This allows for security to be maintained.

### Administrator Panel (Tools and Utilities) > Impersonate Any User     
This entitlement allows users with this permission to impersonate any user in
the system, regardless of their relationship with the impersonated user. This
can be useful if you are having issues completing impersonate requests, since
it bypasses the relationship check that is run in conjunction with the Less
than or Equal entitlement.

# Build instructions
Simply install Gradle and run `gradle install`.