# Update Guide

How to keep your Claude Code skills up-to-date.

## 🔄 Automatic Updates (Recommended)

Because skills are installed as **symbolic links**, updates are automatic!

### How It Works

```
Your Skills (Symlinks)          Repository (Source)
~/.claude/skills/              ~/My_ClaudeCode_Skill/skills/
├── product-planner ──────────> └── product-planner/
├── chatbot-designer ──────────> └── chatbot-designer/
└── llm-app-planner ───────────> └── llm-app-planner/
```

When you update the repository, all symlinked skills update instantly!

### Update Steps

```bash
# Navigate to repository
cd ~/My_ClaudeCode_Skill

# Pull latest changes
git pull origin main

# That's it! Skills are now updated
```

## 📅 Update Schedule Recommendations

### For Teams

**Daily Updates (CI/CD environments):**
```bash
# Add to cron (Linux/macOS)
0 9 * * * cd ~/My_ClaudeCode_Skill && git pull origin main

# Or Windows Task Scheduler
# Action: git pull origin main
# Trigger: Daily at 9:00 AM
```

**Weekly Updates (Development):**
- Every Monday morning
- Review changelog before pulling

**Monthly Updates (Stable production):**
- First day of month
- Test in staging first

### For Individual Users

**Check for updates when:**
- New features announced
- Bug fixes released
- Starting new projects
- Before important work

## 🔍 Check for Updates

```bash
# Navigate to repository
cd ~/My_ClaudeCode_Skill

# Check if updates available
git fetch origin main
git status

# See what changed
git log HEAD..origin/main --oneline

# See detailed changes
git diff HEAD..origin/main
```

## 📥 Update Process

### Standard Update

```bash
cd ~/My_ClaudeCode_Skill
git pull origin main
```

### Update with Verification

```bash
cd ~/My_ClaudeCode_Skill

# 1. Backup current state (optional)
git stash

# 2. Fetch updates
git fetch origin main

# 3. Review changes
git log HEAD..origin/main
git diff HEAD..origin/main

# 4. Pull updates
git pull origin main

# 5. Verify installation
ls -la ~/.claude/skills/
ls -la ~/.claude/agents/
ls -la ~/.claude/rules/

# 6. Test a skill
/product-planner --help
```

### Update Specific Skill Only

```bash
# Navigate to repository
cd ~/My_ClaudeCode_Skill

# Pull only specific files
git pull origin main -- skills/product-planner/

# Or checkout specific file
git checkout origin/main -- skills/product-planner/SKILL.md
```

## 🔄 Rollback to Previous Version

If an update causes issues:

```bash
cd ~/My_ClaudeCode_Skill

# View commit history
git log --oneline

# Rollback to previous commit
git reset --hard <commit-hash>

# Or rollback 1 commit
git reset --hard HEAD~1

# Or rollback specific file
git checkout HEAD~1 -- skills/product-planner/SKILL.md
```

## 🆕 What Gets Updated

### Always Updated (Symlinks)
- ✅ Skills (all files)
- ✅ Agents (all files)
- ✅ Rules (all files)
- ✅ Documentation (README, guides)
- ✅ Scripts (setup.sh, setup.ps1)

### Never Updated (Local)
- ❌ Your local configurations (~/.claude/settings.json)
- ❌ Your custom skills (if not in repository)
- ❌ Your workspace files

## 📋 Update Checklist

Before updating:
- [ ] Review changelog or release notes
- [ ] Backup important local modifications
- [ ] Close Claude Code CLI
- [ ] Ensure no unsaved work

After updating:
- [ ] Verify symlinks: `ls -la ~/.claude/skills/`
- [ ] Check Python dependencies (if changed)
- [ ] Restart Claude Code CLI
- [ ] Test updated skills
- [ ] Review breaking changes (if any)

## 🔔 Stay Informed

### GitHub Watch

1. Go to https://github.com/hyunseung1119/My_ClaudeCode_Skill
2. Click **Watch** → **Custom**
3. Select:
   - ✅ Releases
   - ✅ Discussions (optional)
   - ✅ Issues (optional)

