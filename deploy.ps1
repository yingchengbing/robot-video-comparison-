# 一键推送到 GitHub（需已建好空仓库）
param(
    [Parameter(Mandatory = $true)][string]$Repo,   # https://github.com/<user>/<repo>.git
    [string]$Branch = "main",
    [string]$Message = "Add qualitative robot video comparison site"
)

$ErrorActionPreference = "Stop"

$git = (Get-Command git -ErrorAction SilentlyContinue).Source
if (-not $git) {
    foreach ($p in "F:\Git\cmd\git.exe", "C:\Program Files\Git\cmd\git.exe") {
        if (Test-Path $p) { $git = $p; break }
    }
}
if (-not $git) { Write-Host "未找到 git，请先安装 Git for Windows。" -ForegroundColor Red; exit 1 }

if ($Repo -notmatch '^https://github\.com/.+/.+\.git$') {
    Write-Host "仓库地址应形如 https://github.com/yourname/repo.git" -ForegroundColor Yellow
    exit 1
}

Set-Location $PSScriptRoot

if (-not (Test-Path ".git")) { & $git init | Out-Null }
& $git config core.autocrlf false | Out-Null
& $git config http.postBuffer 524288000 | Out-Null

$authorName = "paper-site"
if ($env:GIT_AUTHOR_NAME) { $authorName = $env:GIT_AUTHOR_NAME }
$authorMail = "paper-site@localhost"
if ($env:GIT_AUTHOR_EMAIL) { $authorMail = $env:GIT_AUTHOR_EMAIL }

& $git add -A
& $git -c "user.name=$authorName" -c "user.email=$authorMail" commit -m $Message

& $git branch -M $Branch

$remotes = & $git remote
if ($remotes -contains "origin") { & $git remote set-url origin $Repo } else { & $git remote add origin $Repo }

Write-Host "`n开始推送，330 MB 左右，请耐心等待…" -ForegroundColor Cyan
& $git push -u origin $Branch

if ($LASTEXITCODE -eq 0) {
    $slug = ($Repo -replace '^https://github\.com/', '' -replace '\.git$', '')
    $parts = $slug.Split('/')
    $url = "https://$($parts[0]).github.io/$($parts[1])/"
    Write-Host "`n推送完成。接下来去仓库 Settings → Pages，选择 main / (root) 并保存。" -ForegroundColor Green
    Write-Host "预计访问地址：$url" -ForegroundColor Green
} else {
    Write-Host "推送失败，请检查网络与凭据（PAT / Git Credential Manager）。" -ForegroundColor Red
}
