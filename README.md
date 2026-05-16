# Bon Appetit

Bon Appetit is the unified Flutter workspace for the restaurant, bakery,
ordering, and delivery tracker application. The project is intentionally hosted
outside the old Android Studio project pile at:

```text
C:\Projects\Bon Appetit
```

## Purpose

The goal is to consolidate the useful work from older food delivery prototypes
into one maintainable app:

- Restaurant and bakery catalog
- Product/menu discovery
- Cart and checkout flow
- Local delivery tracker
- Local API server for experiments
- Docker-managed database and API lifecycle
- Clear documentation for every migration decision

This repository starts as a private/internal project. Legacy references are kept
for traceability; production code should be migrated gradually into the new
feature structure instead of copied blindly.

## Source Projects Reviewed

| Source | Current use | Notes |
| --- | --- | --- |
| `food_delivery_meal` | Primary UI and flow reference | Includes menu, login, profile, checkout, payment, notifications, address flow, assets, fonts, and HTTP helpers. |
| `food_delivery_app` | Secondary visual reference | Includes food, bakery, grocery, coffee, and product imagery. |
| `new_food_delivery_project` | Shell reference | Lightweight Flutter project with fewer reusable modules. |

## Initial Legacy Findings

- `food_delivery_meal/lib/common/globs.dart` hardcodes
  `http://192.168.1.2:3001`; this must not be migrated directly.
- `food_delivery_meal/lib/common/service_call.dart` needs stronger status-code,
  timeout, error, retry, and fallback handling before production use.
- Old UI screens should be split into feature modules, domain models, services,
  and widgets before they are accepted into the new app.
- Legacy assets were copied under `assets/legacy/...` so their origin remains
  clear during cleanup.

## Current Structure

```text
lib/
  main.dart
  src/
    app.dart
    core/
      config/
      theme/
    features/
      dashboard/
      orders/
      restaurants/
      server_status/
      tracker/
server/
  bin/server.dart
  db/init.sql
  Dockerfile
docker-compose.yml
docs/
  code_review_prompt.md
  migration_log.md
assets/
  legacy/
```

## Local Flutter Run

Android emulator access to the host API uses `10.0.2.2` by default:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

For a physical phone on the same network, replace the host with the PC LAN IP:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8080
```

For web, the app defaults to `http://localhost:8080`:

```powershell
flutter run -d chrome
```

If a release web build hits Flutter icon tree-shaker issues on Windows, use:

```powershell
flutter build web --no-tree-shake-icons
```

## Local Docker Run

The Docker stack is isolated from other projects and uses explicit names:

- `baker-server`
- `baker-postgres`
- `baker_postgres_data`

Start it with:

```powershell
docker compose up --build
```

API checks:

```powershell
curl http://localhost:8080/health
curl http://localhost:8080/restaurants
curl http://localhost:8080/orders
```

The database is exposed on host port `54329` to avoid colliding with other local
Postgres instances.

## Configuration Rules

- Use `--dart-define=API_BASE_URL=...` for the Flutter app.
- Use Docker environment variables for the local API.
- Do not hardcode host IPs, tokens, database credentials, collection IDs, or
  external service keys in application code.
- Firebase can be added later through environment-specific configuration files;
  do not commit real secrets.

## Migration Rules

- Preserve business contracts from legacy code unless a migration ticket
  explicitly approves a breaking change.
- Move one flow at a time: model, service, UI, tests, documentation.
- Keep copied assets in `assets/legacy/...` until each file is either adopted,
  replaced, or removed with a documented reason.
- Every migration should update `docs/migration_log.md`.

## Code Review Standard

The review prompt provided at project creation is stored in:

```text
docs/code_review_prompt.md
```

Reviews must prioritize functional correctness, production safety, data
integrity, non-breaking legacy improvements, and closure-ready ticket evidence.

## Ticket Closure Checklist

- What changed
- Files, screens, services, Docker pieces, or modules modified
- Evidence: screenshots, logs, snippets, or links
- Test notes and results
- Development time
- Code review time

## Current Status

- Flutter app shell created.
- Legacy assets copied with traceable folders.
- Visual dashboard expanded with real legacy product and restaurant imagery.
- Demo login, bottom navigation, live restaurant/order API reads, and tracker
  views added.
- Responsive web support with browser-safe API client and CORS-enabled Baker
  server.
- Local Docker compose seeded.
- Dart API server scaffolded.
- README and migration log seeded.
- Next step: migrate the first real restaurant/menu flow into
  `lib/src/features/restaurants`.
