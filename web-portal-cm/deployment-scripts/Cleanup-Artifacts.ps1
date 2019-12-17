# ---- VARIABLES ----
$ErrorActionPreference = 'Continue'
$CurrentPath = Split-Path -Parent $PSCommandPath
$DeploymentRoot = (Get-Item $CurrentPath).Parent.Parent.FullName
$CurrentDeployment = (Get-Item $CurrentPath).Parent.Name
$DeploymentFolders = Get-ChildItem -Path $DeploymentRoot | Select-Object FullName

# ---- MAIN ----
Write-Output "Current deployment: $CurrentDeployment"
Write-Output "Found deployment folders: " $DeploymentFolders
Write-Output "Deleting all folders except: $CurrentDeployment"

foreach ($Folder in $DeploymentFolders)
{
    if (-not($Folder.FullName -like "*$CurrentDeployment*"))
    {
        Write-Output "Deleting: $($Folder.FullName)"
        Remove-Item -Path $Folder.FullName -Recurse -Force
    }
}

exit 0