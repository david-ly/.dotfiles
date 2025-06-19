# RegisterAutoPowerPlan.ps1
# Register a task to run the SmartSetPowerPlan.ps1 script upon boot/login and on an hourly basis

$boot_trigger = New-ScheduledTaskTrigger -AtStartup
$login_trigger = New-ScheduledTaskTrigger -AtLogOn
$hourly_trigger = New-ScheduledTaskTrigger `
  -Once -At 12:00AM `
  -RepetitionInterval (New-TimeSpan -Hours 1)

$action = New-ScheduledTaskAction `
  -Execute "C:\Program Files\PowerShell\7\pwsh.exe" `
  -Argument "-ExecutionPolicy Bypass -File `".\SmartSetPowerPlan.ps1`"" `
  -WorkingDirectory "$env:USERPROFILE\.dotfiles\windows"

$task = "AutoPowerPlan"
Register-ScheduledTask -TaskName $task `
                       -Trigger $boot_trigger, $login_trigger, $hourly_trigger `
                       -Action $action `
                       -Description "Automatically switch power plans based on peak/off-peak hours" `
                       -User "SYSTEM" `
                       -RunLevel Highest -Force
