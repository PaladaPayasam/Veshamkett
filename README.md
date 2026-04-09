<div align="center">

# 🍃 Veshamkett

### *Kerala's First Thrift & Fashion Discovery Platform*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)](https://github.com/PaladaPayasam/Veshamkett/releases)

**Discover thrift stores, vintage boutiques & retail chains across Kerala — right on your map.**

[⬇️ Download APK](#-download) • [✨ Features](#-features) • [🛠️ Setup](#️-local-setup) • [📸 Screenshots](#-screenshots)

</div>

---

## ⬇️ Download

> **Android users** — no Play Store needed. Just sideload the APK directly!

<div align="center">

### [📦 Download Latest APK → Releases Page](https://github.com/PaladaPayasam/Veshamkett/releases/latest)

</div>

**Installation steps:**
1. Click the link above and download `app-release.apk` from the latest release.
2. On your Android phone, go to **Settings → Security → Install Unknown Apps** and enable it for your browser/file manager.
3. Open the downloaded `.apk` file and tap **Install**.
4. Launch **Veshamkett** 🍃

> ⚠️ Minimum Android version: **Android 6.0 (Marshmallow)**

---

## ✨ Features

### 🗺️ Interactive Store Map
- Live map powered by **OpenStreetMap** pinpointing real, verified physical stores across Kerala
- **Custom category markers** — each store type gets its own icon:
  - 👗 `Thrift` stores
  - ⭐ `Vintage` boutiques  
  - 🏬 `Retail Chain` outlets
- Swipeable **bottom carousel cards** showing store info, ratings & quick actions
- One-tap **Google Maps directions** from any store card
- Filter chips to narrow results by city or category

### 🎮 Thrift Quest (Gamification)
- **GPS proximity check-in system** — earn digital badges by physically visiting stores within 50 metres
- Unlock achievements like *"Kochi Nomad"*, *"Thrift Hunter"* and more
- View your earned badge collection from the **trophy button** in the top bar
- Haptic feedback on every interaction for a tactile, premium feel

### 📸 Fit Checks Feed
- Community-powered **masonry grid feed** (Pinterest-style) for outfit photos
- Tag posts to the store where you found your fit
- Upload your own outfits directly from the app

### 🛍️ Online Shops Directory
- Curated list of Kerala-based fashion Instagram accounts & online boutiques
- **Top Rated ★** sort chip to surface the highest-reviewed shops instantly
- Live star ratings pulled dynamically from community reviews
- Direct links to **Instagram** profiles or websites

### 🔐 Secure Authentication
- Email/password sign-up & login via **Supabase Auth**
- Pick a **unique username** during registration — it shows up on your Fit Checks posts
- Session-gated access — social features are protected behind auth

---

## 🏙️ Store Coverage

| District | Store Types |
|---|---|
| **Kozhikode** | Thrift, Vintage, Retail Chains |
| **Ernakulam (Kochi)** | Thrift, Surplus, Retail, Vintage |
| **Thrissur** | Thrift, Retail Chains |
| **Malappuram** | Retail Chains |
| **Thiruvananthapuram** | Thrift, Vintage, Retail |

> All stores are **100% verified real businesses** with confirmed addresses and coordinates.

---

## 🛠️ Local Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x
- A [Supabase](https://supabase.com) project with the required schema *(see `.docs/Database_Schema.md`)*
- Android Studio or VS Code with Flutter extension

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

Create a `.env` file in the project root (this is gitignored — never commit it):
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

**4. Run the app**
```bash
flutter run
```

**5. Build a release APK**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🗄️ Database Schema

The full Supabase schema (tables, RLS policies, enums) is documented in:
📄 [`.docs/Database_Schema.md`](.docs/Database_Schema.md)

**Key tables:**
| Table | Purpose |
|---|---|
| `stores` | All store records with coordinates, category, social links |
| `reviews` | Star ratings (1–5) linked to stores & users |
| `user_achievements` | Thrift Quest badge unlocks per user |
| `fit_checks` | Community outfit posts linked to stores |

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x (Dart) |
| **Backend & Auth** | Supabase (PostgreSQL + RLS) |
| **Maps** | flutter_map + OpenStreetMap |
| **Location** | geolocator |
| **Image Caching** | cached_network_image |
| **Feed Layout** | flutter_staggered_grid_view |
| **Environment** | flutter_dotenv |
| **URL Launching** | url_launcher |

---

## 🤝 Contributing

Contributions are welcome! If you know a great thrift or vintage store in Kerala that isn't listed yet, open an issue or a pull request.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/add-store-xyz`
3. Commit your changes: `git commit -m 'Add XYZ store to Kozhikode'`
4. Push and open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with 💚 in Kerala &nbsp;|&nbsp; Built with Flutter & Supabase

**[⬆ Back to Top](#-veshamkett)**

</div>
