# Quick Fix: Remove Secrets from Git History

## The Problem

GitHub is blocking your push because AWS credentials are in git history (commits `bb4f96b` and `daa66f2`).

## Quick Solution: Interactive Rebase

### Step 1: Start Interactive Rebase

```powershell
git rebase -i HEAD~5
```

### Step 2: In the Editor

Find these commits and change `pick` to `edit`:
- `bb4f96b` - Initial commit with secrets
- `daa66f2` - Amended commit with secrets

Save and close the editor.

### Step 3: For Each Commit Being Edited

Git will stop at each commit. For each one:

```powershell
# The file already has credentials removed, just amend
git add TEMPORARY_CREDENTIALS.md
git commit --amend --no-edit
git rebase --continue
```

### Step 4: Force Push

```powershell
git push origin main --force
```

## Alternative: Use BFG Repo-Cleaner

1. Download: https://rtyley.github.io/bfg-repo-cleaner/
2. Create `credentials.txt`:
   ```
   ASIAQYFOGF762ITZGQZA==>REMOVED
   pKMp1dkqLwXa1+bznYyi42FoWyFDM1NkI7Y6YIAo==>REMOVED
   ```
3. Run:
   ```powershell
   java -jar bfg.jar --replace-text credentials.txt
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push origin main --force
   ```

## Simplest: Delete File from History

If you just want to remove the file entirely:

```powershell
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch TEMPORARY_CREDENTIALS.md" --prune-empty --tag-name-filter cat -- --all
git push origin main --force
```

## After Fixing

The credentials are temporary and will expire anyway, but it's good practice to remove them from history.

