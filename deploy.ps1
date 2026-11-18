<#
    一键部署到 GitHub Pages

    用法：
      .\deploy.ps1                                        已绑定远程时，直接发布
      .\deploy.ps1 https://github.com/用户名/仓库名.git     首次绑定远程仓库
      .\deploy.ps1 -Message "改了技能区文案"                 自定义提交说明

    做了什么：
      1. 把当前目录的改动提交到 main
      2. 推送 main 到 GitHub
      3. 把 main 强推到 gh-pages 分支（GitHub Pages 从这里取文件）
#>
param(
    [Parameter(Position = 0)][string]$Remote = '',
    [string]$Message = ''
)

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

function Write-Step($text) { Write-Host "-> $text" -ForegroundColor Cyan }
function Write-Ok($text) { Write-Host "[OK] $text" -ForegroundColor Green }
function Fail($text) {
    Write-Host "[X] $text" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail '没找到 git。请先安装 Git for Windows：https://git-scm.com/download/win'
}
if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'index.html'))) {
    Fail '当前目录没有 index.html。请在「单晓鹏-个人主页」文件夹里运行本脚本。'
}

# ---------- 1. 确保是 git 仓库 ----------
if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot '.git'))) {
    git init -b main | Out-Null
    Write-Step '已初始化 git 仓库'
}

# ---------- 2. 绑定远程 ----------
if ($Remote) {
    if (@(git remote) -contains 'origin') {
        git remote set-url origin $Remote
    } else {
        git remote add origin $Remote
    }
    Write-Step "远程仓库：$Remote"
}

if (@(git remote) -notcontains 'origin') {
    Write-Host ''
    Write-Host '还没有绑定远程仓库。' -ForegroundColor Yellow
    Write-Host '请先在 GitHub 新建一个空仓库（Public），然后运行：'
    Write-Host '    .\deploy.ps1 https://github.com/你的用户名/仓库名.git' -ForegroundColor White
    Write-Host ''
    exit 1
}

# ---------- 3. 提交本地改动 ----------
git add -A
if (git status --porcelain) {
    if (-not $Message) { $Message = "site: 更新 $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }
    git commit -m $Message | Out-Null
    Write-Step "已提交：$Message"
}

# ---------- 4. 推送 main ----------
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($branch -ne 'main') {
    git branch -M main
    Write-Step '当前分支已重命名为 main'
}

Write-Step '推送 main ...'
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Fail '推送 main 失败。检查网络、仓库地址，或先在浏览器登录 GitHub。'
}

# ---------- 5. 同步到 gh-pages ----------
Write-Step '同步到 gh-pages ...'
git push -f origin main:gh-pages
if ($LASTEXITCODE -ne 0) {
    Fail '推送 gh-pages 失败。'
}

# ---------- 6. 结果 ----------
Write-Host ''
Write-Ok '部署完成'
Write-Host ''
Write-Host '第一次部署还需要在网页上开启 Pages：'
Write-Host '  仓库 -> Settings -> Pages -> Source: Deploy from a branch'
Write-Host '  分支选 gh-pages，目录选 / (root)，点 Save'
Write-Host ''
Write-Host '网站地址：https://<你的用户名>.github.io/<仓库名>/'
Write-Host ''
