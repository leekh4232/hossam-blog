[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [switch]$Force,
  [switch]$NoPrompt
)

# ==============================
# 관리자 권한 자동 상승
# ==============================
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠ 관리자 권한이 필요합니다. 관리자 권한으로 다시 실행합니다..." -ForegroundColor Yellow
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`" $(if($Force){'-Force'}) $(if($NoPrompt){'-NoPrompt'})" -Verb RunAs
    exit
}

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

Write-Host "=== Ruby + Jekyll 환경 제거 시작 ===" -ForegroundColor Cyan

function Confirm-Action {
  param([string]$Message)
  if ($NoPrompt) { return $true }
  $res = Read-Host "$Message [y/N]"
  return ($res -match '^(y|yes)$')
}

function Remove-FromUserPath {
  param([string[]]$PathsToRemove)
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if ([string]::IsNullOrWhiteSpace($userPath)) { return }
  $sep = ';'
  $items = $userPath.Split($sep) | Where-Object { $_ -ne '' }

  $normalizedTargets = $PathsToRemove | ForEach-Object {
    try { (Resolve-Path $_ -ErrorAction SilentlyContinue).Path } catch { $_ }
  }

  $kept = @()
  foreach ($item in $items) {
    $normItem = $item
    try { $normItem = (Resolve-Path $item -ErrorAction SilentlyContinue).Path } catch {}
    if ($normalizedTargets -contains $normItem) {
      Write-Host "🧹 PATH(User)에서 제거: $item"
      continue
    }
    $kept += $item
  }

  $newPath = ($kept -join $sep)
  [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

# -----------------------------
# Ruby 관련 경로
# -----------------------------
$RubyId   = 'RubyInstallerTeam.RubyWithDevKit.3.2'
$RubyDefaultDir   = 'C:\Ruby32-x64'
$RubyDefaultBin   = Join-Path $RubyDefaultDir 'bin'
$UserHome         = $env:USERPROFILE

# Ruby bin 경로 찾기
$rubyCmd = Get-Command ruby -ErrorAction SilentlyContinue
$rubyBin = $null
if ($rubyCmd) {
  $rubyBin = Split-Path $rubyCmd.Source -Parent
} elseif (Test-Path $RubyDefaultBin) {
  $rubyBin = $RubyDefaultBin
}

# -----------------------------
# 1) RubyGems(jekyll, bundler) 제거
# -----------------------------
if ($rubyBin -and (Test-Path (Join-Path $rubyBin 'gem.cmd'))) {
  Write-Host "💎 RubyGems 제거: jekyll, bundler"
  try { & (Join-Path $rubyBin 'gem.cmd') uninstall jekyll  -aIx | Out-Null } catch {}
  try { & (Join-Path $rubyBin 'gem.cmd') uninstall bundler -aIx | Out-Null } catch {}
} else {
  Write-Host "ℹ gem.cmd를 찾지 못했으므로 RubyGems 개별 제거는 건너뜁니다." -ForegroundColor Yellow
}

# -----------------------------
# 2) winget으로 Ruby 제거
# -----------------------------
try {
  $listed = (winget list --id $RubyId 2>$null)
  if ($LASTEXITCODE -eq 0 -and $listed) {
    Write-Host "📦 winget uninstall: $RubyId"
    winget uninstall --id $RubyId --silent --accept-source-agreements --accept-package-agreements 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✅ 제거 완료: $RubyId"
    } else {
      Write-Host "⚠ winget 제거 실패(계속 진행): $RubyId" -ForegroundColor Yellow
    }
  } else {
    Write-Host "ℹ winget 목록에 없음(건너뜀): $RubyId"
  }
} catch {
  Write-Host "⚠ winget 제거 시 예외 발생: $($_.Exception.Message)" -ForegroundColor Yellow
}

# -----------------------------
# 3) 잔여 폴더 삭제
# -----------------------------
if (Test-Path $RubyDefaultDir) {
  if ($Force -or (Confirm-Action -Message "Ruby 기본 폴더 삭제할까요? -> $RubyDefaultDir")) {
    try {
      Remove-Item -LiteralPath $RubyDefaultDir -Recurse -Force -ErrorAction Stop
      Write-Host "🗑 삭제 완료: $RubyDefaultDir"
    } catch {
      Write-Host "⚠ 삭제 실패: $($_.Exception.Message)" -ForegroundColor Yellow
    }
  }
}

# -----------------------------
# 4) PATH(User) 정리
# -----------------------------
if ($RubyDefaultBin) {
  if ($NoPrompt -or (Confirm-Action -Message "PATH(User)에서 Ruby bin 경로 제거할까요?")) {
    Remove-FromUserPath -PathsToRemove @($RubyDefaultBin)
  }
}

# -----------------------------
# 5) 캐시/설정 폴더 정리
# -----------------------------
$maybeTraces = @(
  @{Path=(Join-Path $UserHome '.bundle'); Label='.bundle'},
  @{Path=(Join-Path $UserHome '.gem');    Label='.gem'}
)

foreach ($t in $maybeTraces) {
  $p = $t.Path
  if (Test-Path $p) {
    if ($Force -or (Confirm-Action -Message "잔여 폴더 삭제할까요? [$($t.Label)] -> $p")) {
      try {
        Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop
        Write-Host "🧽 정리 완료: $p"
      } catch {
        Write-Host "⚠ 정리 실패: $($_.Exception.Message)" -ForegroundColor Yellow
      }
    }
  }
}

Write-Host ""
Write-Host "✅ Ruby + Jekyll 환경 제거 완료" -ForegroundColor Green
Write-Host "변경 사항이 PATH에 즉시 반영되지 않으면 새 PowerShell 세션을 열거나 로그아웃/로그인을 권장합니다." -ForegroundColor Cyan
