#!/bin/bash

# Force Push Script for Clean Git History
# This script force pushes the rewritten git history to remove sensitive data
#
# WARNING: This will permanently rewrite the remote repository history!
# - Anyone who has cloned the repo will need to re-clone it
# - All open PRs based on old history will need to be recreated
# - This action cannot be undone

echo "========================================="
echo "Git History Force Push Script"
echo "========================================="
echo ""
echo "This will force push the cleaned git history to the remote repository."
echo "The following sensitive data has been removed from all commits:"
echo "  - Registration Number: 12508573"
echo "  - Roll Number: 6"
echo "  - Course Code: CAB105"
echo "  - Course Name: Data Visualization Fundamentals"
echo "  - Section: D2515"
echo "  - Personal filename containing sensitive details"
echo ""
echo "Current clean commit history (3 commits):"
git log --oneline HEAD
echo ""
echo "========================================="
echo "WARNING: This is a destructive operation!"
echo "========================================="
echo ""
read -p "Are you sure you want to continue? (type 'YES' to confirm): " confirmation

if [ "$confirmation" != "YES" ]; then
    echo "Operation cancelled."
    exit 1
fi

echo ""
echo "Verifying no sensitive data in current branch..."

# Verify no sensitive data
if git log -p HEAD -S "12508573" -- EV_Population_Analysis.ipynb README.md | grep -q "12508573"; then
    echo "ERROR: Sensitive data still found in project files!"
    exit 1
fi

echo "✓ Verification passed - no sensitive data in project files"
echo ""
echo "Force pushing to origin/copilot/remove-sensitive-data-history..."

# Force push with lease (safer than --force)
git push --force-with-lease origin copilot/remove-sensitive-data-history

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "SUCCESS: Clean history pushed!"
    echo "========================================="
    echo ""
    echo "Next steps:"
    echo "1. Verify the remote history is clean on GitHub"
    echo "2. Notify all collaborators to:"
    echo "   - Back up any local changes"
    echo "   - Delete their local repository"
    echo "   - Clone fresh from GitHub"
    echo "3. If this was the main branch, consider:"
    echo "   - Updating any deployment pipelines"
    echo "   - Recreating any open PRs"
    echo ""
else
    echo ""
    echo "ERROR: Force push failed!"
    echo "This may require manual intervention or different authentication."
    exit 1
fi
