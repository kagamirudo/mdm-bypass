# Does installing Linux remove MDM? No — it hides it.

> "If I install Linux on the Mac, can MDM be gone?"

Short answer: **No. Installing Linux is a bypass, not a removal.** It can make
the management *dormant* (because the OS that checks in never boots), but the
enrollment record is untouched and reasserts the moment macOS runs again.

This is the same root cause as
[`why-reformat-doesnt-work.md`](why-reformat-doesnt-work.md): for an ADE/DEP
device, the enrollment is a **server-side record in Apple Business/School
Manager keyed to your serial number**, not a file on the disk. Linux lives on
the disk. It cannot reach the record.

## What Linux actually changes

```
macOS boot:   firmware → macOS → contacts Apple activation servers
                                   → sees serial assigned → pulls MDM profile  ← management active

Linux boot:   firmware → Linux (macOS never runs, so nobody asks Apple)        ← management DORMANT,
                                                                                  record still exists
```

macOS is the component that phones home and enrolls. Boot Linux instead and
that conversation simply never happens — so you get a usable, unmanaged
*desktop*. But:

- The **ABM/DEP assignment still exists** at Apple.
- Reinstall macOS (or dual-boot into it) and connect to the network → the
  Remote Management screen returns, exactly like after a reformat.
- You haven't removed management; you've stopped running the OS that obeys it.

A first-hand account of doing this (Asahi Linux on a Mosyle-managed M2) states
it plainly: *"This is a bypass, not a removal. The MDM profile still exists. If
I booted macOS and reconnected to the internet, enrollment would attempt again.
The profile cannot be fully removed without cooperation from the organization
that created it."*

## Apple silicon (M1/M2/M3/M4): Linux can't even fully leave macOS behind

On Apple silicon, Linux (Asahi) **cannot remove macOS completely**:

- It requires a **"stub macOS"** partition (~2.5 GB: iBoot, firmware,
  recoveryOS) just to boot. This is a platform requirement — *every* OS on
  Apple silicon depends on Apple-provided boot components. You cannot delete the
  recovery partition and still boot Linux.
- The Mac calls home through **system firmware**, which sits *below* the OS. The
  firmware's view of the device doesn't change because you installed Linux.
- **Activation Lock**, if present, is enforced at the firmware/Apple-ID level —
  Linux does not clear it either.

So on Apple silicon you can't even reach "the Apple software is entirely gone,"
let alone "the enrollment is gone."

## Intel Macs

You *can* wipe macOS entirely and run Linux (no stub needed). But the DEP record
still exists at Apple's servers — if macOS ever returns and goes online,
management reasserts. Still dormant, not removed.

## Is running Linux a legitimate choice?

Yes — if **you own the Mac** and you actually want to run Linux, then living
with dormant management you never trigger is perfectly fine in practice. That's
a real use case, not a trick.

What it is **not** is "completely removing MDM." If your goal is a Mac that is
permanently free of MDM and boots clean on a fresh macOS install, Linux doesn't
get you there.

## The only complete removal (still)

```
Owning org:  Apple Business/School Manager → Devices → serial → Release Device
```

One-time, non-reversible, done at the source. After that, macOS reinstalls
unmanaged forever. See
[`why-reformat-doesnt-work.md`](why-reformat-doesnt-work.md) and
[`supported-removal.md`](supported-removal.md) for how to get the owning org (or
Apple, with proof of purchase) to do it.

## Summary table

| Approach | macOS boots clean? | MDM record removed? | Survives macOS reinstall? |
|----------|:---:|:---:|:---:|
| Reformat / reinstall macOS | yes | **no** (DEP) | no — re-enrolls |
| Install Linux | n/a (runs Linux) | **no** | no — macOS re-enrolls |
| Local profile removal (user enrollment only) | yes | yes | yes |
| **Release from ABM/ASM** (source) | yes | **yes** | **yes** |

---

### Sources

- [Asahi Linux — Open OS Platform Interoperability](https://asahilinux.org/docs/platform/open-os-interop/)
- [Asahi Linux — Apple Silicon Platform Security](https://asahilinux.org/docs/platform/security/)
- [Asahi Linux — Partitioning cheatsheet (stub macOS / recovery partition is required)](https://asahilinux.org/docs/sw/partitioning-cheatsheet/)
- [One Door at a Time: Reclaiming a Mosyle-Managed M2 MacBook (first-hand: Linux is a bypass, not a removal)](https://medium.com/@hawkingtontech/one-door-at-a-time-ec8eb476c98f)
- [Apple Community — How to detect MDM presence (firmware phones home)](https://discussions.apple.com/thread/255890517)
