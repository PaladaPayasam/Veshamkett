<div align="center">

<img src="https://raw.githubusercontent.com/PaladaPayasam/Veshamkett/main/.docs/banner.png" alt="Veshamkett Banner" width="100%"/>

# 🍃 Veshamkett

### *Kerala's First Thrift & Fashion Discovery Platform*

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase"/></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-F7C948?style=for-the-badge" alt="MIT License"/></a>
  <a href="https://github.com/PaladaPayasam/Veshamkett/releases"><img src="https://img.shields.io/github/v/release/PaladaPayasam/Veshamkett?style=for-the-badge&color=48A672&label=Latest" alt="Latest Release"/></a>
</p>

> **Veshamkett** (വേഷം കെട്ട്) — literally "to dress up" in Malayalam — is a social marketplace and map-discovery app connecting fashion lovers to Kerala's hidden thrift stores, vintage boutiques, and the community that styles them.

<p align="center">
  <a href="#-download"><strong>⬇ Download APK</strong></a> &nbsp;|&nbsp;
  <a href="#-features"><strong>✨ Features</strong></a> &nbsp;|&nbsp;
  <a href="#-architecture"><strong>🏛 Architecture</strong></a> &nbsp;|&nbsp;
  <a href="#️-local-setup"><strong>🛠 Setup</strong></a> &nbsp;|&nbsp;
  <a href="#-database-schema"><strong>🗄 Database</strong></a> &nbsp;|&nbsp;
  <a href="#-contributing"><strong>🤝 Contribute</strong></a>
</p>

</div>

---

## ⬇️ Download

> **No Play Store required.** Sideload the APK directly onto any Android device.

<div align="center">

### [📦 Download Latest APK → Releases](https://github.com/PaladaPayasam/Veshamkett/releases/latest)

</div>

