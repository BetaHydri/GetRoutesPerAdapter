# GetRoutesPerAdapter

## Description:
This Powershell script enumerates the actual network routes with their corresponding adapter name.

__You can use the script like this:__
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Sort-Object Interface | Format-Table -AutoSize
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Where-Object Interface -like "*Ethernet*" | Format-Table
