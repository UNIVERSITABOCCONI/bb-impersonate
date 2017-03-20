Blackboard Impersonate
======================

This Blackboard Building Block (B2) allows for System Administrators and Support
Staff to impersonate other users in Blackboard. This project is derived from
the original Impersonate B2, which was developed by [USF](http://www.usf.edu/).

This version of the B2 uses entitlements (AKA Permissions) to determine who can
request to impersonate a user, and which users they are allowed to impersonate.

The latest Release can be downloaded from the [Releases Tab](https://github.com/sdsu-its/bb-impersonate/releases),
which includes the  changes and improvements made to the version. It is
installed just like a standard B2.

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

## Logging
The B2 logs to the standard Blackboard logging location, in the `impersonate.log`
file, which can be downloaded from System Logs. The default log level is set to
__INFO__ to include who impersonates a given user, and the current time. This
provides an audit log that can later be used in the event of an investigation.

### Log Levels
Set the log level to __WARN__ to only log errors that occur within the
Impersonate B2.

Set the log level to __INFO__ to log impersonates and errors that occur.

Set the log level to __DEBUG__ if you are having problems complete an
impersonate, as it logs if status checks pass or fail.
