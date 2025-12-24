# ==============================
# 관리자 권한 자동 상승 (UAC Elevation)
# ==============================
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠ 관리자 권한이 필요합니다. 관리자 권한으로 다시 실행합니다..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "=== Windows Jekyll 실행 환경 구축 시작 ===" -ForegroundColor Cyan

# ------------------------------------------------------
# 1. Ruby 설치 (이미 있으면 건너뜀)
# ------------------------------------------------------
if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Ruby 설치 중..."
    winget install --id RubyInstallerTeam.RubyWithDevKit.3.2 --scope user --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "✅ Ruby 이미 설치됨"
}

# Ruby PATH 강제 등록 (기본 설치 경로 기준)
$rubyDefaultBin = "C:\Ruby32-x64\bin"
$currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (Test-Path $rubyDefaultBin) {
    if ($currentUserPath -notlike "*$rubyDefaultBin*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentUserPath;$rubyDefaultBin", "User")
        Write-Host "🔧 Ruby bin 경로를 PATH(User)에 추가: $rubyDefaultBin"
    } else {
        Write-Host "ℹ Ruby bin 경로가 이미 PATH에 포함됨"
    }
    # 현재 세션에도 즉시 반영
    $env:Path = "$rubyDefaultBin;$env:Path"
}

# ------------------------------------------------------
# 2. Node.js 설치 (이미 있으면 건너뜀)
# ------------------------------------------------------
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Node.js LTS 설치 중..."
    winget install --id OpenJS.NodeJS.LTS --scope user --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "✅ Node.js 이미 설치됨"
}

# ------------------------------------------------------
# 3. Git 설치 (이미 있으면 건너뜀)
# ------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Git 설치 중..."
    winget install --id Git.Git --scope user --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "✅ Git 이미 설치됨"
}

# ------------------------------------------------------
# 4. Ruby bin 경로 자동 감지 (PATH 보정)
# ------------------------------------------------------
$rubyCmd = Get-Command ruby -ErrorAction SilentlyContinue
if ($null -eq $rubyCmd) {
    Write-Host "🔍 PATH에 Ruby가 없으므로 설치 경로를 검색합니다..."
    $rubyPossiblePaths = @(
        "$env:USERPROFILE",
        "C:\Ruby",
        "C:\tools",
        "C:\Ruby32-x64"
    ) | Where-Object { Test-Path $_ }

    $rubyBin = $null
    foreach ($path in $rubyPossiblePaths) {
        $found = Get-ChildItem -Path $path -Directory -Recurse -ErrorAction SilentlyContinue |
                 Where-Object { Test-Path (Join-Path $_.FullName "bin\ruby.exe") } |
                 Select-Object -First 1
        if ($found) {
            $rubyBin = Join-Path $found.FullName "bin"
            break
        }
    }

    if (-not $rubyBin) {
        Write-Error "❌ Ruby 실행 파일을 찾을 수 없습니다. 설치 경로를 확인하세요."
        exit
    }

    $env:Path = "$rubyBin;$env:Path"
    Write-Host "🔧 PATH에 Ruby bin 경로 추가 완료: $rubyBin"
} else {
    $rubyExe = $rubyCmd.Source
    $rubyBin = Split-Path $rubyExe -Parent
    $env:Path = "$rubyBin;$env:Path"
    Write-Host "🔧 Ruby bin 경로 감지 완료: $rubyBin"
}

# ------------------------------------------------------
# 5. Jekyll & Bundler 설치 (이미 있으면 건너뜀)
# ------------------------------------------------------
$jekyllInstalled = (& "$rubyBin\gem.cmd" list jekyll --installed) -match "jekyll"
$bundlerInstalled = (& "$rubyBin\gem.cmd" list bundler --installed) -match "bundler"

if (-not $jekyllInstalled) {
    Write-Host "💎 Jekyll 설치 중..."
    & "$rubyBin\gem.cmd" install jekyll
} else {
    Write-Host "✅ Jekyll 이미 설치됨"
}

if (-not $bundlerInstalled) {
    Write-Host "💎 Bundler 설치 중..."
    & "$rubyBin\gem.cmd" install bundler
} else {
    Write-Host "✅ Bundler 이미 설치됨"
}

# ------------------------------------------------------
# 완료 메시지
# ------------------------------------------------------
Write-Host "✅ Jekyll 환경 구축 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "이제 블로그를 생성하려면 다음 명령을 실행하세요:" -ForegroundColor Cyan
Write-Host "    jekyll new myblog" -ForegroundColor Yellow
Write-Host "    cd myblog" -ForegroundColor Yellow
Write-Host "    bundle exec jekyll serve" -ForegroundColor Yellow
