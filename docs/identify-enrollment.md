# Identifying your enrollment type

Before removing anything, find out **how** the Mac is enrolled. The removal
path depends entirely on this. All commands here are read-only.

## 1. Is there an MDM profile installed?

**System Settings → General → Device Management** (older macOS:
**System Preferences → Profiles**). If there's no "Device Management" pane at
all, the Mac is not currently managed by a local profile.

From the terminal:

```sh
# Lists installed configuration profiles (needs admin for full output)
sudo profiles list

# Shows enrollment + whether it came from DEP/ADE
profiles status -type enrollment
```

Interpreting `profiles status -type enrollment`:

| Output | Meaning |
|--------|---------|
| `Enrolled via DEP: No` + `MDM enrollment: No` | Not managed. Nothing to remove. |
| `Enrolled via DEP: No` + `MDM enrollment: Yes (User Approved)` | **Manual/user enrollment.** Removable locally — see supported-removal.md. |
| `Enrolled via DEP: Yes` | **Automated Device Enrollment (ADE/DEP).** Tied to an Apple Business/School Manager record. Must be released at the source. |

## 2. Is it supervised?

```sh
# "IsSupervised" appears in the enrollment profile details
sudo profiles show -type enrollment 2>/dev/null | grep -i supervis
```

Supervision almost always means ADE. Supervised + DEP = the device will
re-enroll after an erase unless the ABM/ASM record is removed.

## 3. Check Activation Lock / Find My context

```sh
# Shows Activation Lock status (relevant on Apple silicon / T2)
system_profiler SPHardwareDataType | grep -i "Activation Lock"
```

## 4. Note the serial number (you'll need it for the source removal)

```sh
system_profiler SPHardwareDataType | awk -F': ' '/Serial Number/{print $2}'
```

## Decision tree

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "wrappingWidth": 500}}}%%
flowchart TD
    Start["Run: profiles status -type enrollment"]
    Q1{"Enrolled via DEP: Yes?"}
    Q2{"MDM enrollment: Yes?"}
    ADE["<b>ADE / DEP</b><br/>Local removal won't stick across a wipe.<br/>Get the serial released from ABM/ASM<br/>(seller, or Apple with proof of purchase).<br/>→ supported-removal.md · escalation-playbook.md"]
    User["<b>User / manual enrollment</b><br/>Remove the profile locally.<br/>→ supported-removal.md"]
    Clean["<b>Already unmanaged</b> — nothing to do ✅"]

    Start --> Q1
    Q1 -->|Yes| ADE
    Q1 -->|No| Q2
    Q2 -->|Yes| User
    Q2 -->|No| Clean

    classDef hard fill:#fde0e0,stroke:#c62828,color:#000;
    classDef easy fill:#fff6d1,stroke:#f9a825,color:#000;
    classDef done fill:#d1f0d1,stroke:#2e7d32,color:#000;
    class ADE hard;
    class User easy;
    class Clean done;
```

Run [`../scripts/mdm-status.sh`](../scripts/mdm-status.sh) to collect all of
the above in one go.
