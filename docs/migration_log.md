# Migration Log

## 2026-05-15 - Project Seed

Created `Bon Appetit` in `C:\Projects` as the new unified Flutter workspace.

### Reviewed Source Projects

- `food_delivery_meal`: selected as the primary legacy reference because it
  contains restaurant, menu, profile, checkout, payment, notification, address,
  and HTTP service code.
- `food_delivery_app`: selected for additional UI and image references around
  food, bakery, grocery, coffee, and product cards.
- `new_food_delivery_project`: reviewed as a lightweight Flutter shell with
  fewer reusable modules.

### Initial Decisions

- Keep legacy assets under `assets/legacy/...` to preserve source traceability.
- Exclude large copied coffee videos from the initial repository seed until a
  real media strategy exists.
- Do not migrate hardcoded API hosts directly into new code.
- Use `API_BASE_URL` through `--dart-define` for Flutter runtime configuration.
- Keep Docker services isolated as `baker-server` and `baker-postgres`.
- Use a clean `lib/src/features/...` structure before moving old screens.

### Known Legacy Risks Found

- `food_delivery_meal/lib/common/globs.dart` hardcodes
  `http://192.168.1.2:3001`.
- `food_delivery_meal/lib/common/service_call.dart` has limited response status
  handling and no retry/fallback strategy.
- Several legacy screens are UI-first and need domain/data separation before
  production use.

## 2026-05-15 - Visual Dashboard Expansion

Expanded the initial dashboard so the app starts to feel like the combined
restaurant, bakery, order, and delivery product instead of a static shell.

### Added

- Hero panel using legacy food imagery.
- Featured menu examples using product assets from `food_delivery_app`.
- Restaurant seed rows using images from `food_delivery_meal`.
- Shared asset path constants in `lib/src/core/assets`.

### Guardrails

- Kept image usage under `assets/legacy/...` until each asset receives a final
  product decision.
- Kept runtime API host configurable through `API_BASE_URL`.
- Updated widget test expectations after adding the hero brand title.

## 2026-05-15 - Functional App Pass

Added the first usable application layer after emulator testing exposed the
dashboard as too static.

### Added

- Demo login screen.
- Bottom navigation shell for Home, Menu, Orders, and Track sections.
- Baker API client using `API_BASE_URL`.
- Restaurant, order, and server status repositories.
- Restaurant and order screens backed by Docker API endpoints.
- Tracker screen with a delivery timeline.
- Android Internet permission for emulator API calls.

### Fixed

- Mobile hero overflow on `sdk gphone64 x86 64`.
- Static dashboard preview sections now refresh from `baker-server`.
