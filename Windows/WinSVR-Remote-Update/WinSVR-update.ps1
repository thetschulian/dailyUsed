#### THIS IS IN DEVELOPMENT STATUS
### ONLY WORKS ON DOMAIN INFRASTRUCTURES
########################################
# Toggle read-only mode: 1 = report only, 0 = install updates and reboot
$readonly = 1

# Ensure PSWindowsUpdate module is available
$moduleName = "PSWindowsUpdate"
if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    Write-Host "Required module '$moduleName' not found. Installing..."
    try {
        Install-Module -Name $moduleName -Force -Scope CurrentUser -AllowClobber
        Write-Host "Module '${moduleName}' installed successfully."
    } catch {
        Write-Host "Failed to install module '${moduleName}'. Exiting."
        exit 1
    }
}
Import-Module $moduleName

# Setup log file
$timestamp = Get-Date -Format "yyMMddHHmmss"
$localUser = $env:USERNAME
$logFile = "C:\Logs\$timestamp-$localUser-windows-patch.log"
New-Item -Path $logFile -ItemType File -Force | Out-Null
Write-Host "Logging to: $logFile"
Add-Content -Path $logFile -Value "=== Windows Patch Log Started at $(Get-Date) ==="

# Load server list
$servers = Import-Csv -Path ".\servers.csv"
$jobs = @()

foreach ($entry in $servers) {
    $server = $entry.ServerName
    $username = $entry.Username

    Write-Host "Enter password for $username@$server"
    try {
        $password = Read-Host -AsSecureString

        # Prefix with .\ if it's a local account
        if ($username -notmatch "\\") {
            $username = ".\$username"
        }

        $cred = New-Object System.Management.Automation.PSCredential ($username, $password)
    } catch {
         Write-Host "Failed to capture credentials for ${server}: ${_}"

        continue
    }

    $jobs += Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock {
        param($logFilePath, $readonly)

        function Log {
            param([string]$msg)
            $timestamp = Get-Date -Format "HH:mm:ss"
            $entry = "$timestamp [$env:COMPUTERNAME] $msg"
            Write-Host $entry
            Add-Content -Path $logFilePath -Value $entry
        }

        Log "Starting update process..."

        try {
            Import-Module PSWindowsUpdate -ErrorAction Stop
            $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot
            if ($updates.Count -gt 0) {
                Log "Updates available:"
                $updates | ForEach-Object { Log "$($_.Title) - KB$($_.KB)" }

                if ($readonly -eq 0) {
                    Install-WindowsUpdate -AcceptAll -IgnoreReboot -AutoReboot
                    Log "Updates installed. Reboot initiated."

                    # Wait for reboot and reconnect
                    $timeout = 600
                    $interval = 10
                    $elapsed = 0
                    $online = $false

                    while ($elapsed -lt $timeout) {
                        try {
                            if (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1 -Quiet) {
                                Log "Server is back online."
                                $online = $true
                                break
                            }
                        } catch {
                            Log "Ping failed: $_"
                        }
                        Start-Sleep -Seconds $interval
                        $elapsed += $interval
                    }

                    if (-not $online) {
                        Log "Server did not come back online within ${timeout} seconds."
                        return
                    }

                    # Verify update status
                    $remaining = Get-WindowsUpdate -AcceptAll -IgnoreReboot
                    if ($remaining.Count -eq 0) {
                        Log "All updates successfully installed."
                    } else {
                        Log "Updates still pending:"
                        $remaining | ForEach-Object { Log "$($_.Title) - KB$($_.KB)" }
                    }
                } else {
                    Log "Read-only mode active. No updates installed."
                }
            } else {
                Log "No updates available."
            }
        } catch {
            Log "Update check failed: $_"
        }

        Log "Finished patching."
    } -ArgumentList $logFile, $readonly -AsJob
}

Write-Host "Waiting for all update jobs to complete..."
$jobs | Wait-Job

foreach ($job in $jobs) {
    try {
        Receive-Job -Job $job
    } catch {
        Write-Host "Error receiving job output: $_"
    }
    Remove-Job -Job $job
}

Add-Content -Path $logFile -Value "=== Windows Patch Log Completed at $(Get-Date) ==="
Write-Host "All jobs completed. Log saved to $logFile"
