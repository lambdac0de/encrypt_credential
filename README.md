# encrypt_credential
This is a set of encrypt and decrypt scripts to securely store credentials when they are needed to be sotred in text form. Encryption uses an AES-250 key using MSDAPI (https://msdn.microsoft.com/en-us/library/ms995355.aspx)

## Prerequisite
.Net framework is required since encryption is based on the `Security.Cryptography` .Net namespace.

## Why did I make this?
I am surprised in the number of scripts I see in production servers simply using hardcoded plain text password to authenticate to systems. This is a very simple, yet effective solution to protect passwords when they have to be stored in text form. Of course, this is a last resort if passwod vaulting is not an option.

## Usage
To encrypt:<br>
.\EncryptCredential.ps1 -InputStr [password] -Output_path [output_path_to_save_files]

To decrypt:<br>
.\DecryptCredential.ps1 -StringPath [path_to_string0.enc] -KeyPath [path_to_key.aes]
