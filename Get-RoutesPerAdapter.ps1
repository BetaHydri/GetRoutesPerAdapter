
<#PSScriptInfo

.VERSION 1.0.0

.GUID 1bbfeb41-07ae-41fb-a41a-e3f7e4752ac9

.AUTHOR Jan Tiedemann

.COMPANYNAME Jan Tiedemann

.COPYRIGHT 2021

.TAGS Network Routes Nic Adapter

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Shows all network routes per network adapter (NIC) 

#> 


Function Get-ActiveRoutesPerAdapter {

    <#PSScriptInfo

.VERSION 1.0

.GUID 1bbfeb41-07ae-41fb-a41a-e3f7e4752ac9

.AUTHOR Jan Tiedemann

.COMPANYNAME Jan Tiedemann

.COPYRIGHT 2021

.TAGS Network Routes Nic Adapter

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
You can use the script like this:
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Sort-Object Interface | Format-Table -AutoSize
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Where-Object Interface -like "*Ethernet*" | Format-Table

.PRIVATEDATA

#>

    <# 

.DESCRIPTION 
 Shows all network routes per network adapter (NIC) 

#> 
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'AddressType')]
        [ValidateSet('IPv4', 'IPv6')]
        [string]$AddressType
    )
    begin {}
    process {
        Get-NetRoute -AddressFamily $AddressType -PolicyStore ActiveStore | `
            Select-Object -Property `
        @{label = "DestinationPrefix" ; expression = { $PSItem.DestinationPrefix } }, 
        @{label = "DefaultGateway" ; expression = { if ($PSItem.NextHop -ne '0.0.0.0') { $_.NextHop } } }, 
        @{label = 'NextHopLocalIP'; Expression = { if ($PSItem.NextHop -eq '0.0.0.0') { ($PSItem | Get-NetIPAddress -AddressFamily $AddressType | Where-Object ifIndex -EQ $PSItem.IfIndex).IPAddress } } }, 
        @{label = "RouteMetric" ; expression = { $PSItem.RouteMetric } },    
        @{label = "InterfaceMetric" ; expression = { $PSItem.InterfaceMetric } },
        @{label = 'Interface'; Expression = { ($PSItem | Get-NetIPInterface | Where-Object IfIndex -EQ $PSItem.IfIndex).InterfaceAlias } },
        @{label = "IfIndex" ; expression = { $PSItem.IfIndex } }  
    }
    end {}
}


# Main
<# Clear-Host
Get-ActiveRoutesPerAdapter -AddressType IPv4 | Format-Table -AutoSize #>
