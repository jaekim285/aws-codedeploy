# Ensure 64 bit
if ($PSHOME -like "*SysWOW64*")
{
  Write-Warning "Restarting this script under 64-bit Windows PowerShell."

  # Restart this script under 64-bit Windows PowerShell.
  #   (\SysNative\ redirects to \System32\ for 64-bit mode)

  & (Join-Path ($PSHOME -replace "SysWOW64", "SysNative") powershell.exe) -File `
    (Join-Path $PSScriptRoot $MyInvocation.MyCommand) @args

  # Exit 32-bit script.

  Exit $LastExitCode
}

# Was restart successful?
Write-Warning "Hello from $PSHOME"
Write-Warning "  (\SysWOW64\ = 32-bit mode, \System32\ = 64-bit mode)"
Write-Warning "Original arguments (if any): $args"

# Your 64-bit script code follows here...

# ---- VARIABLES ----
$ErrorActionPreference = 'Stop'
$DB = 'Configuration'
$TempOutput = "$env:TEMP\output.txt"
$CurrentPath = Split-Path -Parent "$PSCommandPath"
$QueryFile = "$CurrentPath\configuration_db.sql"

# ---- MAIN ----
try
{
    write-output "Importing SQL"
    Import-Module SqlServer
    write-output "getting region and secret"
    $Region = (Invoke-WebRequest -UseBasicParsing -Uri http://169.254.169.254/latest/dynamic/instance-identity/document | ConvertFrom-Json | Select region).region
    $SQLSecret = (Get-SECSecretValue -SecretId mssql/admin).SecretString | ConvertFrom-Json

    write-output "invoking sql cmd"
    Invoke-Sqlcmd -ServerInstance $SQLSecret.host -Database $DB -Username $SQLSecret.username -Password $SQLSecret.password -InputFile $QueryFile | Out-File -FilePath $TempOutput
    
    write-output "done invoking sql"
    Write-Output "Execution details output: $TempOutput"
}
catch
{
    Write-Output $_.Exception.Message
    exit 1
}