#!/bin/bash

DOTFILES_DIR="$HOME/github/dotfiles"
BACKUP_DIR="$HOME/dev/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
PROCESS_ALL=false

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No color

# Parse args
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --all) PROCESS_ALL=true ;;
    *)
      echo -e "${RED}Unknown argument: $arg${NC}"
      exit 1
      ;;
  esac
done

mkdir -p "$BACKUP_DIR"

echo -e "${GREEN} Syncing dotfiles from $DOTFILES_DIR${NC}"
$DRY_RUN && echo -e "${YELLOW}[Dry Run] No changes will be made.${NC}"

# Determine which dirs to sync
if $PROCESS_ALL; then
  mapfile -t DIRS < <(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d)
else
  echo -e "${GREEN} Only syncing changed dotfiles based on Git status...${NC}"
  cd "$DOTFILES_DIR" || exit 1
  mapfile -t CHANGED < <(git status --porcelain | awk '{print $2}' | cut -d/ -f1 | sort -u)
  cd - > /dev/null
  DIRS=()
  for d in "${CHANGED[@]}"; do
    [ -d "$DOTFILES_DIR/$d" ] && DIRS+=("$DOTFILES_DIR/$d")
  done
fi

for dir in "${DIRS[@]}"; do
  config_name=$(basename "$dir")
  env_file="$dir/.env"

  if [ ! -f "$env_file" ]; then
    echo -e "${YELLOW}[SKIP] $config_name: no .env file found${NC}"
    continue
  fi

  unset MODE TARGETS
  source "$env_file"

  if [[ -z "$MODE" || -z "${TARGETS[*]}" ]]; then
    echo -e "${RED}[ERROR] $config_name: .env must define MODE and TARGETS array${NC}"
    continue
  fi

  echo -e "${GREEN}→ $config_name${NC}"
  echo -e "  Mode: $MODE"

  for mapping in "${TARGETS[@]}"; do
    IFS=":" read -r target rel_source <<< "$mapping"
    target="${target/#\~/$HOME}"
    source_path="$dir/$rel_source"

    if [ ! -e "$source_path" ]; then
      echo -e "${YELLOW}  [SKIP] Missing source: $source_path${NC}"
      continue
    fi

    echo -e "  🗂️  $rel_source → $target"

    if [ -e "$target" ]; then
      echo -e "${YELLOW}    Backup existing $target → $BACKUP_DIR${NC}"
      $DRY_RUN || mv "$target" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$target")"

    case "$MODE" in
      copy)
        echo -e "     Copying file"
        $DRY_RUN || cp -r "$source_path" "$target"
        ;;
      symlink)
        echo -e "     Symlinking file"
        $DRY_RUN || ln -sfn "$source_path" "$target"
        ;;
      *)
        echo -e "${RED}    [ERROR] Unknown mode '$MODE'${NC}"
        ;;
    esac
  done
done

# --- Run font installer ---
FONT_INSTALLER="$DOTFILES_DIR/fonts/install-fonts.sh"

if [[ -f "$FONT_INSTALLER" ]]; then
  echo -e "${GREEN}Running Nerd Font installer...${NC}"

  if $DRY_RUN; then
    echo -e "${YELLOW}[Dry Run] Would run: $FONT_INSTALLER${NC}"
  else
    bash "$FONT_INSTALLER"
    FONT_STATUS=$?

    if [[ $FONT_STATUS -ne 0 ]]; then
      echo -e "${RED}[ERROR] Font installer failed with exit code $FONT_STATUS${NC}"
    else
      echo -e "${GREEN}Fonts installed successfully.${NC}"
    fi
  fi
else
  echo -e "${YELLOW}Font installer not found at $FONT_INSTALLER – skipping.${NC}"
fi


echo -e "${GREEN} Dotfiles sync complete.${NC}"
$DRY_RUN && echo -e "${YELLOW} Dry run mode: no changes made.${NC}"

