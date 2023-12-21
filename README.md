# GetRoutesPerAdapter

## Description:
This Powershell script enumerates the actual network routes with their corresponding adapter name.

__You can use the script like this:__
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Sort-Object Interface | Format-Table -AutoSize
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Where-Object Interface -like "*Ethernet*" | Format-Table

## Sample Output:
| DestinationPrefix | DefaultGateway | NextHopLocalIP | RouteMetric | InterfaceMetric | Interface | IfIndex |
| :--- | :--- | :--- | ---: | ---: | ---: | ---: | 
| 224.0.0.0/4 |  | 100.64.137.197 | 256 | 1 | MYVPN | 30 |
| 216.251.141.226/32 |  | 100.64.137.197 | 256 | 1 | MYVPN | 30 |
| 207.68.174.0/24 |  | 100.64.137.197 | 256 | 1 | MYVPN | 30 |
| 100.64.137.197/32 |  | 100.64.137.197 | 256 | 1 | MYVPN | 30 |
| 10.229.131.41/32  |  | 10.229.131.41 | 256 | 35 | Wi-Fi  | 12 |
| 0.0.0.0/0| 10.229.128.1  | | 0 | 35 | Wi-Fi | 12 |

## Code:
```powershell
Function Get-ActiveRoutesPerAdapter {
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
````
