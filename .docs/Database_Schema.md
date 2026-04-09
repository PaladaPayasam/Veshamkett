# Database Schema Proposal (Supabase)

## Overview
The application uses PostgreSQL (via Supabase Free Tier) to store the physical locations and metadata of thrift and surplus fashion stores in Kerala.

## Table: `stores`

This table houses the necessary information for displaying locations on the interactive map.

| Column      | Data Type          | Description                                                    | Constraints               |
|-------------|--------------------|----------------------------------------------------------------|---------------------------|
| `id`        | UUID               | Unique identifier for the store.                               | Primary Key, Default uuid |
| `name`      | VARCHAR(255)       | The commercial name of the store.                              | Not Null                  |
| `latitude`  | DOUBLE PRECISION   | Mapping coordinate (Latitude).                                 | Not Null                  |
| `longitude` | DOUBLE PRECISION   | Mapping coordinate (Longitude).                                | Not Null                  |
| `district`  | VARCHAR(100)       | Kerala district where the store is located.                  | Not Null                  |
| `category`  | VARCHAR(50)        | Distinction between store types: `Thrift` or `Surplus`.        | Not Null                  |
| `created_at`| TIMESTAMPTZ        | Auto-generated record creation timestamp.                      | Default now()             |

## Additional Considerations
- **Row Level Security (RLS)**: The `stores` table should have RLS enabled with a policy that allows *public read access* (`SELECT`) so the mobile app can query it without requiring user authentication. Mutations (`INSERT`, `UPDATE`, `DELETE`) should be restricted to authenticated administrative accounts.
- **District Constraint Check**: To ensure data cleanliness, the `district` column can be validated against the 14 districts of Kerala (Thiruvananthapuram, Kollam, Pathanamthitta, Alappuzha, Kottayam, Idukki, Ernakulam, Thrissur, Palakkad, Malappuram, Kozhikode, Wayanad, Kannur, Kasaragod).
- **Geospatial Processing**: If radius-based searches are needed in the future, PostGIS can be activated on Supabase to introduce `geography` point types. For simple marker plotting, raw Latitude and Longitude floats are adequate.
