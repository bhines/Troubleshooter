# Troubleshooter

Offline field app for repairing Rico push-rod inspection cameras and CIPP robotic cutters (IMS Robotics, Cosmic, Dancutter).

- **App:** `troubleshooter.html`, a single self-contained file. Open it in any browser, on a phone or a PC.
- **Live copy:** the claude.ai artifact "Troubleshooter".
- **Manuals and schematics:** not in this repo. The app opens them through relative paths, so put the folders `Rico/`, `IMS/`, `Cosmic/` and `Dancutter/` next to the HTML file (they live in OneDrive).

## Editing
All data (makers, models, documents, specs, fault trees) is at the top of the script under "DATA — edit here". See `CLAUDE.md` for the rules and the checks to run before committing.

## Open items
- Cosmic `cos_fe1` tree: the FE-1 controller LED colours (green/yellow/red/blue) were read from the picture on manual page B2.8. Confirm them on the real controller.
