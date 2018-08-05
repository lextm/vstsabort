# Copyright (C) 2018 Lex Li
# https://github.com/lextm/vstsabort
# Released under Apache license.

$abort = $env:LEXTUDIO_VSTSABORT
Write-Host "Environment variable LEXTUDIO_VSTSABORT is $abort"
If ($abort -eq "TRUE")
{
    Write-Host "Abort."
    $url = "$($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)$env:SYSTEM_TEAMPROJECTID/_apis/build/builds/$($env:BUILD_BUILDID)?api-version=2.0"
    Write-Host "URL: $url"
    $pat = ":$env:SYSTEM_PAT"
    $b  = [System.Text.Encoding]::ASCII.GetBytes($pat)
    $token = [System.Convert]::ToBase64String($b)

    $body = @{ 'status'='Cancelling' } | ConvertTo-Json

    $pipeline = Invoke-RestMethod -Uri $url -Method Patch -Body $body -Headers @{
        'Authorization' = "Basic $token";
        'Content-Type' = "application/json"
    }
    Write-Host "Pipeline = $($pipeline)"
}
Else
{
    Write-Host "Continue."
}
