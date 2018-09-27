# This script will generate a random AES256 key and encrypt an input string with that key

param(
    [Parameter(Mandatory=$true,Position=0)]
    [string[]]$InputStr,
    [Parameter(Position=1)]
    [string]$Output_path = $PSScriptRoot
)

# Generate random AES key
$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
Set-Content -Path ($Output_path + '\aes.key') -Value $Key -Force -Encoding UTF8

# Encrypt each string with the generated key
for ($i = 0; $i -lt $InputStr.Count; $i++) {
    $strEnc = ConvertTo-SecureString -String $InputStr[$i] -AsPlainText -Force | ConvertFrom-SecureString -Key $Key
    Set-Content -Path ($Output_path + '\string' + $i.ToString() + '.enc') -Value $strEnc -Force
}

<#

To decrypt the credential, use the following:

$SecStr = Get-Content (Get-Content -Raw -Path <path_to_string>) | ConvertTo-SecureString -Key (Get-Content -Raw -Path <path_to_key>)
[System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecStr))

#>