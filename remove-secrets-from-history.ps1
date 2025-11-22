# Remove secrets from git history using interactive rebase

Write-Host "=== Removing Secrets from Git History ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "This will rewrite git history to remove AWS credentials." -ForegroundColor Yellow
Write-Host "The credentials are in commits:" -ForegroundColor Yellow
Write-Host "  - bb4f96b (original commit with secrets)" -ForegroundColor Gray
Write-Host "  - daa66f2 (amended commit still has secrets)" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Continue? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit
}

Write-Host "`nStep 1: Starting interactive rebase..." -ForegroundColor Cyan
Write-Host "You'll need to edit the commits manually." -ForegroundColor Gray
Write-Host ""

# Check if we're on the right branch
$currentBranch = git branch --show-current
if ($currentBranch -ne "main") {
    Write-Host "⚠️  Warning: Not on main branch. Current: $currentBranch" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit
    }
}

Write-Host "`nStarting interactive rebase..." -ForegroundColor Green
Write-Host "In the editor that opens:" -ForegroundColor Yellow
Write-Host "1. Find commits bb4f96b and daa66f2" -ForegroundColor White
Write-Host "2. Change 'pick' to 'edit' for those commits" -ForegroundColor White
Write-Host "3. Save and close" -ForegroundColor White
Write-Host ""

# Start interactive rebase (go back 5 commits to be safe)
git rebase -i HEAD~5

Write-Host "`nAfter the rebase editor closes, run these commands:" -ForegroundColor Cyan
Write-Host "  git add TEMPORARY_CREDENTIALS.md" -ForegroundColor White
Write-Host "  git commit --amend --no-edit" -ForegroundColor White
Write-Host "  git rebase --continue" -ForegroundColor White
Write-Host "  (Repeat for each commit that had secrets)" -ForegroundColor Gray
Write-Host "  git push origin main --force" -ForegroundColor White

