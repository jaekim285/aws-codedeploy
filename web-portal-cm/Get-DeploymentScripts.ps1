#
$ErrorActionPreference = 'Stop'
$ExecutionPath = Split-Path -parent $PSCommandPath
$ArtifactsBucket = 'ddwa-deployment'
$DeploymentFiles = @('Deploy-WebPortalCM.ps1', 'Start-IIS.ps1', 'Stop-IIS.ps1', 'Cleanup-Artifacts.ps1')

#
try 
{
    Write-Output "Execution started from $ExecutionPath"

    foreach ($DeploymentFile in $DeploymentFiles)
    {
        Write-Output "Downloading $DeploymentFile"
        Copy-S3Object -BucketName $ArtifactsBucket -Key "codedeploy-scripts/webcm/$DeploymentFile" -LocalFile (Join-Path -Path $ExecutionPath -ChildPath $DeploymentFile)
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