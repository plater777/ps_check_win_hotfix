# requires -version 2
<#
.SYNOPSIS
		Check if a HotFix is installed in a list
		
.DESCRIPTION
		Check if a HotFix is installed in a list
		
.INPUTS
		1. Server list from an address range
		2. KB or KBs to check
		
.OUTPUTS
		To StdOut or file
		
.NOTES
		Version:	0.1
		Author:		Santiago Platero
		Creation Date:	16/MAY/2019
		Purpose/Change: Initial commit
		
.EXAMPLE
		> ./check_hf.ps1

#>

#---------------------------------------------------------[Initializations]--------------------------------------------------------
$range = Read-Host -Prompt 'Input the IPv4 network address to check without the last octect (i.e. 192.168.0.)'
$kbs = kbs.txt

#----------------------------------------------------------[Declarations]----------------------------------------------------------

# Script info
$scriptVersion = "0.1"
$scriptName = $MyInvocation.MyCommand.Name

#------------------------------------------------------------[Execution]-----------------------------------------------------------

# Function to make a nice message for an error
Function Write-Exception
{
	Write-Host "[$(Get-Date -format $($dateFormat))] ERROR: $($_.Exception.Message)"
	exit 1
}

# Error control
try {
	$servers = 1..254 | % { Test-Connection -count 1 -computer $range$_ -ErrorAction SilentlyContinue } | Select address
	$windows = foreach ($server in $servers) { Get-WmiObject -Class win32_operatingsystem -Computer $server.address -ErrorAction SilentlyContinue | Select CSName,Version }
	foreach ($window in $windows) { foreach ($kb in $kbs ) { Get-HotFix -Id $kb -ComputerName $window.CSName -ErrorAction SilentlyContinue } }
	exit 0
}

# Error print
catch
	{
		Write-Exception
	}
	
# THE END