# PortScanner.ps1 - Simple and visual port scanner for Windows
# Author: Anass
# This software is released into the public domain.
# You are free to use and modify


param(
    [Parameter(Mandatory=$false)]
    [string]$HostTarget = "localhost",

    [Parameter(Mandatory=$false)]
    [string]$Ports = "21,22,80,443,3389,8080"
)

# Header banner
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "        PORT SCANNER - WINDOWS               " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Target host: $HostTarget" -ForegroundColor Yellow
Write-Host "Ports to scan: $Ports" -ForegroundColor Yellow
Write-Host ""

# Prepare port list
$portList = @()
if ($Ports -match "-") {
    $range = $Ports -split "-"
    $portList = $range[0]..$range[1]
} else {
    $portList = $Ports -split ","
}

$resultados = @()
$abiertos = 0
$cerrados = 0

Write-Host "Scanning..." -ForegroundColor Magenta
Write-Host ""

foreach ($port in $portList) {
    $port = $port.Trim()
    $tcp = New-Object System.Net.Sockets.TcpClient
    $asyncResult = $tcp.BeginConnect($HostTarget, $port, $null, $null)
    $wait = $asyncResult.AsyncWaitHandle.WaitOne(1000, $false)

    if ($wait) {
        try {
            $tcp.EndConnect($asyncResult)
            $tcp.Close()
            Write-Host "Port $port - OPEN" -ForegroundColor Green
            $resultados += "PORT $port : OPEN"
            $abiertos++
        } catch {
            Write-Host "Port $port - CLOSED" -ForegroundColor Red
            $resultados += "PORT $port : CLOSED"
            $cerrados++
        }
    } else {
        Write-Host "Port $port - CLOSED (timeout)" -ForegroundColor Red
        $resultados += "PORT $port : CLOSED"
        $cerrados++
    }
}

# Summary
Write-Host ""
Write-Host "SCAN SUMMARY" -ForegroundColor Cyan
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "Open ports: $abiertos" -ForegroundColor Green
Write-Host "Closed ports: $cerrados" -ForegroundColor Red
Write-Host "Total scanned: $($abiertos + $cerrados)" -ForegroundColor Yellow
Write-Host ""

# Ask to save results
Write-Host "Do you want to save the results to a TXT file? (y/n): " -ForegroundColor Cyan -NoNewline
$respuesta = Read-Host

if ($respuesta -eq "y" -or $respuesta -eq "Y" -or $respuesta -eq "s" -or $respuesta -eq "S") {

    # Always save file in the same directory as the script
    $scriptPath = $PSScriptRoot
    $nombreArchivo = Join-Path $scriptPath "scan_$($HostTarget -replace '\.', '_')_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    "=== PORT SCAN RESULTS ===" | Out-File -FilePath $nombreArchivo -Encoding UTF8
    "Host: $HostTarget" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    "=========================" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    
    foreach ($linea in $resultados) {
        $linea | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    }
    
    "=========================" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    "Total ports: $($abiertos + $cerrados)" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    "Open: $abiertos | Closed: $cerrados" | Out-File -FilePath $nombreArchivo -Append -Encoding UTF8
    
    Write-Host ""
    Write-Host "Results saved to: $nombreArchivo" -ForegroundColor Green

} else {

    Write-Host ""
    Write-Host "Results not saved." -ForegroundColor Gray
}

Write-Host ""
Write-Host "Scan completed!" -ForegroundColor Cyan
Write-Host ""
