# teklif-flutter mobil/web istemcisini lokal gelistirme icin baslatir.
# Varsayilan: bagli/acik bir Android cihaz/emulator varsa onu kullanir; yoksa
# bilinen Pixel 7 emulator'unu otomatik acar. Hicbiri olmazsa Chrome'a duser.
# Belirli bir cihaz zorlamak icin: .\run-dev.ps1 -Device <id>  (bkz: flutter devices)

param(
    [string]$Device = ""
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Get-AndroidDevice {
    $json = flutter devices --machine 2>$null | Out-String
    try { $devices = $json | ConvertFrom-Json } catch { return $null }
    return ($devices | Where-Object { $_.targetPlatform -like "android-*" } | Select-Object -First 1)
}

flutter pub get

if (-not $Device) {
    $android = Get-AndroidDevice
    if ($android) {
        $Device = $android.id
        Write-Host "Android cihaz bulundu: $($android.name)" -ForegroundColor Cyan
    }
    else {
        Write-Host "Bagli Android cihaz/emulator yok. Pixel 7 - API 36.0 emulator'u baslatiliyor..." -ForegroundColor Yellow
        Start-Process flutter -ArgumentList "emulators","--launch","pixel_7_-_api_36_0" -WindowStyle Hidden

        $timeoutSeconds = 150
        $elapsed = 0
        do {
            Start-Sleep -Seconds 3
            $elapsed += 3
            $android = Get-AndroidDevice
        } while (-not $android -and $elapsed -lt $timeoutSeconds)

        if ($android) {
            $Device = $android.id
            Write-Host "Emulator hazir: $($android.name)" -ForegroundColor Green
        }
        else {
            Write-Host "Emulator $timeoutSeconds sn icinde acilmadi, Chrome'a dusuluyor." -ForegroundColor Red
            $Device = "chrome"
        }
    }
}

Write-Host "teklif-flutter baslatiliyor (device: $Device, backend: http://localhost:5074)..." -ForegroundColor Cyan
flutter run -d $Device
