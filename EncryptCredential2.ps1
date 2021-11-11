param(
    [Parameter(ParameterSetName='String',Mandatory=$true,Position=0)]
    [string[]]$InputString,
    [Parameter(ParameterSetName='File',Mandatory=$true,Position=0)]
    [string]$InputFile,
    [Parameter(Position=1)]
    [string]$Path = $PSScriptRoot,
    [switch]$KeyString #This option outputs the key as a base64-encoded string instead of a byte stream
)

# Generate random AES key
$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
if ($PSBoundParameters.ContainsKey('KeyString')) {
    Set-Content -Path ($Path + '\string.key') -Value ([Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($key))) -Force -Encoding Unicode
}
else {
    Set-Content -Path ($Path + '\string.key') -Value $Key -Force -Encoding Byte
}

# Encrypt each string with the generated key
if ($PSCmdlet.ParameterSetName -eq 'File') {
    $InputString = (Get-Content -Raw -Path $InputFile) -split ','
}
for ($i = 0; $i -lt $InputString.Count; $i++) {
    $strEnc = ConvertTo-SecureString -String $InputString[$i] -AsPlainText -Force | ConvertFrom-SecureString -Key $Key
    Set-Content -Path ($Path + '\string' + $i.ToString() + '.enc') -Value $strEnc -Force
}

<#
INSTRUCTIONS ON DECRYPTING

If the key is a base64-encoded string, add these lines:
$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String((Get-Content -Raw -Path <path_to_key>)))
[byte[]]$Key = $decoded -split ' '
$SecStr = Get-Content -Raw -Path <path_to_string> | ConvertTo-SecureString -Key $Key
--

If the key is in a file, add this line:
$SecStr = Get-Content -Raw -Path <path_to_string> | ConvertTo-SecureString -Key (Get-Content -Path <path_to_key> -Encoding Byte)
--

[System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecStr))
#>
