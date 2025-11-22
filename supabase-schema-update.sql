-- ============================================================================
-- SCHEMA UPDATE: Add user_id and color columns
-- ============================================================================
-- This script adds the missing user_id column to all tables and color to categories
-- Run this AFTER running the initial supabase-schema.sql
-- 
-- IMPORTANT: You need to replace 'YOUR_USER_ID_HERE' with your actual user UUID
-- To get your user ID, run this query first:
-- SELECT id FROM auth.users WHERE email = 'your-email@example.com';
-- ============================================================================

-- Drop existing RLS policies for categories
DROP POLICY IF EXISTS "Authenticated users can view categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users can create categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users can update categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users can delete categories" ON categories;

-- Add color and user_id columns to categories
ALTER TABLE categories 
  ADD COLUMN IF NOT EXISTS color VARCHAR(7) DEFAULT '#3B82F6',
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Update existing categories with a user_id (replace with your actual user ID)
-- UPDATE categories SET user_id = 'YOUR_USER_ID_HERE' WHERE user_id IS NULL;

-- Make user_id NOT NULL after updating existing rows
-- ALTER TABLE categories ALTER COLUMN user_id SET NOT NULL;

-- Create new RLS policies for categories
CREATE POLICY "Users can view their own categories" ON categories
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own categories" ON categories
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own categories" ON categories
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own categories" ON categories
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- Update suppliers table
-- ============================================================================

-- Drop existing RLS policies for suppliers
DROP POLICY IF EXISTS "Authenticated users can view suppliers" ON suppliers;
DROP POLICY IF EXISTS "Authenticated users can create suppliers" ON suppliers;
DROP POLICY IF EXISTS "Authenticated users can update suppliers" ON suppliers;
DROP POLICY IF EXISTS "Authenticated users can delete suppliers" ON suppliers;

-- Add user_id column to suppliers
ALTER TABLE suppliers 
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Update existing suppliers with a user_id (replace with your actual user ID)
-- UPDATE suppliers SET user_id = 'YOUR_USER_ID_HERE' WHERE user_id IS NULL;

-- Make user_id NOT NULL after updating existing rows
-- ALTER TABLE suppliers ALTER COLUMN user_id SET NOT NULL;

-- Create new RLS policies for suppliers
CREATE POLICY "Users can view their own suppliers" ON suppliers
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own suppliers" ON suppliers
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own suppliers" ON suppliers
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own suppliers" ON suppliers
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- Update products table
-- ============================================================================

-- Drop existing RLS policies for products
DROP POLICY IF EXISTS "Authenticated users can view products" ON products;
DROP POLICY IF EXISTS "Authenticated users can create products" ON products;
DROP POLICY IF EXISTS "Authenticated users can update products" ON products;
DROP POLICY IF EXISTS "Authenticated users can delete products" ON products;

-- Add user_id column to products
ALTER TABLE products 
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Update existing products with a user_id (replace with your actual user ID)
-- UPDATE products SET user_id = 'YOUR_USER_ID_HERE' WHERE user_id IS NULL;

-- Make user_id NOT NULL after updating existing rows
-- ALTER TABLE products ALTER COLUMN user_id SET NOT NULL;

-- Create new RLS policies for products
CREATE POLICY "Users can view their own products" ON products
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own products" ON products
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own products" ON products
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own products" ON products
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- Update stock_movements table
-- ============================================================================

-- Drop existing RLS policies for stock_movements
DROP POLICY IF EXISTS "Authenticated users can view stock movements" ON stock_movements;
DROP POLICY IF EXISTS "Authenticated users can create stock movements" ON stock_movements;

-- Add user_id column to stock_movements
ALTER TABLE stock_movements 
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- Update existing stock movements with a user_id (replace with your actual user ID)
-- UPDATE stock_movements SET user_id = 'YOUR_USER_ID_HERE' WHERE user_id IS NULL;

-- Make user_id NOT NULL after updating existing rows
-- ALTER TABLE stock_movements ALTER COLUMN user_id SET NOT NULL;

-- Create new RLS policies for stock_movements
CREATE POLICY "Users can view their own stock movements" ON stock_movements
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own stock movements" ON stock_movements
  FOR INSERT WITH CHECK (auth.uid() = user_id);
