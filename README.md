# Wassalny Captain 🚕

A production-ready **ride-hailing captain (driver) app** built from the
`Wassalny Captain` UI/UX design, implemented in Flutter with **Clean
Architecture**, the **BLoC** pattern, **GoRouter**, **GetIt**, and a
**Supabase** data layer that can be swapped for any REST backend without
touching the domain or presentation layers.

---

## ✨ Highlights

- **Clean Architecture** — strict `data → domain → presentation` separation per
  feature, with `Either<Failure, T>` use cases (via `dartz`).
- **Feature-first** structure — every screen is a self-contained feature.
- **flutter_bloc** — events & states in separate files, `Equatable` everywhere,
  zero business logic in the UI.
- **Centralized design system** — no hardcoded colors or font sizes; light &
  dark themes.
- **Swappable backend** — `Supabase` is fully isolated inside the data layer
  behind `*RemoteDataSource` interfaces. In-memory data sources let the entire
  app run with **no credentials** for UI development.
- **Responsive** — content adapts across phone / tablet via breakpoint helpers.

---

## 📱 Screens (all converted from the design)

Splash · Login · Sign up · OTP · Forgot password · Dashboard (live map, online
toggle, earnings glance, nearby requests, offline state) · Incoming request
(countdown) · Navigate to pickup · Arrived · Active trip · Trip completed
(receipt) · Earnings (Day/Week/Month + chart) · Wallet · Ride history ·
Notifications · Profile · Vehicle management · Support center.

---

## 🏗 Architecture

```
UI (Widgets)
  ↓ dispatch events
BLoC / Cubit            ← all business logic
  ↓ call
Use Case                ← single responsibility, returns Either<Failure, T>
  ↓
Repository (interface)  ← domain contract
  ↓ implemented by
Repository (impl)       ← maps exceptions → Failures
  ↓
Remote Data Source      ← interface (Supabase impl • REST impl • in-memory impl)
  ↓
Supabase / REST / Memory
```

To replace Supabase with a REST API you only implement the
`*RemoteDataSource` interfaces and rebind them in
`core/dependency_injection/injection_container.dart`. **Domain and presentation
remain untouched.**

---

## 📂 Project structure

```
lib/
├── core/
│   ├── constants/            # app + dimension constants
│   ├── theme/                # app_colors, app_text_styles, app_theme
│   ├── routes/               # app_routes, app_router (GoRouter), main_shell
│   ├── widgets/              # reusable buttons, cards, fields, sheets, dialogs,
│   │                         #   states, map view, bottom nav, etc.
│   ├── services/             # supabase_service (the only backend seam)
│   ├── errors/               # failures + exceptions
│   ├── extensions/           # context & num extensions
│   ├── usecases/             # base UseCase contract
│   ├── utils/                # responsive helpers
│   └── dependency_injection/ # injection_container (GetIt)
│
├── features/<feature>/
│   ├── data/        (datasources • models • repositories impl)
│   ├── domain/      (entities • repositories interfaces • usecases)
│   └── presentation/(bloc | cubit • pages • widgets)
│
├── app.dart                  # root widget: global blocs + theming + router
└── main.dart                 # bootstrap
```

Features: `splash`, `auth`, `dashboard`, `trip`, `earnings`, `wallet`,
`history`, `notifications`, `profile`, `vehicle`, `support`.

---

## ▶️ Running

```bash
flutter pub get

# UI mode (in-memory data, no backend needed):
flutter run

# With a live Supabase backend:
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

When `SUPABASE_URL` is empty the app automatically uses the in-memory data
sources, so it is always runnable.

---

## 🧪 Tests

```bash
flutter test
```

Includes `bloc_test` coverage for `AuthBloc` (login success/failure) and
`DashboardBloc` (optimistic online toggle + revert on failure).

---

## 🎨 Design system

- **Font:** Plus Jakarta Sans (via `google_fonts`).
- **Accent:** Captain blue `#67B2D8`; success `#2FD27D`; warning `#F5B544`;
  danger `#FF5247`. All tokens live in `core/theme/app_colors.dart`.
