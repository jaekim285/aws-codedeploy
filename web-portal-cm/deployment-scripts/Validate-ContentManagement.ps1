# ---- VARIABLES ----
$ErrorActionPreference = 'Stop'

# ---- MAIN ----
try 
{
    Write-Output 'Starting IIS'
    #Invoke-Expression "iisreset"
    $ServicesToStop = @('W3SVC', 'WAS')
    Get-Service $ServicesToStop | Start-Service -PassThru
    Write-Output 'Done starting IIS'
    
    Write-Output "Configuring shell to ignore invalid certs"

Add-Type -TypeDefinition @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy
{
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem)
{
return true;
}
}
"@
    
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    
    $TestHost = "127.0.0.1  ddwa.privatealb.com"
    
    "`r`n" + $TestHost | Out-File -FilePath ( $env:windir + '\System32\drivers\etc\hosts' ) -Append -Encoding default
    
    Write-Output 'Testing connection to solr'
    $InvokeResponse = (Invoke-WebRequest -UseBasicParsing -Uri 'https://privatealb.com:8983/solr').StatusCode
    Write-Output "Connection to solr successful: $InvokeResponse"
    
    Write-Output 'Precaching site'
    $InvokeResponse = (Invoke-WebRequest -UseBasicParsing -Uri 'https://privatealb.com').StatusCode
    Write-Output "Invoke-WebRequest completed, status code: $InvokeResponse"
    
    $HostsFile = Get-Content -Path ( $env:windir + '\System32\drivers\etc\hosts' ) -Encoding default | `
        Where-Object { $_ -notmatch $TestHost } | Out-String 
        
    $HostsFile | Out-File -FilePath ( $env:windir + '\System32\drivers\etc\hosts' ) -Encoding default -Force
    
    Write-Output 'Completed IIS validation'
    exit 0
}
catch 
{
    $TestHost = "127.0.0.1  ddwa.privatealb.com"
    $HostsFile = Get-Content -Path ( $env:windir + '\System32\drivers\etc\hosts' ) -Encoding default | `
        Where-Object { $_ -notmatch $TestHost } | Out-String 
        
    $HostsFile | Out-File -FilePath ( $env:windir + '\System32\drivers\etc\hosts' ) -Encoding default -Force
    
    Write-Output $_.Exception.Message
    exit 1
}