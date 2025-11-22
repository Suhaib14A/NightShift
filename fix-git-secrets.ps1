# Fix Git Secrets Issue
# This script helps remove secrets from git history

Write-Host "=== Fixing Git Secrets Issue ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "The credentials are still in git history from commit bb4f96b" -ForegroundColor Yellow
Write-Host ""

Write-Host "Option 1: Interactive Rebase (Recommended)" -ForegroundColor Cyan
Write-Host "This will let you edit the commit that contains secrets:" -ForegroundColor Gray
Write-Host ""
Write-Host "  git rebase -i HEAD~2" -ForegroundColor White
Write-Host "  # Change 'pick' to 'edit' for the commit with secrets" -ForegroundColor Gray
Write-Host "  # Remove credentials from TEMPORARY_CREDENTIALS.md" -ForegroundColor Gray
Write-Host "  git add TEMPORARY_CREDENTIALS.md" -ForegroundColor Gray
Write-Host "  git commit --amend --no-edit" -ForegroundColor Gray
Write-Host "  git rebase --continue" -ForegroundColor Gray
Write-Host "  git push origin main --force" -ForegroundColor Gray
Write-Host ""

Write-Host "Option 2: Use BFG Repo-Cleaner (Easier)" -ForegroundColor Cyan
Write-Host "Download from: https://rtyley.github.io/bfg-repo-cleaner/" -ForegroundColor Gray
Write-Host ""
Write-Host "  java -jar bfg.jar --replace-text passwords.txt" -ForegroundColor White
Write-Host "  git reflog expire --expire=now --all" -ForegroundColor Gray
Write-Host "  git gc --prune=now --aggressive" -ForegroundColor Gray
Write-Host "  git push origin main --force" -ForegroundColor Gray
Write-Host ""

Write-Host "Option 3: If Private Repo Only - Force Push" -ForegroundColor Cyan
Write-Host "⚠️  WARNING: Only if private repo and you're the only user!" -ForegroundColor Red
Write-Host ""
Write-Host "  git push origin main --force" -ForegroundColor White
Write-Host ""

Write-Host "Current status:" -ForegroundColor Yellow
git log --oneline -3

