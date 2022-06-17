param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

. E:\users\paul\documents\src\clones\PowerShell\MrToolkit\Public\Set-MrInternetConnectionSharing.ps1
. E:\users\paul\documents\src\clones\PowerShell\MrToolkit\Public\Get-MrInternetConnectionSharing.ps1
Set-MrInternetConnectionSharing -InternetInterfaceName 'MainEthernet' -LocalInterfaceName 'Network Bridge' -Enabled $false 
sleep 3
Set-MrInternetConnectionSharing -InternetInterfaceName 'MainEthernet' -LocalInterfaceName 'Network Bridge' -Enabled $true

# Return network interface to a variable for future use
$interface = Get-NetIPInterface -InterfaceAlias "Network Bridge" -AddressFamily IPv4
 
# Set interface to "Obtain an IP address automatically"
$interface | Set-NetIPInterface -Dhcp Enabled
 
# Set interface to "Obtain DNS server address automatically"
$interface | Set-DnsClientServerAddress -ResetServerAddresses