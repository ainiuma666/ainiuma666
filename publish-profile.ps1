$ErrorActionPreference = "Stop"

$username = "ainiuma666"
$repoName = "ainiuma666"
$repoUrl = "https://github.com/$username/$repoName.git"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI (gh) is not installed."
    Write-Host "Install it with:"
    Write-Host "  winget install --id GitHub.cli"
    exit 1
}

gh auth status | Out-Null

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

git add README.md publish-profile.ps1
git commit -m "Create GitHub profile README" 2>$null

$repoExists = $true
gh repo view "$username/$repoName" 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
    $repoExists = $false
}

if (-not $repoExists) {
    gh repo create "$username/$repoName" --public --source . --remote origin --push
} else {
    $remoteUrl = git remote get-url origin 2>$null
    if ($LASTEXITCODE -ne 0) {
        git remote add origin $repoUrl
    }
    git push -u origin main
}

Write-Host "Done. Open: https://github.com/$username"
