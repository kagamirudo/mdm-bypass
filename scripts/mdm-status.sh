#!/usr/bin/env bash
#
# mdm-status.sh — read-only MDM / enrollment inspector for macOS.
#
# Collects everything you need to identify how a Mac is enrolled so you can
# pick the right (supported) removal path. It makes NO changes to the system.
#
# Some checks are more complete with admin rights; the script runs fine without
# and will note where `sudo` would add detail.
#
# Usage: ./scripts/mdm-status.sh
#
set -euo pipefail

hr() { printf '%s\n' "----------------------------------------------------------------"; }
section() { hr; printf '## %s\n' "$1"; hr; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only (uname reports: $(uname))." >&2
  exit 1
fi

section "System"
sw_vers 2>/dev/null || true
echo
system_profiler SPHardwareDataType 2>/dev/null \
  | grep -E "Model Name|Model Identifier|Chip|Serial Number|Activation Lock" \
  || true

section "Enrollment status"
# Does not require sudo; the single most important output.
if command -v profiles >/dev/null 2>&1; then
  profiles status -type enrollment 2>/dev/null || echo "(profiles status unavailable)"
else
  echo "(the 'profiles' tool is not available on this macOS version)"
fi

section "Installed configuration profiles"
if [[ "$(id -u)" -eq 0 ]]; then
  profiles list 2>/dev/null || echo "(none / unavailable)"
else
  echo "Run with sudo for the full list. User-visible profiles:"
  profiles -P 2>/dev/null || profiles list 2>/dev/null \
    || echo "(need sudo: 'sudo ./scripts/mdm-status.sh')"
fi

section "Supervision"
sup="$(sudo -n profiles show -type enrollment 2>/dev/null | grep -i supervis || true)"
if [[ -n "$sup" ]]; then
  echo "$sup"
else
  echo "(not detected without sudo, or device is not supervised — run with sudo to confirm)"
fi

section "Interpretation"
cat <<'EOF'
Look at "Enrollment status" above:

  * Enrolled via DEP: Yes
        -> Automated Device Enrollment (ADE/DEP). Managed at the source
           (Apple Business/School Manager). A local wipe will NOT remove it.
           See docs/supported-removal.md -> "Device Enrollment (ADE / DEP)".

  * Enrolled via DEP: No, MDM enrollment: Yes
        -> User/manual enrollment. Removable locally.
           See docs/supported-removal.md -> "User/manual enrollment".

  * MDM enrollment: No
        -> Not managed. Nothing to remove.

Only remove MDM from a device you own or are authorized to administer.
See docs/legal-and-ethics.md.
EOF
hr
