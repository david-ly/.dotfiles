## Automatic Power Plan/State Management
PowerShell's "API" for programmatically creating tasks in Task Scheduler isn't exactly 1:1 with all of its configuration options via its GUI or XML import/export.   

TODO: Demystify the relationship between `Task` XML schema and `pwsh`'s cmdlet(s) to set/register `Task`s
`RegisterAutoPowerPlan.ps1`:
* Defaults to `Configure for: Windows Vista, Windows Server 2008`
* Other default settings: (XML equivalents listed below)
  * `<AllowStartOnDemand>True</...>`
  * `<DisallowStartIfOnBatteries>True</...>`
  * `<ExecutionTimeLimit>PT3D</...>`
  * `<StopIfGoingOnBatteries>True</...>`
  * 
* `-Daily` flag *cannot* be combined with `Repetition{Duration|Interval}`

`AutoPowerPlan.xml`: TODO
