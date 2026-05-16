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
