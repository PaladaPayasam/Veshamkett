# Product Requirements Document (PRD): Veshamkett

## 1. Overview
**Veshamkett** is a mobile application built in Flutter designed to help users find thrift and surplus fashion stores across Kerala. By eliminating map API costs and utilizing free-tier backend services, the application operates at zero cost while providing an accessible platform for fashion enthusiasts and eco-conscious shoppers.

## 2. Target Audience
- Fashion enthusiasts in Kerala looking for budget-friendly styles.
- Eco-conscious consumers interested in sustainable/thrift shopping.
- Students and young adults seeking surplus fashion items.

## 3. Key Features (MVP)
- **Interactive Map**: A map-based discovery interface using OpenStreetMap (via `flutter_map`) to locate stores without relying on paid map services.
- **Store Discovery & Filtering**: Browse stores organized by category (Thrift/Surplus) and geographical location (Kerala Districts).
- **Store Details**: View essential information including store name, location (latitude/longitude), district, and category.

## 4. Technical Constraints
- **Framework**: Flutter (for cross-platform compatibility).
- **Backend/Database**: Supabase (Free Tier for data storage).
- **Map Integration**: OpenStreetMap using the `flutter_map` package (Zero-cost API).

## 5. Out of Scope for MVP
- User authentication/social logins.
- E-commerce functionality (in-app cart/purchasing).
- Store management portals (users cannot add stores from the app yet).
