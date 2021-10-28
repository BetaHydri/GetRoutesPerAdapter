# GetRoutesPerAdapter

##You can use the script like this:
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Sort-Object Interface | Format-Table -AutoSize
- Get-ActiveRoutesPerAdapter -AddressType IPv4 | Where-Object Interface -like "*Ethernet*" | Format-Table
