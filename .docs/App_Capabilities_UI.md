# Veshamkett: App Capabilities & UI Architecture

## Overview
Veshamkett is a hybrid discovery platform designed to connect users to thrift, surplus, streetwear, and vintage vendors across Kerala. The application cleanly splits into two core experiences: a dynamic **Local Map Discovery** tool for brick-and-mortar storefronts, and a curated **Online Shops** marketplace for digital boutiques.

---

## What the App Can Do (Core Features)

1. **Intelligent Store Filtering**:
   - Separates stores automatically by physical location vs. "Online Only" fulfillment.
   - Offers live, real-time string searching. Typing a store name or a district instantly filters down the map layout and bottom carousels without network latency.
   - Users can toggle styling Categories (e.g., Thrift, Surplus, Vintage) utilizing quick-action filter chips.

2. **CartoDB Geospatial Navigation**:
   - Integrates `flutter_map` tied explicitly to high-performance CartoDB mapping servers, removing API dependency costs.
   - Parses `latitude` and `longitude` coordinate structures directly from Supabase rendering interactive custom markers.
   - Automatically asks for GPS permissions and centers on the smartphone's actual physical location when prompted via the Action Button.

3. **Synchronous Panning Architecture**:
   - Bi-directional interactions: Selecting a physical store marker seamlessly snaps the interactive carousel list to focus heavily on that store.
   - Conversely, swiping through the digital carousel smoothly animates the underlying camera to track across the map in the background.

4. **Universal Actions ("Intent" Launching)**:
   - Evaluates a store's remote URLs securely (e.g. Instagram profiles, Website links) and safely hands off routing tasks directly to native iOS and Android environments using `url_launcher`.
   - Embeds a universal "Get Directions" trigger pushing location tracking into Google Maps native direction algorithms.

5. **Cloud-Native Data Seeding**:
   - Synchronized permanently to a serverless **Supabase PostgreSQL** instance, tracking names, coordinates, and real-time scraped storefront photography.

---

## UI/UX Theming System (Modern Vintage)

The entire presentation layer relies on a context-aware `System Mode` that perfectly listens to the phone's native brightness capabilities, toggling fluidly at the push of the Top-Bar button.

### 1. **Light Mode Palette**
* **Scaffold & Base**: Crisp Unaltered White (`#FFFFFF`).
* **Interactive Elements (Cards)**: Smooth Off-White / Cream (`#FAF9F6`).
* **Map Engine**: Bright Topography via CartoDB `voyager`.
* **Accents**: Earthy organic Forest Green (`#2E8B57`) mapping standard user texts using a Deep Charcoal block tint.

### 2. **Dark Mode Palette**
* **Scaffold & Base**: Restful Deep Charcoal (`#121212`).
* **Interactive Elements (Cards)**: Elevated Mid-Grey (`#2C2C2C`) allowing depth perception above the core background without blurring.
* **Map Engine**: Inverted Moody Dark mapping via CartoDB `dark_all`.
* **Accents**: Brightened Organic Green (`#48A672`) ensuring high contour contrast, while all standard typography flips to Off-White (`#ECECEC`).

### Typography & Flourishes
- All font-rendering uses Google Fonts highly editorial **`Montserrat`** codebase. 
- High-blur radius Box Shadows (e.g. `BoxShadow(blurRadius: 20, color: Colors.black12)`) cause search widgets to visually "float" above mapping layers.
- Social media call-to-actions are generated programmatically (e.g. The Instagram camera icon draws from an exact localized CSS linear gradient).

---

## Screen Architecture

### 1. The Global Scaffold (`main_screen.dart`)
- **AppBar**: Contains the persistent dynamic Theme Toggle (Sun/Moon switch) and a structural TabBar switching strictly between the Map mode and the Online mode, completely locking out lateral swiping to preserve map-pan gestures.

### 2. Local Map View (`map_screen.dart`)
- Built heavily utilizing `Stack` positioning constraints. 
- **The Base**: Generates the Map layer strictly underneath everything.
- **Top Safe Area**: Floats the heavy-styled rounded Search Bar and the horizontal scrolling Categories row natively tracking the user's thumb area.
- **Bottom Safe Area**: Anchors the PageView Builder forcing a `0.85` relative viewport. This peeks adjacent store cards slightly out from the screen edges hinting at swipe capabilities. 

### 3. Online Stores List (`online_store_list_screen.dart`)
- Abandons geographic mapping in favor of an optimized, classic `ListView`.
- Incorporates dynamic fallbacks for media. Instead of an ugly "Image Not Supported" state—if Supabase rejects or misses an image payload, the code structures a smooth padded `Icons.storefront` fallback retaining visual integrity.
