# This script will generate a random AES256 key and encrypt an input string with that key

param(
    [Parameter(Mandatory=$true,Position=0)]
    [string]$StringPath,
    [Parameter(Mandatory=$true,Position=1)]
    [string]$KeyPath
)

# Decrytp string
$Key = New-Object Byte[] 32
$i = 0
foreach ($byte in (Get-Content -Path $KeyPath)) {
    $Key[$i] = ([byte]$byte)
    $i++
}
$SecStr = Get-Content -Raw -Path $StringPath | ConvertTo-SecureString -Key $Key
[System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecStr))