# mdm-bypass

Research notes and tooling for **safely and fully removing MDM (Mobile Device
Management) enrollment from a Mac you own**.

> ⚠️ **Scope & ethics.** This repository documents owner-authorized removal of
> MDM from hardware the operator legally owns and controls — for example a
> machine bought used/refurbished that still carries a previous owner's or
> reseller's enrollment, or a personal device you want to return to an
> unmanaged state. It is **not** a guide for evading controls on a device that
> an employer, school, or other organization legitimately owns or has assigned
> to you. If a device belongs to an organization, go through that
> organization's IT/offboarding process instead. See
> [`docs/legal-and-ethics.md`](docs/legal-and-ethics.md).

## Start here: how MDM actually works

If you only read one doc, read [`docs/how-mdm-works.md`](docs/how-mdm-works.md).
It explains the mechanism — the four parties, the pull-based APNs protocol, and
the two enrollment types — and then derives *why* each removal method works,
fails, or is only temporary. Everything else in this repo is a consequence of
it.

## Why "bypass" is usually the wrong word

For most owned Macs, MDM can be removed cleanly through supported paths — you
rarely need to "bypass" anything. The order of preference is always:

1. **Have it unenrolled at the source** (ABM/ASM / the MDM server). This is the
   only method that also removes the device from Automated Device Enrollment
   (ADE/DEP), so it never re-appears on wipe. See
   [`docs/supported-removal.md`](docs/supported-removal.md).
2. **Remove the local MDM profile** if enrollment was user/manual (not
   supervised via ADE). Supported and reversible.
3. **Erase & reinstall macOS.** Clears local management, but if the device is
   still in ADE it will re-prompt for enrollment at Setup Assistant.

If the device is in ADE and you cannot get the source record removed, the
"management" is working as designed and there is no supported local bypass —
the right fix is a paper trail proving ownership. See
[`docs/supported-removal.md`](docs/supported-removal.md#device-enrollment-ade--dep).

**"But if I reformat, it comes back!"** Correct — for an ADE/DEP device that's
expected, because the enrollment is a server-side record keyed to your serial,
not something on the disk. [`docs/why-reformat-doesnt-work.md`](docs/why-reformat-doesnt-work.md)
explains the re-enrollment loop, why the "skip Wi-Fi"/host-blocking tricks are
temporary, and what the single permanent removal step actually is.

**"What if I install Linux instead?"** That hides management (macOS never boots
to check in) but does not remove it — and on Apple silicon Linux can't even
fully leave macOS behind. See
[`docs/linux-does-not-remove-mdm.md`](docs/linux-does-not-remove-mdm.md).

## Layout

| Path | Contents |
|------|----------|
| [`docs/how-mdm-works.md`](docs/how-mdm-works.md) | **The mechanism.** How Apple MDM works and why removal works where it does. Read first. |
| [`docs/identify-enrollment.md`](docs/identify-enrollment.md) | Read-only commands + decision tree to classify your enrollment. |
| [`docs/supported-removal.md`](docs/supported-removal.md) | The supported removal paths for each enrollment type. |
| [`docs/escalation-playbook.md`](docs/escalation-playbook.md) | Step-by-step + copy-paste templates to get an ADE/DEP serial released at the source. |
| [`docs/why-reformat-doesnt-work.md`](docs/why-reformat-doesnt-work.md) | Why reformatting doesn't remove ADE/DEP management. |
| [`docs/linux-does-not-remove-mdm.md`](docs/linux-does-not-remove-mdm.md) | Why installing Linux hides but doesn't remove MDM. |
| [`docs/legal-and-ethics.md`](docs/legal-and-ethics.md) | Scope: owner-authorized removal only. |
| [`scripts/`](scripts/) | Read-only diagnostic helpers (no changes to your system). |

## Quick start

```sh
# Inspect current enrollment state (read-only, safe to run)
./scripts/mdm-status.sh
```

Then read [`docs/identify-enrollment.md`](docs/identify-enrollment.md) to
interpret the output and pick the right removal path.

## Disclaimer

Provided for educational and authorized-administration purposes only. You are
responsible for ensuring you have the right to modify any device you run this
against. No warranty. See [`LICENSE`](LICENSE).
