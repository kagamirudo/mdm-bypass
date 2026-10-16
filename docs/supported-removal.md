# Supported removal paths

Pick the section that matches your enrollment type (see
[`identify-enrollment.md`](identify-enrollment.md)). Everything here uses
Apple-supported mechanisms — no exploits.

> Back up first. Several of these paths involve erasing the Mac.

---

## User / manual enrollment (not DEP)

This is the easy case: enrollment is a local profile and is designed to be
removable.

**GUI:** System Settings → General → Device Management → select the management
profile → **Remove**. You may be asked for the admin password and, if the org
configured one, a removal passcode.

**CLI:**

```sh
# Remove the enrollment profile (reversible, supported)
sudo profiles remove -type enrollment

# Or remove a specific profile by identifier (get it from `profiles list`)
sudo profiles remove -identifier <com.example.profile.id>
```

If removal is blocked by a removal passcode you don't have, you don't have
authority to remove it that way — go back to the owner/org, or erase & reinstall
(below), which clears local profiles.

---

## Erase & reinstall macOS

Clears **all local** management and profiles. Does **not** remove the device
from ABM/ASM — so if it's in ADE, Setup Assistant will offer/force enrollment
again.

- Apple silicon / T2: **System Settings → General → Transfer or Reset → Erase
  All Content and Settings** (fastest, keeps macOS).
- Or boot to **Recovery** (hold power on Apple silicon; ⌘R on Intel), erase the
  data volume in Disk Utility, then reinstall macOS.

Use this when you have **user enrollment** and just want a clean slate, or when
you've already had the device released from ADE and want to confirm it comes up
unmanaged.

---

## Device Enrollment (ADE / DEP) — the real one

If `Enrolled via DEP: Yes`, the enrollment lives in **Apple Business Manager
(ABM)** or **Apple School Manager (ASM)**, not just on your disk. Wiping the Mac
does not help — it re-enrolls at Setup Assistant. There is **no supported local
bypass**, and that's by design (it's the anti-theft / fleet-ownership feature).

The supported fixes, in order:

1. **Have the current organization release it.**
   Whoever owns the ABM/ASM instance (the reseller, former employer, or
   previous owner) can remove the device from their org. Once released, erase &
   reinstall and it comes up unmanaged. For a device you bought, contact the
   **seller** and ask them to release the serial from their ABM/ASM.

2. **Go through Apple with proof of purchase.**
   If the seller is uncooperative or unreachable, Apple can disassociate a
   device from DEP/ABM when you provide **proof of purchase** showing you own
   it. Start at Apple Support and ask for "removal of a device from Device
   Enrollment / Automated Device Enrollment." Have the **serial number** and
   **invoice** ready.

3. **Return / refund.**
   If you bought it recently and can't get it released, the honest move is to
   return it as "sold while still MDM-enrolled."

> For the exact steps and copy-paste message templates to get a seller or Apple
> to release the serial, see [`escalation-playbook.md`](escalation-playbook.md).

### What about Activation Lock?

Separate from MDM. If the Mac also shows **Activation Lock**, that's tied to a
previous owner's Apple ID (or an MDM-held bypass code). It's cleared by the
previous owner removing it from their Find My / iCloud, or by Apple with proof
of purchase — same paper-trail requirement.

---

## Verify you're unmanaged

After any removal, re-check:

```sh
profiles status -type enrollment
```

You want `Enrolled via DEP: No` and `MDM enrollment: No`. If it's a DEP device,
only a source release will get you there permanently.
