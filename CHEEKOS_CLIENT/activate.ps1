param (
    [switch]$CheckOnly
)

$Secret = 'MR_ROBRUN_SECRET_KEY_2026'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LicFile = Join-Path $ScriptDir "license.key"

function Get-Hwid {
    try {
        $uuid = (Get-CimInstance Win32_ComputerSystemProduct).UUID
        if (-not $uuid) { $uuid = $env:COMPUTERNAME }
        return $uuid.Trim()
    } catch {
        return $env:COMPUTERNAME
    }
}

function Test-MrKey([string]$key) {
    if (-not $key) { return $null }
    $parts = $key.Trim().ToUpper().Split('-')
    if ($parts.Count -ne 4 -or $parts[0] -ne 'MR') { return $null }
    $tier = $parts[1]
    $rand = $parts[2]
    $sig = $parts[3]
    
    $toHash = "$tier-$rand-$Secret"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($toHash)
    $hashBytes = $sha.ComputeHash($bytes)
    $calcSig = ([System.BitConverter]::ToString($hashBytes) -replace '-','').Substring(0, 6)
    
    if ($sig -eq $calcSig) { return $tier }
    return $null
}

function Sign-Payload([string]$payload) {
    $toHash = "$payload|$Secret"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($toHash)
    $hashBytes = $sha.ComputeHash($bytes)
    return ([System.BitConverter]::ToString($hashBytes) -replace '-','').Substring(0, 16)
}

$CurrentHwid = Get-Hwid

# Check existing license file
if (Test-Path $LicFile) {
    try {
        $raw = (Get-Content $LicFile -Raw).Trim()
        $parts = $raw.Split('|')
        # Format: Key|Tier|HWID|ActivatedDate|ExpireDate|Sig
        if ($parts.Count -eq 6) {
            $k = $parts[0]
            $tier = $parts[1]
            $hwid = $parts[2]
            $actDate = [DateTime]::Parse($parts[3])
            $expDate = [DateTime]::Parse($parts[4])
            $sig = $parts[5]
            
            $payload = "$k|$tier|$hwid|$($parts[3])|$($parts[4])"
            $expectedSig = Sign-Payload $payload
            
            if ($sig -eq $expectedSig -and $hwid -eq $CurrentHwid) {
                if ($tier -eq 'LIFE' -or (Get-Date) -le $expDate) {
                    Write-Host ""
                    Write-Host "==================================================" -ForegroundColor DarkGreen
                    Write-Host " [MR] LICENCA ATIVA E VERIFICADA" -ForegroundColor Green
                    Write-Host "==================================================" -ForegroundColor DarkGreen
                    Write-Host " Chave:    $k" -ForegroundColor Gray
                    Write-Host " Plano:    $($tier -replace '7D','7 Dias' -replace '30D','30 Dias' -replace 'LIFE','Vitalicio')" -ForegroundColor White
                    if ($tier -eq 'LIFE') {
                        Write-Host " Validade: Vitalicio (Acesso Ilimitado)" -ForegroundColor Green
                    } else {
                        $remaining = ($expDate - (Get-Date)).Days
                        Write-Host " Validade: $($expDate.ToString('dd/MM/yyyy HH:mm')) ($remaining dias restantes)" -ForegroundColor Yellow
                    }
                    Write-Host "==================================================" -ForegroundColor DarkGreen
                    Write-Host ""
                    exit 0
                } else {
                    Write-Host ""
                    Write-Host "[MR AVISO] Sua licenca expirou em $($expDate.ToString('dd/MM/yyyy')). Renove sua chave." -ForegroundColor Red
                    Remove-Item $LicFile -Force -ErrorAction SilentlyContinue
                }
            } else {
                Write-Host ""
                Write-Host "[MR AVISO] Licenca invalida ou vinculada a outro computador." -ForegroundColor Red
                Remove-Item $LicFile -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {
        Remove-Item $LicFile -Force -ErrorAction SilentlyContinue
    }
}

if ($CheckOnly) {
    exit 1
}

# Prompt for Key
Write-Host ""
Write-Host "==================================================" -ForegroundColor DarkGreen
Write-Host "        MR ROB RUN - ATIVACAO DE LICENCA          " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor DarkGreen
Write-Host " Cole sua chave de acesso recebida apos a compra." -ForegroundColor Gray
Write-Host " Formato: MR-7D-XXXXXXXX-XXXXXX" -ForegroundColor DarkGray
Write-Host ""

$inputKey = (Read-Host " Digite sua Chave (License Key)").Trim()

if (-not $inputKey) {
    Write-Host "[MR ERRO] Nenhuma chave informada. Encerrando..." -ForegroundColor Red
    exit 1
}

$tier = Test-MrKey $inputKey
if (-not $tier) {
    Write-Host ""
    Write-Host "[MR ERRO] Chave de acesso invalida! Verifique os caracteres e tente novamente." -ForegroundColor Red
    Write-Host ""
    exit 1
}

$now = Get-Date
if ($tier -eq '7D') {
    $exp = $now.AddDays(7)
} elseif ($tier -eq '30D') {
    $exp = $now.AddDays(30)
} else {
    $exp = $now.AddYears(50)
}

$payload = "$inputKey|$tier|$CurrentHwid|$($now.ToString('o'))|$($exp.ToString('o'))"
$sig = Sign-Payload $payload
$licContent = "$payload|$sig"

Set-Content -Path $LicFile -Value $licContent -Force

Write-Host ""
Write-Host "==================================================" -ForegroundColor DarkGreen
Write-Host " [MR SUCESSO] CHAVE ATIVADA COM SUCESSO!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor DarkGreen
Write-Host " Plano ativado: $($tier -replace '7D','7 Dias' -replace '30D','30 Dias' -replace 'LIFE','Vitalicio')" -ForegroundColor White
if ($tier -eq 'LIFE') {
    Write-Host " Validade: Vitalicio (Acesso Ilimitado)" -ForegroundColor Green
} else {
    Write-Host " Validade ate: $($exp.ToString('dd/MM/yyyy HH:mm'))" -ForegroundColor Yellow
}
Write-Host " Computador vinculado com sucesso." -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor DarkGreen
Write-Host ""

exit 0
