#!/bin/bash
# Claude Code Skills - Uninstall Script (Linux/macOS)

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}  Claude Code Skills - Uninstall${NC}"
echo -e "${CYAN}==================================================${NC}"
echo ""

CLAUDE_DIR="$HOME/.claude"

echo -e "${YELLOW}WARNING: This will remove all symlinks to skills, agents, and rules.${NC}"
echo -e "${YELLOW}The original repository files will NOT be deleted.${NC}"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}Removing symlinks...${NC}"

removed_count=0

# Remove skill symlinks
find "$CLAUDE_DIR/skills" -type l | while read link; do
    rm "$link"
    echo -e "  ${GREEN}✓${NC} Removed skill: $(basename "$link")"
    ((removed_count++))
done

# Remove agent symlinks
find "$CLAUDE_DIR/agents" -type l | while read link; do
    rm "$link"
    echo -e "  ${GREEN}✓${NC} Removed agent: $(basename "$link")"
    ((removed_count++))
done

# Remove rule symlinks
find "$CLAUDE_DIR/rules" -type l | while read link; do
    rm "$link"
    echo -e "  ${GREEN}✓${NC} Removed rule: $(basename "$link")"
    ((removed_count++))
done

echo ""
echo -e "${CYAN}==================================================${NC}"
echo -e "${GREEN}Uninstall Complete!${NC}"
echo -e "${CYAN}==================================================${NC}"
echo ""
echo -e "${BLUE}To reinstall, run: ./setup.sh${NC}"
