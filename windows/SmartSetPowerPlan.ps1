# SmartSetPowerPlan.ps1
# The environment variables defined below must be set BEFORE running this script
# Alternatively, just set/overwrite the values within the script itself

# $env:POWERPLAN_LOG_PATH - Path to log File
# $env:POWERPLAN_PEAK_START_HOUR - Peak Period Start Hour (24h Format)
# $env:POWERPLAN_PEAK_END_HOUR - Peak Period End Hour (24h Format)
# $env:POWERPLAN_TIMEZONE - IANA Timezone ID

# Set values via defined env vars || default to personal config(s)
$log_path = $env:POWERPLAN_LOG_PATH ?? ".\powerplan_log.txt"
$peak_start = $env:POWERPLAN_PEAK_START_HOUR ?? 16
$peak_end = $env:POWERPLAN_PEAK_END_HOUR ?? 21
$timezone = $env:POWERPLAN_TIMEZONE ?? "America/Los_Angeles"

function Write-Log {
    param ([string]$message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    if (-not (Test-Path $log_path)) {
        New-Item -Path $log_path -ItemType File -Force | Out-Null
    }
    Add-Content -Path $log_path -Value "$timestamp`t$message"
}

$plans = @{
    peak    = "a1841308-3541-4fab-bc81-f71556f20b4a"
    offpeak = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
}
$labels = @{
    "a1841308-3541-4fab-bc81-f71556f20b4a" = "Power Saver"
    "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" = "High Performance"
}

$tz = [System.TimeZoneInfo]::FindSystemTimeZoneById($timezone)
Write-Host "Timezone: $tz"
$now = [System.TimeZoneInfo]::ConvertTime([datetime]::UtcNow, $tz)
Write-Host "Current Time: $now"
$hour = $now.Hour
Write-Host "Current Hour: $hour | Peak Hours: $peak_start-$peak_end"

$plan_get = ($hour -ge $peak_start -and $hour -lt $peak_end) `
    ? "peak" `
    : "offpeak"
$target = $plans[$plan_get]
$current = ((powercfg /getactivescheme) -match ':\s([a-f0-9\-]{36})') `
    ? $Matches[1] `
    : $null
$cur_label, $tgt_label = $labels[$current], $labels[$target]
Write-Host `
"Current Plan: $current ($cur_label) | Target Plan: $target ($tgt_label)"

if ($current.ToLower() -ne $target.ToLower()) {
    powercfg /s $target
    Write-Log "Switched from ($current) ($cur_label) to $target ($tgt_label)"
    Write-Host (Get-Content $log_path -Tail 1)
}
