#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# install.sh — Deploy dotagent skills and commands to target agents
#
# Usage:
#   ./install.sh [--agent=hermes|opencode|pi|codex|all] [--category=CAT] [--skills=skill1,skill2]
#   ./install.sh --list-agents
#   ./install.sh --list-categories
#   ./install.sh --list-skills

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

usage() {
    cat <<'EOF'
usage: install.sh [options]

Options:
  --agent=NAME       Target agent: hermes, opencode, pi, codex, all (default: all)
  --category=CAT     Filter skills by category (default: all)
  --skills=LIST      Comma-separated skill names (default: all in category)
  --dry-run          Show what would be done without copying
  --list-agents      List supported agents and exit
  --list-categories  List available skill categories and exit
  --list-skills      List all skills with categories and exit
  -h, --help         Show this help

Examples:
  ./install.sh                           # Install all skills to all agents
  ./install.sh --agent=hermes            # Install all skills to Hermes only
  ./install.sh --category=software-development --agent=opencode
  ./install.sh --skills=python-style-guide,css-style-guide --agent=hermes
  ./install.sh --dry-run --agent=all     # Preview what would be installed
EOF
}

# -- parse args
agent="all"
category=""
skills_csv=""
dry_run=false

while [ $# -gt 0 ]; do
    case "$1" in
        --agent=*)       agent="${1#--agent=}" ;;
        --category=*)    category="${1#--category=}" ;;
        --skills=*)      skills_csv="${1#--skills=}" ;;
        --dry-run)       dry_run=true ;;
        --list-agents)   list_agents=true ;;
        --list-categories) list_categories=true ;;
        --list-skills)   list_skills=true ;;
        -h|--help)       usage; exit 0 ;;
        *)               die "unknown option: $1" ;;
    esac
    shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
SKILLS_DIR="$REPO_ROOT/skills"
CMDS_DIR="$REPO_ROOT/cmds"
BUILD_CMD="$REPO_ROOT/tools/build-cmd"

# -- agent configurations (global config paths)
declare -A AGENT_SKILLS_DIR
AGENT_SKILLS_DIR[hermes]="$HOME/.hermes/skills"
AGENT_SKILLS_DIR[opencode]="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"
AGENT_SKILLS_DIR[pi]="$HOME/.pi/skills"
AGENT_SKILLS_DIR[codex]="$HOME/.codex/skills"

declare -A AGENT_CMDS_DIR
AGENT_CMDS_DIR[hermes]="$HOME/.hermes/plugins"
AGENT_CMDS_DIR[opencode]="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/commands"
AGENT_CMDS_DIR[pi]="$HOME/.pi/commands"
AGENT_CMDS_DIR[codex]="$HOME/.codex/commands"

SUPPORTED_AGENTS=(hermes opencode pi codex)

# -- helpers
log_info() { printf '\033[36m[INFO]\033[0m %s\n' "$*"; }
log_ok()   { printf '\033[32m[OK]\033[0m %s\n' "$*"; }
log_warn() { printf '\033[33m[WARN]\033[0m %s\n' "$*"; }
log_err()  { printf '\033[31m[ERR]\033[0m %s\n' "$*"; }

run_cmd() {
    if [ "$dry_run" = true ]; then
        printf '[DRY-RUN] %s\n' "$*"
    else
        eval "$*"
    fi
}

# Export REPO_ROOT for Python subprocesses
export REPO_ROOT

# -- list commands
if [ "${list_agents:-false}" = true ]; then
    printf 'Supported agents:\n'
    for a in "${SUPPORTED_AGENTS[@]}"; do
        printf '  %s\n' "$a"
    done
    exit 0
fi

if [ "${list_categories:-false}" = true ]; then
    printf 'Available categories:\n'
    python3 -c "
import json, os
with open(os.path.join(os.environ['REPO_ROOT'], 'skills_list.json')) as f:
    data = json.load(f)
cats = sorted(set(s['category'] for s in data['skills']))
for c in cats:
    print(f'  {c}')
"
    exit 0
fi

if [ "${list_skills:-false}" = true ]; then
    printf 'Available skills:\n'
    python3 -c "
import json, os
with open(os.path.join(os.environ['REPO_ROOT'], 'skills_list.json')) as f:
    data = json.load(f)
for s in data['skills']:
    print(f'  {s[\"name\"]:30s} [{s[\"category\"]}] {s[\"description\"]}')
"
    exit 0
fi

# -- validate agent
valid_agent=false
for a in "${SUPPORTED_AGENTS[@]}"; do
    [ "$a" = "$agent" ] && valid_agent=true
done
[ "$agent" = "all" ] && valid_agent=true
[ "$valid_agent" = true ] || die "invalid agent: $agent (use --list-agents)"

# -- determine target agents
if [ "$agent" = "all" ]; then
    target_agents=("${SUPPORTED_AGENTS[@]}")
else
    target_agents=("$agent")
fi

# -- collect skills to install
mapfile -t skill_names < <(
    python3 -c "
import json, sys
with open('$REPO_ROOT/skills_list.json') as f:
    data = json.load(f)
for s in data['skills']:
    cat_match = '$category' == '' or s['category'] == '$category'
    skills_match = '$skills_csv' == '' or s['name'] in '$skills_csv'.split(',')
    if cat_match and skills_match:
        print(s['name'])
"
)

[ ${#skill_names[@]} -gt 0 ] || die "no skills matched (check --category/--skills)"

# -- install skills
log_info "Installing ${#skill_names[@]} skill(s) to ${target_agents[*]}"

for skill_name in "${skill_names[@]}"; do
    skill_src="$SKILLS_DIR/$skill_name"
    [ -d "$skill_src" ] || { log_warn "skill not found: $skill_name"; continue; }

    for target in "${target_agents[@]}"; do
        dest_base="${AGENT_SKILLS_DIR[$target]}"
        [ -n "$dest_base" ] || { log_warn "unknown agent: $target"; continue; }

        dest_dir="$dest_base/${skill_name##*/}"
        if [ "$dry_run" = true ]; then
            log_info "[DRY-RUN] would copy $skill_src -> $dest_dir"
        else
            mkdir -p "$dest_base"
            rm -rf "$dest_dir"
            cp -r "$skill_src" "$dest_dir"
            log_ok "installed $skill_name -> $target"
        fi
    done
done

# -- install commands (build for each agent)
log_info "Building commands for ${target_agents[*]}"
for cmd_json in "$CMDS_DIR"/*.json; do
    [ -f "$cmd_json" ] || continue
    cmd_name=$(basename "$cmd_json" .json)

    for target in "${target_agents[@]}"; do
        if [ "$dry_run" = true ]; then
            log_info "[DRY-RUN] would run: $BUILD_CMD $cmd_json --$target"
        else
            "$BUILD_CMD" "$cmd_json" --"$target" 2>/dev/null || log_warn "build-cmd failed for $cmd_name -> $target"
            log_ok "built $cmd_name -> $target"
        fi
    done
done

log_info "Done"