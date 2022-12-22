
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$initScript = {
    Function Get-BadMath {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$true)][array]$numbers,
            [Parameter(Mandatory=$true)][string]$comment
        )
        # do some bad math
        $result = $numbers[0] / $numbers[1]
        If ($Error.Count -eq 0 ) { 
            return $result
        } Else {
            throw $PSItem.Exception.Message
        }

    }
}

$arrJobs = @()
$nums = @(1, 0)
$hashArgs = @{ numbers=$nums; comment="let's divide 1 by zero" }
[array]$arrJobs += Start-ThreadJob -InitializationScript $initScript -ScriptBlock { param($hashArgs);  Get-BadMath @hashArgs } -Argumentlist $hashArgs

# get results
If ($arrJobs.Count -gt 0) {
    Write-Host "`r`nWaiting for job output . . .`r`n" -ForegroundColor Yellow
    Wait-Job -Job $arrJobs | Out-Null
    ForEach ($j in $arrJobs) {
        If ($j.State -eq 'Failed') {
            Write-Host ("$($j.Name): $($j.JobStateInfo.Reason.Message)") -ForegroundColor Red
        } Else {
            Write-Host ("$($j.Name): $(Receive-Job $j)") -ForegroundColor Green
        }
        Get-Job -Name $j.Name | Remove-Job
    }
}

# debug cleanup
Get-Job | Remove-Job
[string[]]$vars = ('initScript', 'nums', 'hashArgs', 'arrJobs', 'j' )
Remove-Variable -Name $vars -ErrorAction 'SilentlyContinue'
Remove-Variable -Name 'vars'-ErrorAction 'SilentlyContinue'
