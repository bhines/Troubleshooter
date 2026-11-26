# Troubleshooter

Offline field app for a technician repairing push-rod inspection cameras (Rico) and CIPP robotic cutters (IMS Robotics, Cosmic, Dancutter).

## Rules
- One self-contained HTML file (`troubleshooter.html`) that works offline on phone and PC.
- All data (makers, models, docs, specs, fault trees) sits in clearly marked sections at the top of the script, under "DATA — edit here". App code is below "APP CODE".
- Fault trees: Yes/No questions (`{q, hint, yes, no}`) that end in fix lists (`{fix:[...]}`). Optional `maker:"<id>"` limits a built-in tree to one manufacturer.
- Specs, part numbers, pressures and voltages come ONLY from the manuals and schematics. Never invent them. If something is missing, ask Bård.
- Field use: big buttons, high contrast, usable with gloves.
- New PDFs: read them and add them to DOCS. If a file name is unclear, ask Bård.

## Where things live
- Code: this repo (`bhines/Troubleshooter`).
- Manuals and schematics (PDF): OneDrive (`E:\OneDrive - Serwent\Bård\Troubleshooter`, which is also a clone of this repo), in folders `Rico/ IMS/ Cosmic/ Dancutter/ Streicher/` next to the HTML. Copies are in the claude.ai project "Troubleshooter". They are not in git.
- Published app: claude.ai artifact "Troubleshooter" (https://claude.ai/artifact/MSJHGv7BkmEzYrA7Kh9EVe). Keep it in sync with `main`.

## Check before committing
- Extract the `<script>` contents and run `node --check` on it.
- Walk every tree to its leaves: each node has `q`, `yes` and `no`, or a non-empty `fix` array.
