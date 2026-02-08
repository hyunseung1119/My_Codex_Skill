# Installation Guide

Automated installation guide for My Claude Code Skills.

## 📋 Prerequisites

- Claude Code CLI installed
- Git installed
- Python 3.8+ (for Python-based skills)

## 🚀 Quick Install

### Windows (PowerShell)

```powershell
# Run this command in PowerShell
iwr -useb https://raw.githubusercontent.com/hyunseung1119/My_ClaudeCode_Skill/main/setup.ps1 | iex
```

Or manually:

```powershell
# Clone repository
git clone https://github.com/hyunseung1119/My_ClaudeCode_Skill.git

# Run setup script
cd My_ClaudeCode_Skill
.\setup.ps1
```

### Linux / macOS

```bash
# Run this command
curl -fsSL https://raw.githubusercontent.com/hyunseung1119/My_ClaudeCode_Skill/main/setup.sh | bash
```

Or manually:

```bash
# Clone repository
git clone https://github.com/hyunseung1119/My_ClaudeCode_Skill.git

# Run setup script
cd My_ClaudeCode_Skill
chmod +x setup.sh
./setup.sh
```

## 🔧 What the Setup Script Does

1. **Detects Claude Code installation**
   - Checks `~/.claude/skills` directory
   - Creates directory if not exists

2. **Creates symbolic links**
   - Links all skills to `~/.claude/skills/`
   - Links agents to `~/.claude/agents/`
   - Links rules to `~/.claude/rules/`

3. **Installs dependencies**
   - Checks Python dependencies (if applicable)
   - Installs required packages

4. **Verifies installation**
   - Tests skill availability
   - Shows installed skills list

## 📁 Directory Structure After Installation

```
~/.claude/
├── skills/
│   ├── product-planner -> /path/to/My_ClaudeCode_Skill/skills/product-planner
│   ├── chatbot-designer -> /path/to/My_ClaudeCode_Skill/skills/chatbot-designer
│   ├── llm-app-planner -> /path/to/My_ClaudeCode_Skill/skills/llm-app-planner
│   └── ... (all other skills)
├── agents/
│   ├── graphql-expert.md -> /path/to/My_ClaudeCode_Skill/agents/graphql-expert.md
│   ├── a11y-reviewer.md -> /path/to/My_ClaudeCode_Skill/agents/a11y-reviewer.md
│   └── ... (all other agents)
└── rules/
    ├── security.md -> /path/to/My_ClaudeCode_Skill/rules/security.md
    └── ... (all other rules)
```

## 🔄 Manual Installation

If you prefer manual installation:

### 1. Clone Repository

```bash
git clone https://github.com/hyunseung1119/My_ClaudeCode_Skill.git ~/My_ClaudeCode_Skill
```

### 2. Create Symbolic Links

**Windows (PowerShell as Administrator):**

```powershell
# Skills
Get-ChildItem "~/My_ClaudeCode_Skill/skills" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~/.claude/skills/$($_.Name)" -Target $_.FullName
}

# Agents
Get-ChildItem "~/My_ClaudeCode_Skill/agents" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~/.claude/agents/$($_.Name)" -Target $_.FullName
}

# Rules
Get-ChildItem "~/My_ClaudeCode_Skill/rules" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~/.claude/rules/$($_.Name)" -Target $_.FullName
}
```

**Linux / macOS:**

```bash
# Skills
ln -sf ~/My_ClaudeCode_Skill/skills/* ~/.claude/skills/

# Agents
ln -sf ~/My_ClaudeCode_Skill/agents/* ~/.claude/agents/

# Rules
ln -sf ~/My_ClaudeCode_Skill/rules/* ~/.claude/rules/
```

### 3. Install Python Dependencies (if needed)

```bash
# For product-planner
pip install -r ~/My_ClaudeCode_Skill/skills/product-planner/requirements.txt

# For llm-app-planner
pip install -r ~/My_ClaudeCode_Skill/skills/llm-app-planner/requirements.txt
```

## ✅ Verify Installation

```bash
# Check if skills are available
ls ~/.claude/skills/

# Test a skill
claude /product-planner --help
```

## 🔄 Update Skills

To get the latest updates:

```bash
# Navigate to repository
cd ~/My_ClaudeCode_Skill

# Pull latest changes
git pull origin main

# Skills will auto-update (because of symlinks!)
```

## 🗑️ Uninstall

**Windows:**

```powershell
.\uninstall.ps1
```

**Linux / macOS:**

```bash
./uninstall.sh
```

Or manually remove symlinks:

```bash
# Remove all symlinks
find ~/.claude/skills -type l -delete
find ~/.claude/agents -type l -delete
find ~/.claude/rules -type l -delete
```

## 🌐 Global Installation for Teams

### Option 1: Shared Network Drive

1. Clone repository to shared network drive
2. Team members create symlinks to shared location
3. Updates automatically available to all team members

```bash
# Example: Shared drive at \\server\claude-skills
ln -sf \\server\claude-skills\skills\* ~/.claude/skills/
```

### Option 2: Internal Git Server

1. Fork to internal Git server (GitLab, Bitbucket)
2. Team members clone from internal server
3. Use setup script for installation

### Option 3: Package Manager (Advanced)

Create internal package:

```bash
# Create tar archive
cd My_ClaudeCode_Skill
tar -czf claude-skills-v1.0.0.tar.gz skills/ agents/ rules/

# Distribute via internal package manager
# npm, pip, or custom solution
```

## 🔐 Security Considerations

### Symlinks vs Copies

**Symlinks (Recommended):**
- ✅ Auto-updates when repository updates
- ✅ Single source of truth
- ✅ Saves disk space
- ⚠️ Requires repository to stay in place

**Copies:**
- ✅ Independent of repository
- ✅ Works if repository is deleted
- ❌ Manual updates required
- ❌ More disk space

### Permission Issues

If you encounter permission errors:

**Windows:**
- Run PowerShell as Administrator
- Enable Developer Mode (Settings → Update & Security → For Developers)

**Linux / macOS:**
- Ensure write permissions: `chmod -R u+w ~/.claude`
- Check symlink permissions: `ls -la ~/.claude/skills`

## 🐛 Troubleshooting

### Symlinks not working

**Windows:**
- Enable Developer Mode or run as Administrator
- Use `mklink` instead of PowerShell `New-Item`:
  ```cmd
  mklink /D "C:\Users\YourName\.claude\skills\product-planner" "C:\path\to\My_ClaudeCode_Skill\skills\product-planner"
  ```

**Linux / macOS:**
- Check symlink creation: `ls -la ~/.claude/skills/`
- Verify target exists: `readlink ~/.claude/skills/product-planner`

### Skills not appearing in Claude Code

1. Restart Claude Code CLI
2. Check symlinks are valid: `ls -la ~/.claude/skills/`
3. Verify SKILL.md files exist in each skill directory
4. Check Claude Code configuration: `cat ~/.claude/settings.json`

### Python dependencies not found

```bash
# Create virtual environment
python -m venv ~/.claude/venv

# Activate and install
source ~/.claude/venv/bin/activate  # Linux/macOS
~/.claude/venv/Scripts/activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

## 📞 Support

Issues? Contact:
- GitHub Issues: https://github.com/hyunseung1119/My_ClaudeCode_Skill/issues
- Team Slack: #claude-code-skills

## 📚 Related Documentation

- [README.md](README.md) - Overview and features
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - How to use skills
- [UPDATE.md](UPDATE.md) - Update procedures
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
