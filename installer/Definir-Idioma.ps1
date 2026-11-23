param([Parameter(Mandatory = $true)][string]$InstallDir)

$ErrorActionPreference = 'Stop'
try {
    if (Get-Process -Name 'flash studio', 'flash-studio', 'Orca-Flashforge' -ErrorAction SilentlyContinue) {
        exit 2
    }

    $dataDir = Join-Path $InstallDir 'data_dir'
    if (-not [IO.Directory]::Exists($dataDir)) {
        $dataDir = Join-Path ([Environment]::GetFolderPath('ApplicationData')) 'Orca-Flashforge'
    }
    $path = Join-Path $dataDir 'Orca-Flashforge.conf'
    $utf8 = New-Object System.Text.UTF8Encoding($false, $true)
    $exists = [IO.File]::Exists($path)
    if ($exists) {
        $original = [IO.File]::ReadAllText($path, $utf8)
        $json = [regex]::Replace($original, '(?m)^# MD5 checksum [0-9a-fA-F]{32}\s*\z', '').TrimEnd()
        $settings = ConvertFrom-Json -InputObject $json
        if ($settings.app.language -ceq 'pt_BR') {
            exit 0
        }

        # Change only the app object as formatted by Flash Studio's JSON writer.
        $app = [regex]::Match($json, '(?m)^    "app": \{[ \t]*\r?\n(?<body>[\s\S]*?)^    \}(?=,?\s*$)')
        if (-not $app.Success) {
            throw 'Unsupported application settings format.'
        }
        $body = $app.Groups['body']
        $language = [regex]::Match($body.Value, '(?m)^        "language": "[^"\r\n]*"(?=,?\r?$)')
        if ($language.Success) {
            $updated = $body.Value.Remove($language.Index, $language.Length).Insert($language.Index, '        "language": "pt_BR"')
        } elseif ($null -eq $settings.app.PSObject.Properties['language']) {
            $newline = if ($body.Value.Contains([string][char]13 + [char]10)) { [string][char]13 + [char]10 } else { [string][char]10 }
            $updated = '        "language": "pt_BR"' + ',' + $newline + $body.Value
        } else {
            throw 'Unsupported language setting format.'
        }
        $json = $json.Remove($body.Index, $body.Length).Insert($body.Index, $updated)
    } else {
        $json = @'
{
    "app": {
        "language": "pt_BR"
    }
}
'@
    }

    if ((ConvertFrom-Json -InputObject $json).app.language -cne 'pt_BR') {
        throw 'Could not verify the language setting.'
    }
    $json = $json -replace '\r\n', [string][char]10
    $md5 = [Security.Cryptography.MD5]::Create()
    try {
        $checksum = [BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($json))).Replace('-', '')
    } finally {
        $md5.Dispose()
    }

    [IO.Directory]::CreateDirectory($dataDir) | Out-Null
    $temporary = Join-Path $dataDir ([guid]::NewGuid().ToString() + '.tmp')
    try {
        [IO.File]::WriteAllText($temporary, $json + [char]10 + '# MD5 checksum ' + $checksum + [char]10, $utf8)
        if ($exists) {
            if ([IO.File]::ReadAllText($path, $utf8) -cne $original) {
                throw 'Settings changed during installation.'
            }
            [IO.File]::Replace($temporary, $path, "$path.pt-br.bak")
        } else {
            [IO.File]::Move($temporary, $path)
        }
    } finally {
        if ([IO.File]::Exists($temporary)) { [IO.File]::Delete($temporary) }
    }
    exit 0
} catch {
    exit 1
}
