#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
HOME_DIR="$HOME/.codex"
BACKUP_ROOT="$HOME_DIR/backups/repo-install-$TIMESTAMP"

section() {
  echo
  echo "== $1 =="
}

ensure_dir() {
  mkdir -p "$1"
}

backup_existing() {
  local path="$1"
  local backup_path="$2"

  if [[ -e "$path" || -L "$path" ]]; then
    mkdir -p "$(dirname "$backup_path")"
    mv "$path" "$backup_path"
    return 0
  fi

  return 1
}

link_item() {
  local source_path="$1"
  local dest_path="$2"
  mkdir -p "$(dirname "$dest_path")"
  ln -sfn "$source_path" "$dest_path"
}

sync_collection() {
  local source_dir="$1"
  local dest_dir="$2"
  local backup_root="$3"
  local mode="$4"
  local skip_name="${5:-}"

  mkdir -p "$dest_dir"

  if [[ "$mode" == "dirs" ]]; then
    for item in "$source_dir"/*; do
      [[ -d "$item" ]] || continue
      local name
      name="$(basename "$item")"
      [[ -n "$skip_name" && "$name" == "$skip_name" ]] && continue
      local dest_path="$dest_dir/$name"
      local backup_path="$backup_root/$name"
      backup_existing "$dest_path" "$backup_path" || true
      link_item "$item" "$dest_path"
    done
  else
    for item in "$source_dir"/*; do
      [[ -f "$item" ]] || continue
      local name
      name="$(basename "$item")"
      local dest_path="$dest_dir/$name"
      local backup_path="$backup_root/$name"
      backup_existing "$dest_path" "$backup_path" || true
      link_item "$item" "$dest_path"
    done
  fi
}

section "Installing Codex assets into $HOME_DIR"
ensure_dir "$HOME_DIR/skills"
ensure_dir "$HOME_DIR/agents"
ensure_dir "$HOME_DIR/rules"
ensure_dir "$HOME_DIR/commands"
ensure_dir "$BACKUP_ROOT"

sync_collection "$SCRIPT_DIR/skills" "$HOME_DIR/skills" "$BACKUP_ROOT/skills" dirs ".system"
sync_collection "$SCRIPT_DIR/agents" "$HOME_DIR/agents" "$BACKUP_ROOT/agents" files
sync_collection "$SCRIPT_DIR/rules" "$HOME_DIR/rules" "$BACKUP_ROOT/rules" files
sync_collection "$SCRIPT_DIR/commands" "$HOME_DIR/commands" "$BACKUP_ROOT/commands" files

if [[ -f "$SCRIPT_DIR/AGENTS.md" ]]; then
  backup_existing "$HOME_DIR/AGENTS.md" "$BACKUP_ROOT/AGENTS.md" || true
  link_item "$SCRIPT_DIR/AGENTS.md" "$HOME_DIR/AGENTS.md"
fi

section "Done"
echo "Backup root: $BACKUP_ROOT"
echo "Read GUIDE.md and MCP_QUICK_SETUP.md next."
