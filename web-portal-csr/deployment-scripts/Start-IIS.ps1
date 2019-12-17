# ---- VARIABLES ----
$ErrorActionPreference = 'Stop'

# ---- MAIN ----
try
{
    $ServicesToStop = @('W3SVC', 'WAS')
    Get-Service $ServicesToStop | Start-Service -PassThru
    exit 0
}
catch
{
    Write-Output $_.Exception.Message
    exit 1
}