#
$ErrorActionPreference = 'Stop'
$ExecutionPath = Split-Path -parent $PSCommandPath
$ReleasePath = 'D:\webroot\csr_web'

#
try
{
    Write-Output "Extracting to $ReleasePath"
    robocopy $ExecutionPath $ReleasePath /E /ZB /MT:32 /R:5 /W:5 /DCOPY:T /V /ETA /TEE
    Write-Output 'Extract completed'
    exit 0
}
catch
{
    Write-Output $_.Exception.Message
    exit 1
}