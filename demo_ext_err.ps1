
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

[string[]]$arrPaths = ('C:\temp','C:\temp\temp2')
$arrJobs = @()

$initScript = {
    Function Compress-Movies {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$true, Position=0)][array]$LiteralPath,
            [Parameter(Mandatory=$true, Position=1)][string]$DestinationPath,
            [Parameter(Mandatory=$true, Position=2)][bool]$Update
        )
        Try {
            # create zipfile
            Compress-Archive -LiteralPath $LiteralPath -DestinationPath $DestinationPath -CompressionLevel 'Fastest' -Update:$Update -ErrorAction Stop
        }
        Catch {
            Write-Host $PSItem.Exception.Message -ForegroundColor Red # this won't work if called from a job
        }
        Finally {
            # delete source files
            If ($Error.Count -eq 0 ) {
                $LiteralPath | Remove-Item 
            } Else { 
                $Error.Clear() 
            }
        }
    }
}

ForEach ($dir in $arrPaths) {
    # get files
    $files = @(Get-ChildItem -LiteralPath $dir -Filter '*.mp4') # might be empty array
    # get the lowest subdirectory name
    [regex]$rgx = "([^\\]+)$"
    $temp = $rgx.Match($dir)
    $subDirNm = $temp.Captures.Groups[0].Value
    # create zip file spec
    $zipFileSpec = Join-Path -Path $dir -ChildPath "video_$subDirNm.zip"
    # create unique job name
    $jobNm = "job_$subDirNm"
    # create zip files
    If ($files.Count -ne 0) {
        $hashArgs = @{ LiteralPath=$files.FullName; DestinationPath=$zipFileSpec; Update=$(Test-Path -LiteralPath $zipFileSpec) }
        $arrJobs += Start-ThreadJob -Name $jobNm -InitializationScript $initScript -ScriptBlock { Compress-Movies @hashArgs } -ThrottleLimit 6 -Argumentlist $hashArgs
    } Else {
        Write-Host "`r`nThere are no files to zip in [$dir]" -ForegroundColor Cyan
    }
}

# get results
If ($arrJobs.Count -ne 0) {
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






















