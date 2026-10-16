# Escalation playbook: getting an ADE/DEP Mac released

This is the practical, step-by-step path to the **only complete removal** for an
Automated Device Enrollment (ADE/DEP) Mac you own: getting the serial number
**released from Apple Business/School Manager** at the source. See
[`how-mdm-works.md`](how-mdm-works.md) for *why* this is the only path that
sticks.

> Use this only for a device **you own**. If it's an organization's device,
> this isn't the playbook — go through their IT offboarding. See
> [`legal-and-ethics.md`](legal-and-ethics.md).

---

## Step 0 — Confirm you actually need this

Run the inspector first:

```sh
./scripts/mdm-status.sh
```

- `Enrolled via DEP: No` → **Stop.** You don't need this playbook; remove the
  profile locally (see [`supported-removal.md`](supported-removal.md)).
- `Enrolled via DEP: Yes` → continue.

---

## Step 1 — Gather your evidence pack

Collect these before contacting anyone. You'll reuse them in every message.

- [ ] **Serial number** — `system_profiler SPHardwareDataType | awk -F': ' '/Serial Number/{print $2}'`
- [ ] **Model + year** (e.g. "MacBook Air M2, 2022").
- [ ] **Proof of purchase** — invoice/receipt showing the serial (or at least
      the purchase + a way to tie it to the device). Scan/photo.
- [ ] **Seller details** — name, order number, marketplace, date, contact.
- [ ] **The managing org hint** — the enrollment `Server` URL, which often
      reveals who holds the device in their MDM:
      ```sh
      sudo profiles show -type enrollment 2>/dev/null | grep -iA1 -e server -e organization
      ```
      Note the domain (e.g. `something.jamfcloud.com`, `*.mosyle.com`) — it tells
      you which organization to chase.

Keep everything in one folder. This evidence pack *is* the "key" — there's no
technical substitute for it on an ADE device.

---

## Path A — Ask the seller / reseller to release it  (try this first)

The fastest fix. Whoever sold you the Mac (or the business it came from) can
release the serial from their ABM/ASM in under a minute:
**Apple Business/School Manager → Devices → search serial → Release Device.**
They are **contractually obligated** under the ABM/ASM terms to release devices
they no longer own.

### Template — message to the seller

> Subject: Please release MacBook serial `<SERIAL>` from Apple Business/School Manager
>
> Hi,
>
> I purchased this Mac from you (order `<ORDER #>`, dated `<DATE>`). It still
> shows an **MDM "Remote Management" enrollment** from a previous organization,
> which means it re-enrolls every time macOS is reinstalled.
>
> Could you please **release the device from your Apple Business Manager (or
> Apple School Manager)** account? The steps are:
> **Apple Business/School Manager → Devices → search the serial below →
> Release Device.**
>
> - Serial number: `<SERIAL>`
> - Model: `<MODEL / YEAR>`
>
> This is the only way to fully remove the enrollment, and under the ABM/ASM
> program terms the device should be released once it's no longer owned by your
> organization. I'm happy to provide proof of purchase. Thank you!

### If the seller says "we don't use ABM / it's not ours"

The `Server` URL from Step 1 shows a *different* organization is the one holding
it. Ask the seller where they sourced it, and contact that organization with the
same request. If that's a dead end, go to Path B.

---

## Path B — Apple, with proof of purchase  (when the seller won't/can't)

If the seller is unresponsive, unknown, or no longer in business, **Apple** can
disassociate the serial from Device Enrollment for the rightful owner.

1. Go to **Apple Support** → start a case for Mac.
   - Web: https://support.apple.com/contact
   - Or call your region's Apple Support line.
2. Ask specifically for: *"removal of my device from Device Enrollment /
   Automated Device Enrollment — I own the device but it's still assigned to a
   previous organization's MDM."*
3. Provide your **evidence pack** (Step 1): serial, model, and **proof of
   purchase**. Apple keys everything off the serial.
4. If the first agent is unsure, ask to escalate to the team that handles
   **Device Enrollment Program / Apple Business Manager** device removal — this
   is a known process; frontline agents don't always recognize it immediately.

### Template — what to tell Apple Support

> I own a `<MODEL / YEAR>`, serial `<SERIAL>`, which I purchased on `<DATE>`
> (proof of purchase attached). The Mac is still enrolled in a previous
> organization's MDM through **Automated Device Enrollment**, so it shows the
> **Remote Management** screen and re-enrolls after every macOS reinstall. I've
> been unable to get the selling organization to release it from Apple Business
> Manager. Please disassociate this serial number from Device Enrollment so the
> device is no longer assigned to that organization.

---

## Path C — Return / refund  (the honest fallback)

If you bought it recently and can't get it released through A or B, the correct
move is to **return it** as "sold while still MDM-enrolled / assigned in Apple
Business Manager." That's a legitimate not-as-described basis on most
marketplaces. Don't keep fighting a device you can't get released — get your
money back and buy one that's clean.

---

## Step 2 — Verify after release

Once the seller or Apple confirms the serial has been released:

1. Erase & reinstall macOS (see [`supported-removal.md`](supported-removal.md)).
2. At Setup Assistant, there should be **no Remote Management screen**.
3. Confirm:
   ```sh
   profiles status -type enrollment
   ```
   You want `Enrolled via DEP: No` and `MDM enrollment: No`.

If `Enrolled via DEP:` is still `Yes`, the release either hasn't propagated yet
(give it a few hours) or didn't go through — go back to the seller/Apple.

---

## What NOT to waste time on

For an ADE device, these do **not** achieve removal (see
[`why-reformat-doesnt-work.md`](why-reformat-doesnt-work.md) and
[`linux-does-not-remove-mdm.md`](linux-does-not-remove-mdm.md)):

- Reformatting / reinstalling macOS — re-enrolls on next check-in.
- Installing Linux — hides it; serial still assigned.
- Blocking Apple/MDM hostnames or skipping Wi-Fi at setup — temporary and
  fragile.
- Any "MDM bypass tool" that claims a permanent local removal — it can't touch
  the ABM record; at best it's a temporary bypass, and paid ones are frequently
  scams.

The release is the key. Everything else is a workaround you'll keep redoing.