**Quick install:**
1. Download `app-release.apk` from the [latest release](https://github.com/PaladaPayasam/Veshamkett/releases/latest).
2. On Android: **Settings → Security → Install Unknown Apps** → enable for your browser/file manager.
3. Open the `.apk` and tap **Install**.
4. Launch **Veshamkett** 🍃

> ⚠️ Requires **Android 6.0 (Marshmallow)** or later.

---

## ✨ Features

### 🗺️ Interactive Store Map
Discover real, verified thrift and fashion stores across Kerala on a live **OpenStreetMap**-powered map — zero API costs, zero subscriptions.

- **Custom category markers** per store type — Thrift 👗, Vintage ⭐, Retail Chain 🏬
- **Bi-directional sync** — tap a map pin to snap the bottom carousel to that store; swipe the carousel to animate the map camera
- **Swipeable store cards** with store name, rating, distance, and action links
- **One-tap Google Maps directions** from any store card
- **Real-time search & filter chips** — filter by city or category with zero network latency
- **GPS centering** — find stores near your exact current location

### 🎮 Thrift Quest *(Gamification)*
Turn thrift shopping into an adventure with a location-aware badge system.

- **GPS proximity check-in** — physically visit a store within **50 metres** to unlock it
- Earn badges like *"Kochi Nomad"*, *"Thrift Hunter"*, *"Vintage Voyager"* and more
- View your full badge collection via the **🏆 trophy button** in the top bar
- **Haptic feedback** on every unlock for a satisfying, tactile experience

### 📸 Fit Checks Feed
A community-driven outfit showcase powered by your thrift finds.

- **Pinterest-style masonry grid** for outfit photos
- Tag posts to the exact store where you found your fit
- Upload outfits directly from your camera roll via `image_picker`
- Community-reviewed, crowdsourced fashion inspiration

### 🛍️ Online Shops Directory
Kerala's fashion Instagram scene, neatly curated.

- Browse boutiques and online sellers with a live **star rating** system driven by real reviews
- **Top Rated ★** sort chip to surface highest-reviewed shops instantly
- Direct links to **Instagram** profiles and external websites via `url_launcher`

### 🔐 Secure Authentication
- Email + password sign-up & login via **Supabase Auth**
- Choose a **unique username** shown on your community posts
- Session-gated access — social features are auth-protected

---

## 🏙️ Store Coverage

| District | Store Types Available |
|---|---|
| **Kozhikode** | Thrift, Vintage, Retail Chains |
| **Ernakulam (Kochi)** | Thrift, Surplus, Retail, Vintage |
| **Thrissur** | Thrift, Retail Chains |
| **Malappuram** | Retail Chains |
| **Thiruvananthapuram** | Thrift, Vintage, Retail |

> All stores are **100% verified real businesses** with confirmed addresses and GPS coordinates. No AI-generated or placeholder listings.

---

## 🏛 Architecture

```
veshamkett/
├── lib/
│   ├── main.dart                   # App entry — Supabase init, theme setup
│   ├── models/
│   │   └── store.dart              # Store data model
│   ├── screens/
│   │   ├── auth_wrapper.dart       # Auth state router
│   │   ├── auth_screen.dart        # Login / Sign-up UI
│   │   ├── main_screen.dart        # Root scaffold + tab navigation
│   │   ├── map_screen.dart         # Interactive map + store discovery
│   │   ├── fit_checks_screen.dart  # Community fit feed (masonry grid)
│   │   └── online_store_list_screen.dart  # Online boutiques directory
│   ├── services/
│   │   └── store_service.dart      # Supabase data fetching layer
│   ├── theme/
│   │   └── app_theme.dart          # Light/dark theme definitions (Montserrat)
│   └── widgets/                    # Reusable UI components
├── .docs/
│   ├── PRD.md                      # Product requirements document
│   ├── Database_Schema.md          # Full Supabase schema reference
│   ├── App_Capabilities_UI.md      # UI architecture & theming guide
│   ├── Supabase_Setup.sql          # Initial DB setup script
│   └── Supabase_Migration_V2.sql   # V2 migration (achievements, fit_checks)
├── .env.example                    # Template — copy to .env
└── pubspec.yaml
```

### Data Flow

```
User opens app
      │
      ▼
AuthWrapper checks Supabase session
      │
  ┌───┴───────────────────┐
  │ Logged in             │ Not logged in
  ▼                       ▼
MainScreen            AuthScreen
  │                       │ (sign up / log in)
  ├── MapScreen            │
  │     └── StoreService ──┼──► Supabase DB (stores, reviews)
  ├── FitChecksScreen      │
  │     └── Supabase ──────┘
  └── OnlineStoreList
        └── Supabase ──────► online_stores table
```

---

## 🧰 Tech Stack

| Layer | Technology | Reason |
|---|---|---|
| **Framework** | [Flutter 3.x](https://flutter.dev) (Dart) | Cross-platform; single codebase for Android & iOS |
| **Backend & Auth** | [Supabase](https://supabase.com) (PostgreSQL + RLS) | Zero-cost backend with built-in auth and realtime |
| **Maps** | [flutter_map](https://pub.dev/packages/flutter_map) + OpenStreetMap | No API key or billing required |
| **Location** | [geolocator](https://pub.dev/packages/geolocator) | GPS-based proximity check-ins |
| **Feed Layout** | [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) | Pinterest-style masonry grid |
| **Image Caching** | [cached_network_image](https://pub.dev/packages/cached_network_image) | Smooth image loading with fallback |
| **Image Picker** | [image_picker](https://pub.dev/packages/image_picker) | Outfit photo uploads |
| **URL Launching** | [url_launcher](https://pub.dev/packages/url_launcher) | Instagram / Maps / web links |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) (Montserrat) | Editorial, modern look |
| **Environment** | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) | Secure credential management |

---

## 🗄️ Database Schema

The full Supabase schema is documented in [`.docs/Database_Schema.md`](.docs/Database_Schema.md) and the SQL setup scripts live in `.docs/`.

**Key tables:**

| Table | Purpose |
|---|---|
| `stores` | Physical store records — name, coordinates, district, category, rating |
| `online_stores` | Online boutiques — name, Instagram URL, website, rating |
| `reviews` | Star ratings (1–5) linked to stores & users |
| `user_achievements` | Thrift Quest badge unlocks per user |
| `fit_checks` | Community outfit posts linked to specific stores |

**Row Level Security (RLS)** is enabled on all tables:
- `SELECT` — public read for discovery features
- `INSERT/UPDATE/DELETE` — authenticated users only (reviews, fit checks); admin-only for stores

---

## 🛠️ Local Setup

### Prerequisites

| Tool | Version |
|---|---|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | 3.x |
| [Dart](https://dart.dev/get-dart) | 3.x |
| Android Studio **or** VS Code + Flutter extension | latest |
| A [Supabase](https://supabase.com) project | Free tier works |

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/PaladaPayasam/Veshamkett.git
cd Veshamkett
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Configure environment variables**

Copy the template and fill in your Supabase credentials:
```bash
cp .env.example .env
```

Edit `.env`:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
```

> 🔑 Find these at: **Supabase Dashboard → Project Settings → API**

**4. Set up the database**

Run the SQL scripts in your Supabase SQL editor in order:
```
.docs/Supabase_Setup.sql          ← Run first (tables, RLS)
.docs/Supabase_Migration_V2.sql   ← Run second (achievements, fit_checks)
```

**5. Run the app**
```bash
flutter run
```

**6. Build a release APK** *(optional)*
```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

---

## 🗺️ Theming System

Veshamkett uses a **"Modern Vintage"** design language that adapts to the device's system appearance.

| | Light Mode | Dark Mode |
|---|---|---|
| **Background** | Crisp White `#FFFFFF` | Deep Charcoal `#121212` |
| **Cards** | Soft Cream `#FAF9F6` | Elevated Grey `#2C2C2C` |
| **Accent** | Forest Green `#2E8B57` | Organic Green `#48A672` |
| **Map Tiles** | CartoDB Voyager (bright) | CartoDB Dark Matter |
| **Typography** | Montserrat (Google Fonts) | Montserrat (Google Fonts) |

The theme toggle (☀️/🌙) in the app bar switches modes instantly — no restart needed.

---

## 🤝 Contributing

Contributions are welcome! The most impactful thing you can do is **add more verified stores**.

### Adding a store
1. Fork the repository
2. Edit `stores_seed.csv` or `online_stores_seed.csv` with the new store entry
3. Open a Pull Request with the store's name, coordinates, and a source link confirming it's real

### General contributions
```bash
# 1. Fork & clone
git clone https://github.com/YOUR_USERNAME/Veshamkett.git

# 2. Create a feature branch
git checkout -b feature/your-feature-name

# 3. Make your changes, then commit
git commit -m "feat: describe your change"

# 4. Push and open a Pull Request
git push origin feature/your-feature-name
```

**Please follow [Conventional Commits](https://www.conventionalcommits.org/)** for commit messages:
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation only
- `chore:` — maintenance / tooling

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with 💚 in Kerala &nbsp;|&nbsp; Built with Flutter & Supabase

*Veshamkett — because great style shouldn't cost a fortune.*

**[⬆ Back to Top](#-veshamkett)**

</div>
