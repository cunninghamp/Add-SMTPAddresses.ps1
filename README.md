# Add-SMTPAddresses.ps1
PowerShell script to perform bulk adding of new SMTP addresses to Office 365 mailboxes.

This PowerShell script will add new SMTP addresses to existing Office 365 mailbox users for a new domain. This script fills the need to make bulk email address changes in Exchange Online when Email Address Policies are not available.

Results are output to a text log file.

## Parameters

- -Domain, The new domain name to add SMTP addresses to each Office 365 mailbox user.
- -MakePrimary, Specifies that the new email address should be made the primary SMTP address for the mailbox user.
- -Commit, Specifies that the changes should be committed to the mailboxes. Without this switch no changes will be made to mailboxes but the changes that would be made are written to a log file for evaluation.

## EXAMPLES
```
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com
```
This will perform a test pass for adding the new alias@office365bootcamp.com as a secondary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

```
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary
```
This will perform a test pass for adding the new alias@office365bootcamp.com as a primary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

```
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary -Commit
```
This will add the new alias@office365bootcamp.com as a primary email address
to all mailboxes.

## More Information
http://exchangeserverpro.com/add-smtpaddresses-ps1-bulk-add-smtp-addresses-to-office-365-mailbox-users

## Credits
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Check out my [books](https://paulcunningham.me/books/) and [courses](https://paulcunningham.me/training/) to learn more about Office 365 and Exchange Server.

Additional contributors:
- Scott Buchanan [GitHub](https://github.com/scottsb) | [Website](https://buchanan.works/)

Additional references:

- Tim McMichael's blog post: http://blogs.technet.com/b/timmcmic/archive/2015/05/17/office-365-bulk-update-email-addresses.aspx
