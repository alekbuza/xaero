#!/bin/bash
# shellcheck disable=SC1090

set -euxo pipefail

SHELL_NAME=$(basename "$SHELL")

export PATH="$HOME/.local/share/mise/shims:$PATH"
export MISE_ENV="dev"
export MISE_VERBOSE=1
export MISE_COLOR=false

echo "[ * ] running mise installer..."
curl -fsSL https://mise.run | sh

case "$SHELL_NAME" in
  bash)
    SHELL_RC="$HOME/.bash_profile"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate bash)\"" >> "$(realpath ~)/.bashrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate --shims)\"" >> "$(realpath ~)/.bash_profile"
    . "$SHELL_RC"
    ;;
  zsh)
    SHELL_RC="$HOME/.zprofile"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate zsh)\"" >> "$(realpath ~)/.zshrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate --shims)\"" >> "$(realpath ~)/.zprofile"
    . "$SHELL_RC"
    ;;
  *)
    echo "[ - ] Unsupported shell: $SHELL_NAME. Supported shells are bash and zsh"
    exit 1
    ;;
esac

mise trust
mise doctor
mise -E mise install --quiet
mise install --quiet
mise run install
mise run hygiene
