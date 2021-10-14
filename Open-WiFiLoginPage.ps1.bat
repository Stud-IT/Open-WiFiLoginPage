# & cls & powershell -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(((Get-Content """%0""") -join """`n""")))" & exit
# The above line makes the script executable when renamed .cmd or .bat

# Get Network Interfaces
Write-Host "Scanning through network interfaces... " -NoNewLine
$networkInterfaces = Get-NetIPConfiguration
Write-Host ("Found " + $networkInterfaces.Count + " interfaces")

# Select the WiFi interface and gather information
$wifiInterface = $networkInterfaces | where InterfaceAlias -match "Wi-Fi"
if (!$wifiInterface) {
    cmd /c color 47
    $reply = Read-Host -Prompt "ERROR: Coundn't find wifi interface!`tEnter to quit"
    exit
}
if ($wifiInterface.NetAdapter.Status -eq "Disconnected") {
    cmd /c color 47
    $reply = Read-Host -Prompt "ERROR: You are not connected to a WiFi network!`tEnter to quit"
    exit
}
Write-Host ("Connected to " + $wifiInterface.NetProfile.Name)

# Generate login page
$loginpage = "http:\\" + $wifiInterface.IPv4DefaultGateway.NextHop
Write-Host ("Opening login page (" + $loginpage + ")...")

# Open login page
start $loginpage

# Keep window alive for debugging purposes
Start-Sleep -Seconds 3