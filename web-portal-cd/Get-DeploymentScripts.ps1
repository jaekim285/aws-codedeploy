# ---- VARIABLES ----
$ErrorActionPreference = 'Stop'
$ExecutionPath = Split-Path -parent $PSCommandPath
$ArtifactsBucket = 'deployment'
$DeploymentFiles = @('Deploy-WebPortalCD.ps1', 'Validate-ContentDelivery.ps1', 'Start-ContentDelivery.ps1', 'Stop-ContentDelivery.ps1', 'Cleanup-Artifacts.ps1')

# ---- MAIN ----
try
{
    Write-Output "Execution started from $ExecutionPath"

    foreach ($DeploymentFile in $DeploymentFiles)
    {
        Write-Output "Downloading $DeploymentFile"
        Copy-S3Object -BucketName $ArtifactsBucket -Key "codedeploy-scripts/webcd/$DeploymentFile" -LocalFile (Join-Path -Path $ExecutionPath -ChildPath $DeploymentFile)
        Write-Output "Download successful"
    }

    Write-Output 'Exiting successfully'
    exit 0
}
catch
{
    Write-Error $_.Exception.Message
    exit 1
}