-- Migration V2: Support Online-Only Stores

-- 1. Add new columns for enhanced store metadata
ALTER TABLE public.stores
ADD COLUMN instagram_handle VARCHAR(255),
ADD COLUMN website_url VARCHAR(255),
ADD COLUMN is_online_only BOOLEAN DEFAULT false NOT NULL,
ADD COLUMN style_description TEXT,
ADD COLUMN shipping_range VARCHAR(255),
ADD COLUMN profile_image_url VARCHAR(1024);

-- 2. Relax latitude and longitude constraints to allow nulls
-- This allows online-only stores to exist safely without map coordinates
ALTER TABLE public.stores
ALTER COLUMN latitude DROP NOT NULL,
ALTER COLUMN longitude DROP NOT NULL;