### Release Notifications

```bash
# Subscribe to releases (GitHub CLI)
gh repo set-default hyunseung1119/My_ClaudeCode_Skill
gh release list --watch
```

### Team Announcements

- Slack channel: #claude-code-updates
- Email list: claude-skills@yourcompany.com
- Weekly team sync

## 🐛 Update Troubleshooting

### "Your local changes would be overwritten"

```bash
# Option 1: Stash changes
git stash
git pull origin main
git stash pop

# Option 2: Commit local changes
git add .
git commit -m "Local modifications"
git pull origin main
```

### Merge Conflicts

```bash
# Pull with rebase
git pull --rebase origin main

# Resolve conflicts manually
# Edit conflicting files, then:
git add <resolved-file>
git rebase --continue
```

### Broken Symlinks After Update

```bash
# Re-run setup script
cd ~/My_ClaudeCode_Skill
./setup.sh  # Linux/macOS
.\setup.ps1 # Windows
```

### Dependencies Changed

```bash
# Reinstall Python dependencies
cd ~/.claude/skills/product-planner
pip install -r requirements.txt --upgrade

cd ~/.claude/skills/llm-app-planner
pip install -r requirements.txt --upgrade
```

## 🔐 Security Updates

Critical security updates are tagged with `[SECURITY]`.

**Immediate action required:**
```bash
# 1. Check for security updates
git fetch origin main
git log HEAD..origin/main | grep SECURITY

# 2. Pull immediately
git pull origin main

# 3. Restart Claude Code
# 4. Notify team
```

## 📊 Update History

View update history:

```bash
# All updates
git log --oneline

# Updates this month
git log --since="1 month ago" --oneline

# Updates by author
git log --author="hyunseung1119" --oneline

# Specific skill updates
git log --oneline -- skills/product-planner/
```

## 🌐 Multi-Machine Setup

If you use multiple computers:

### Machine 1
```bash
cd ~/My_ClaudeCode_Skill
git pull origin main
```

### Machine 2
```bash
cd ~/My_ClaudeCode_Skill
git pull origin main
# Same repository, same updates!
```

### Cloud Sync (Alternative)

Use Dropbox/Google Drive to sync repository:

```bash
# Clone to synced folder
git clone https://github.com/hyunseung1119/My_ClaudeCode_Skill.git ~/Dropbox/My_ClaudeCode_Skill

# Create symlinks from synced location
ln -sf ~/Dropbox/My_ClaudeCode_Skill/skills/* ~/.claude/skills/
```

⚠️ **Warning:** Avoid syncing `.git` directory across machines to prevent conflicts.

## 🚀 Advanced: Auto-Update Script

Create auto-update script:

**Linux/macOS (`~/.claude/auto-update.sh`):**
```bash
#!/bin/bash
cd ~/My_ClaudeCode_Skill
git pull origin main > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "$(date): Skills updated successfully" >> ~/.claude/update.log
else
    echo "$(date): Update failed" >> ~/.claude/update.log
fi
```

**Add to crontab:**
```bash
0 9 * * * ~/.claude/auto-update.sh
```

**Windows (PowerShell):**
```powershell
# auto-update.ps1
cd ~/My_ClaudeCode_Skill
git pull origin main
Add-Content -Path ~/.claude/update.log -Value "$(Get-Date): Updated"
```

**Add to Task Scheduler:**
- Trigger: Daily at 9:00 AM
- Action: PowerShell -File ~/.claude/auto-update.ps1

## 📞 Support

Update issues? Contact:
- GitHub Issues: https://github.com/hyunseung1119/My_ClaudeCode_Skill/issues
- Team Slack: #claude-code-skills

## 📚 Related Documentation

- [INSTALLATION.md](INSTALLATION.md) - Initial setup
- [README.md](README.md) - Overview
- [CHANGELOG.md](CHANGELOG.md) - Version history
