#
$ErrorActionPreference = 'Stop'
$ExecutionPath = Split-Path -parent $PSCommandPath
$ReleasePath = 'D:\webroot\smile\Website'

#
try
{
    robocopy $ExecutionPath $ReleasePath /E /ZB /MT:32 /R:5 /W:5 /DCOPY:T /V /ETA /TEE
    exit 0
}
catch
{
    Write-Output $_.Exception.Message
    exit 1
}