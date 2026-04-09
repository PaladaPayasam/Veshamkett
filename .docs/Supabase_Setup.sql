-- 1. Create Enums
CREATE TYPE district_enum AS ENUM (
  'thiruvananthapuram', 'kollam', 'pathanamthitta', 'alappuzha', 
  'kottayam', 'idukki', 'ernakulam', 'thrissur', 
  'palakkad', 'malappuram', 'kozhikode', 'wayanad', 
  'kannur', 'kasaragod'
);

CREATE TYPE category_enum AS ENUM (
  'thrift', 'surplus'
);

-- 2. Create Stores Table
CREATE TABLE public.stores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    district district_enum NOT NULL,
    category category_enum NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- 3. Enable Row Level Security (RLS)
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

-- 4. Create Policy for Public Read Access
CREATE POLICY "Allow public read access on stores" 
ON public.stores 
FOR SELECT 
TO public
USING (true);

-- 5. Insert dummy data for testing the Map UI
INSERT INTO public.stores (name, latitude, longitude, district, category) VALUES
('Vintage Vibes Kochi', 9.9312, 76.2673, 'ernakulam', 'thrift'),
('Trivandrum Surplus Hub', 8.5241, 76.9366, 'thiruvananthapuram', 'surplus'),
('Calicut Thrifters', 11.2588, 75.7804, 'kozhikode', 'thrift');
