#!/bin/bash
# shellcheck disable=SC1090

set -euxo pipefail

SHELL_NAME=$(basename "$SHELL")

export PATH="$HOME/.local/share/mise/shims:$PATH"
export MISE_ENV="dev"

echo "[ * ] running mise installer..."
curl -fsSL https://mise.run | sh

case "$SHELL_NAME" in
  bash) SHELL_RC="$HOME/.bashrc" ;;
  zsh) SHELL_RC="$HOME/.zshrc" ;;
  *)
    echo "[ - ] Unsupported shell: $SHELL_NAME. Supported shells are bash and zsh"
    exit 1
    ;;
esac

if [ -n "$SHELL_RC" ]; then
  echo "eval \"\$(mise activate $SHELL_NAME)\"" >> "$SHELL_RC"
  . "$SHELL_RC"
fi

mise trust
mise activate --shims
mise doctor
mise install
mise run install
mise run hygiene
