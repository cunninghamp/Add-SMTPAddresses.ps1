<#
.SYNOPSIS
Add-SMTPAddresses.ps1 - Add SMTP addresses to Office 365 users for a new domain name

.DESCRIPTION 
This PowerShell script will add new SMTP addresses to existing Office 365 mailbox users
for a new domain. This script fills the need to make bulk email address changes
in Exchange Online when Email Address Policies are not available.

.OUTPUTS
Results are output to a text log file.

.PARAMETER Domain
The new domain name to add SMTP addresses to each Office 365 mailbox user.

.PARAMETER MakePrimary
Specifies that the new email address should be made the primary SMTP address for the mailbox user.

.PARAMETER Commit
Specifies that the changes should be committed to the mailboxes. Without this switch no changes
will be made to mailboxes but the changes that would be made are written to a log file for evaluation.

.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com
This will perform a test pass for adding the new alias@office365bootcamp.com as a secondary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary
This will perform a test pass for adding the new alias@office365bootcamp.com as a primary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary -Commit
This will add the new alias@office365bootcamp.com as a primary email address
to all mailboxes.

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp
#>

#requires -version 2

[CmdletBinding()]
param (
	
	[Parameter( Mandatory=$true )]
	[string]$Domain,

    [Parameter( Mandatory=$false )]
    [switch]$Commit,

    [Parameter( Mandatory=$false )]
    [switch]$MakePrimary

	)

#...................................
# Variables
#...................................

$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$logfile = "$myDir\Add-SMTPAddresses.log"


#...................................
# Functions
#...................................

#This function is used to write the log file
Function Write-Logfile()
{
	param( $logentry )
	$timestamp = Get-Date -DisplayHint Time
	"$timestamp $logentry" | Out-File $logfile -Append
}


#...................................
# Script
#...................................

#Check if new domain exists in Office 365 tenant

$chkdom = Get-AcceptedDomain $domain

if (!($chkdom))
{
    Write-Warning "You must add the new domain name to your Office 365 tenant first."
    EXIT
}

#Get the list of mailboxes in the Office 365 tenant
$Mailboxes = @(Get-Mailbox -ResultSize Unlimited)
 
Foreach ($Mailbox in $Mailboxes)
{

    Write-Host "******* Processing: $mailbox"
    Write-Logfile "******* Processing: $mailbox"

    $NewAddress = $null

    #If -MakePrimary is used the new address is made the primary SMTP address.
    #Otherwise it is only added as a secondary email address.
    if ($MakePrimary)
    {
        $NewAddress = "SMTP:" + $Mailbox.Alias + "@$Domain"
    }
    else
    {
        $NewAddress = "smtp:" + $Mailbox.Alias + "@$Domain"
    }

    #Write the current email addresses for the mailbox to the log file
    Write-Logfile ""
    Write-Logfile "Current addresses:"
    
    $addresses = @($mailbox | Select-Object -Expand EmailAddresses | ? {$_ -ne $NewAddress })

    foreach ($address in $addresses)
    {
        Write-Logfile $address
    }

    #If -MakePrimary is used the existing primary is changed to a secondary
    if ($MakePrimary)
    {
        Write-LogFile ""
        Write-Logfile "Converting current primary address to secondary"
        $addresses = @($addresses -Replace "SMTP","smtp")
    }

    #Add the new email address to the list of addresses
    Write-Logfile ""
    Write-Logfile "New email address to add is $newaddress"

    $addresses += $NewAddress

    #You must use the -Commit switch for the script to make any changes
    if ($Commit)
    {
        Write-LogFile ""
        Write-LogFile "Committing new addresses:"
        foreach ($address in $addresses)
        {
            Write-Logfile $address
        }
        Set-Mailbox -Identity $Mailbox.Alias -EmailAddresses $addresses      
    }
    else
    {
        Write-LogFile ""
        Write-LogFile "New addresses:"
        foreach ($address in $addresses)
        {
            Write-Logfile $address
        }
        Write-LogFile "Changes not committed, re-run the script with the -Commit switch when you're ready to apply the changes."
        Write-Warning "No changes made due to -Commit switch not being specified."
    }

    Write-Logfile ""
}

#...................................
# Finished
#...................................
