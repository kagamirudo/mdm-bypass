# Does the IT department see what you do on a managed Mac?

Short answer: **the MDM protocol itself sees much less than most people fear —
but it is a floor, not a ceiling.** On a company-owned Mac, IT runs management
tooling as **root** and can install additional agents that see almost
everything. So the real answer is: *"the protocol sees a limited, defined set of
things — but whether more is being watched depends entirely on what software
your admin chose to install on top of it."*

This matters for this repo in two ways:

1. If it's **your own device**, understanding this tells you what a leftover
   enrollment was ever able to report (usually: not your personal content).
2. If it's an **organization's device**, this is exactly why you should
   **assume you are not private on it** and go through IT rather than trying to
   work around management. See [`legal-and-ethics.md`](legal-and-ethics.md).

---

## Two different layers (don't conflate them)

```
   ┌─────────────────────────────────────────────────────────┐
   │  Layer 1 — the MDM protocol (Apple's built-in framework) │
   │  Standardized, limited, and documented by Apple.         │
   └─────────────────────────────────────────────────────────┘
                              │  the admin can use the protocol to install…
                              ▼
   ┌─────────────────────────────────────────────────────────┐
   │  Layer 2 — agents/scripts the admin pushes (run as root) │
   │  Jamf binary, monitoring tools, EDR, scripts. Few limits.│
   └─────────────────────────────────────────────────────────┘
```

Almost every "can they see X?" argument online is really an argument about
*which layer* someone means. Keep them separate and it's clear.

---

## Layer 1 — what the MDM protocol itself can and can't see

The native MDM framework is an **asset-management and policy** protocol, not a
surveillance one. By design it **can**:

- Read **device inventory**: serial, model, OS version, storage, battery, UDID.
- See the **list of installed apps** (managed and unmanaged) and configuration
  profiles.
- Report **security posture**: FileVault encryption on/off, firewall, Gatekeeper,
  passcode compliance, whether the OS is up to date.
- Push and remove **profiles, apps, restrictions, Wi-Fi/VPN/cert configs**.
- Issue **commands**: lock the device, remote-wipe it, clear the passcode,
  enforce updates, query location *if* that specific feature is enabled.

By design the protocol **cannot**:

- Read your **browsing history**.
- See the **contents of your personal files, photos, email, Messages/iMessages**.
- **Log your keystrokes** or capture your screen.
- See **what you type** or the content of what you do in apps.

So the raw MDM protocol knows roughly *what the machine is and whether it's
compliant* — not *what you're doing on it*.

---

## Layer 2 — why "but they could still see everything" is true anyway

Here's the catch that makes blanket reassurances dishonest. On macOS, MDM
management tooling (e.g. the **Jamf binary**) runs as the **root user**. Root
can read any file and run any program. The admin can use the MDM channel to
silently install:

- **Monitoring/DLP agents** (e.g. Teramind-class tools) that *can* record the
  screen, log keystrokes, track web pages, file transfers, printing, and
  network activity.
- **EDR / security agents** that inspect processes, network connections, and
  files.
- **Arbitrary scripts** that read any file on disk and report back.

None of that is part of the MDM *protocol* — but the protocol is what lets them
put it there. So:

> On a fully-managed, company-owned Mac, the honest assumption is that **IT
> *can* see essentially anything if they chose to deploy the tooling for it.**
> Whether they actually are is a question of policy and what's installed — not
> of technical impossibility.

You can look for installed management/monitoring software, but a determined
admin can hide it, and checking isn't a guarantee. The safe mental model on an
org device is simply: **it's not yours and it's not private.**

---

## The big exception: User Enrollment (BYOD) is privacy-walled

If the Mac was added via **User Enrollment** (the BYOD "bring your own device"
mode) rather than full/supervised Device Enrollment, Apple deliberately walls
off your personal life. In that mode the MDM server **cannot** access:

- personal photos, iMessages, personal email, browsing history;
- the list of your **personal** apps;
- your personal iCloud Drive data (kept cryptographically separate from the
  managed volume).

User Enrollment only manages the *work* account/apps/data. This is the mode
designed for personally-owned devices, and it's the one you'd *want* if you ever
voluntarily enrolled your own Mac in an employer's MDM.

(How to tell which mode you're in: see
[`identify-enrollment.md`](identify-enrollment.md). Supervised / `DEP: Yes`
means full management, not the privacy-walled BYOD mode.)

---

## Practical summary

| Question | MDM protocol alone | Company-owned Mac in practice |
|----------|:---:|:---:|
| Device serial, model, OS, compliance | ✅ yes | ✅ yes |
| List of installed apps | ✅ yes | ✅ yes |
| Location | ⚠️ only if that feature is enabled | ⚠️ often available |
| Browsing history | ❌ no | ⚠️ yes, *if* a monitoring agent is installed |
| File contents | ❌ no | ⚠️ yes, root scripts/agents can read files |
| Keystrokes / screen | ❌ no | ⚠️ yes, *if* a keylogger/screen-recorder is deployed |
| Personal Messages / email / photos | ❌ no | ⚠️ not via MDM, but a root agent could reach local copies |

**Bottom lines:**

- On **your own device** with only a leftover enrollment and no active agents,
  the practical exposure of your personal content was low — but the clean fix is
  still to get it unenrolled (see
  [`escalation-playbook.md`](escalation-playbook.md)).
- On an **organization's device**, assume **no privacy**. The protocol's limits
  don't protect you, because the org can install whatever it wants as root. If
  privacy matters, use a personal device, not theirs.

---

### Sources

- [Apple — Mobile Device Management settings and payloads](https://support.apple.com/en-gb/guide/mdm/mdmf01626ea7/web)
- [Hexnode — BYOD privacy controls: what MDM can and cannot see](https://www.hexnode.com/blogs/mdm-byod-privacy-controls/)
- [Jamf community — Can Jamf see my files and log keystrokes?](https://community.jamf.com/general-discussions-2/can-jamf-see-my-files-and-log-keyboard-presses-29850)
- [9to5Mac — Can IT departments read iMessages of iOS devices and Macs?](https://9to5mac.com/2019/09/14/it-department-imessages/)
- [Ignition IT — MDM isn't spyware (what MDM actually sees)](https://www.ignitionit.com/blog/mdm-isnt-spyware-heres-how-to-explain-that-to-your-team)
