# Legal & ethics

Read this before using anything in the repo.

## The one rule

**Only remove MDM from a device you own or are explicitly authorized to
administer.** Ownership is the thing that makes this legitimate. If you can't
show you own the device, don't do this.

## When this is appropriate

- A Mac you **bought** (new, used, or refurbished) that still shows a prior
  owner's or reseller's MDM enrollment.
- Your **personal** device that you previously enrolled yourself and now want
  unmanaged.
- A device you administer **with the owner's explicit permission**.

## When this is NOT appropriate

- A laptop issued to you by an **employer or school**. Even if you use it daily,
  the organization owns it and the enrollment is theirs. Removing it can
  violate acceptable-use policy, employment/enrollment agreements, and —
  depending on jurisdiction and intent — computer-misuse law.
- A device whose **ownership you can't establish**. A device being in your
  possession is not the same as owning it (e.g. lost/stolen hardware,
  not-yet-paid financed devices).
- Anything you intend to **resell or hand off while hiding** that it was
  managed.

## If it's an organization's device

Don't bypass it — ask. The supported path is:

1. Contact the org's IT / helpdesk and request **offboarding** or
   **unenrollment** of the specific device (have the serial ready).
2. For a device you bought that's still tied to someone else's organization,
   contact the **seller/reseller** and ask them to release it from their Apple
   Business Manager / Apple School Manager. This is the only thing that removes
   it from Automated Device Enrollment.
3. If the seller is unresponsive, Apple can remove a device from DEP/ABM with
   **proof of purchase** — see [`supported-removal.md`](supported-removal.md).

## Proof of ownership — keep these

If you ever need Apple or a reseller to release a device, you'll want:

- Original **proof of purchase** / invoice with the device **serial number**.
- The **seller's** details.
- Any correspondence showing you asked the seller to unenroll it.

This paper trail is the real "key." There is no legitimate technical trick that
substitutes for it on an ADE-enrolled device.
