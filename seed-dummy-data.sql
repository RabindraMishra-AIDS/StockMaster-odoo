-- ============================================================================
-- DUMMY DATA FOR STOCKMASTER - SEED FILE
-- ============================================================================
-- Run this in Supabase SQL Editor AFTER running supabase-schema.sql
-- This will populate your database with sample data to test the application
-- ============================================================================
-- IMPORTANT: Replace 'YOUR_USER_ID_HERE' with your actual user ID from auth.users
-- You can find it by running: SELECT id FROM auth.users WHERE email = 'your-email@example.com';
-- ============================================================================

-- Set your user ID here (replace with actual UUID from auth.users)
DO $$
DECLARE
    v_user_id UUID;
BEGIN
    -- Get the first user's ID (you can change this to match your email)
    SELECT id INTO v_user_id FROM auth.users LIMIT 1;
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'No user foundQ! Please create an account first, then run this script.';
    END IF;
    
    RAISE NOTICE 'Using user ID: %', v_user_id;

-- ============================================================================
-- 1. INSERT CATEGORIES
-- ============================================================================
INSERT INTO categories (id, name, description, color, user_id, created_at, updated_at) VALUES
    (gen_random_uuid(), 'Electronics', 'Electronic devices and accessories', '#3B82F6', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Furniture', 'Office and home furniture', '#8B5CF6', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Office Supplies', 'Stationery and office essentials', '#10B981', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Clothing', 'Apparel and fashion items', '#EF4444', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Books', 'Books and educational materials', '#F59E0B', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Food & Beverages', 'Food items and drinks', '#06B6D4', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Sports Equipment', 'Sports and fitness gear', '#EC4899', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Tools & Hardware', 'Tools and hardware supplies', '#14B8A6', v_user_id, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 2. INSERT SUPPLIERS
-- ============================================================================
INSERT INTO suppliers (id, name, contact_email, contact_phone, address, user_id, created_at, updated_at) VALUES
    (gen_random_uuid(), 'Tech World Distributors', 'sales@techworld.com', '+1-555-0101', '123 Tech Street, Silicon Valley, CA 94025', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Furniture Plus Inc.', 'orders@furnitureplus.com', '+1-555-0102', '456 Comfort Ave, New York, NY 10001', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Office Essentials Co.', 'info@officeessentials.com', '+1-555-0103', '789 Business Blvd, Chicago, IL 60601', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Fashion Hub Wholesale', 'contact@fashionhub.com', '+1-555-0104', '321 Style Street, Los Angeles, CA 90001', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'BookMart Publishers', 'sales@bookmart.com', '+1-555-0105', '654 Reading Road, Boston, MA 02101', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Global Food Suppliers', 'orders@globalfood.com', '+1-555-0106', '987 Market Place, Seattle, WA 98101', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Sports Gear International', 'info@sportsgear.com', '+1-555-0107', '147 Fitness Lane, Denver, CO 80201', v_user_id, NOW(), NOW()),
    (gen_random_uuid(), 'Hardware & Tools Ltd.', 'sales@hardwaretools.com', '+1-555-0108', '258 Industrial Way, Detroit, MI 48201', v_user_id, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 3. INSERT PRODUCTS
-- ============================================================================
-- Electronics
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Wireless Mouse',
    'TECH-WM-001',
    (SELECT id FROM categories WHERE name = 'Electronics' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Tech World Distributors' AND user_id = v_user_id LIMIT 1),
    20.00,
    29.99,
    150,
    20,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'TECH-WM-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'USB-C Hub',
    'TECH-HUB-002',
    (SELECT id FROM categories WHERE name = 'Electronics' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Tech World Distributors' AND user_id = v_user_id LIMIT 1),
    35.00,
    49.99,
    75,
    15,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'TECH-HUB-002' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Bluetooth Headphones',
    'TECH-HP-003',
    (SELECT id FROM categories WHERE name = 'Electronics' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Tech World Distributors' AND user_id = v_user_id LIMIT 1),
    60.00,
    89.99,
    45,
    10,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'TECH-HP-003' AND user_id = v_user_id);

-- Furniture
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Ergonomic Office Chair',
    'FURN-CH-001',
    (SELECT id FROM categories WHERE name = 'Furniture' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Furniture Plus Inc.' AND user_id = v_user_id LIMIT 1),
    200.00,
    299.99,
    25,
    5,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'FURN-CH-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Standing Desk',
    'FURN-DSK-002',
    (SELECT id FROM categories WHERE name = 'Furniture' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Furniture Plus Inc.' AND user_id = v_user_id LIMIT 1),
    350.00,
    499.99,
    12,
    3,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'FURN-DSK-002' AND user_id = v_user_id);

-- Office Supplies
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Printer Paper A4 (500 sheets)',
    'OFF-PP-001',
    (SELECT id FROM categories WHERE name = 'Office Supplies' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Office Essentials Co.' AND user_id = v_user_id LIMIT 1),
    6.00,
    8.99,
    200,
    30,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'OFF-PP-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Ballpoint Pens (Pack of 10)',
    'OFF-PEN-002',
    (SELECT id FROM categories WHERE name = 'Office Supplies' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Office Essentials Co.' AND user_id = v_user_id LIMIT 1),
    4.00,
    5.99,
    8,
    20,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'OFF-PEN-002' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Sticky Notes Set',
    'OFF-STK-003',
    (SELECT id FROM categories WHERE name = 'Office Supplies' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Office Essentials Co.' AND user_id = v_user_id LIMIT 1),
    9.00,
    12.99,
    0,
    25,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'OFF-STK-003' AND user_id = v_user_id);

-- Clothing
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Cotton T-Shirt (M)',
    'CLO-TS-001',
    (SELECT id FROM categories WHERE name = 'Clothing' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Fashion Hub Wholesale' AND user_id = v_user_id LIMIT 1),
    12.00,
    19.99,
    120,
    30,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'CLO-TS-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Denim Jeans (32x32)',
    'CLO-JN-002',
    (SELECT id FROM categories WHERE name = 'Clothing' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Fashion Hub Wholesale' AND user_id = v_user_id LIMIT 1),
    35.00,
    49.99,
    65,
    15,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'CLO-JN-002' AND user_id = v_user_id);

-- Books
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'JavaScript: The Definitive Guide',
    'BOOK-JS-001',
    (SELECT id FROM categories WHERE name = 'Books' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'BookMart Publishers' AND user_id = v_user_id LIMIT 1),
    45.00,
    59.99,
    35,
    10,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'BOOK-JS-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Clean Code',
    'BOOK-CC-002',
    (SELECT id FROM categories WHERE name = 'Books' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'BookMart Publishers' AND user_id = v_user_id LIMIT 1),
    32.00,
    44.99,
    28,
    8,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'BOOK-CC-002' AND user_id = v_user_id);

-- Food & Beverages
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Organic Coffee Beans (1kg)',
    'FOOD-CF-001',
    (SELECT id FROM categories WHERE name = 'Food & Beverages' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Global Food Suppliers' AND user_id = v_user_id LIMIT 1),
    18.00,
    24.99,
    85,
    20,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'FOOD-CF-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Green Tea (100 bags)',
    'FOOD-GT-002',
    (SELECT id FROM categories WHERE name = 'Food & Beverages' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Global Food Suppliers' AND user_id = v_user_id LIMIT 1),
    10.00,
    14.99,
    110,
    25,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'FOOD-GT-002' AND user_id = v_user_id);

-- Sports Equipment
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Yoga Mat',
    'SPORT-YM-001',
    (SELECT id FROM categories WHERE name = 'Sports Equipment' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Sports Gear International' AND user_id = v_user_id LIMIT 1),
    28.00,
    39.99,
    55,
    15,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'SPORT-YM-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Dumbbells Set (2x10kg)',
    'SPORT-DB-002',
    (SELECT id FROM categories WHERE name = 'Sports Equipment' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Sports Gear International' AND user_id = v_user_id LIMIT 1),
    55.00,
    79.99,
    18,
    5,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'SPORT-DB-002' AND user_id = v_user_id);

-- Tools & Hardware
INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Cordless Drill',
    'TOOL-DR-001',
    (SELECT id FROM categories WHERE name = 'Tools & Hardware' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Hardware & Tools Ltd.' AND user_id = v_user_id LIMIT 1),
    90.00,
    129.99,
    22,
    8,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'TOOL-DR-001' AND user_id = v_user_id);

INSERT INTO products (id, name, sku, category_id, supplier_id, cost_price, selling_price, quantity, reorder_level, user_id, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'Screwdriver Set (20-piece)',
    'TOOL-SD-002',
    (SELECT id FROM categories WHERE name = 'Tools & Hardware' AND user_id = v_user_id LIMIT 1),
    (SELECT id FROM suppliers WHERE name = 'Hardware & Tools Ltd.' AND user_id = v_user_id LIMIT 1),
    24.00,
    34.99,
    42,
    12,
    v_user_id,
    NOW(),
    NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE sku = 'TOOL-SD-002' AND user_id = v_user_id);

-- ============================================================================
-- 4. INSERT STOCK MOVEMENTS (Sample history)
-- ============================================================================
-- Recent stock IN movements
INSERT INTO stock_movements (id, product_id, type, quantity, notes, user_id, created_at)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM products WHERE sku = 'TECH-WM-001' AND user_id = v_user_id LIMIT 1),
    'in',
    50,
    'New stock delivery - PO-2024-001 from Tech World Distributors',
    v_user_id,
    NOW() - INTERVAL '5 days'
WHERE EXISTS (SELECT 1 FROM products WHERE sku = 'TECH-WM-001' AND user_id = v_user_id);

INSERT INTO stock_movements (id, product_id, type, quantity, notes, user_id, created_at)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM products WHERE sku = 'OFF-PP-001' AND user_id = v_user_id LIMIT 1),
    'in',
    100,
    'Bulk purchase - PO-2024-002 Office supplies restocking',
    v_user_id,
    NOW() - INTERVAL '4 days'
WHERE EXISTS (SELECT 1 FROM products WHERE sku = 'OFF-PP-001' AND user_id = v_user_id);

-- Recent stock OUT movements
INSERT INTO stock_movements (id, product_id, type, quantity, notes, user_id, created_at)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM products WHERE sku = 'CLO-TS-001' AND user_id = v_user_id LIMIT 1),
    'out',
    30,
    'Customer order SO-2024-001 - Shipped to ABC Corp',
    v_user_id,
    NOW() - INTERVAL '3 days'
WHERE EXISTS (SELECT 1 FROM products WHERE sku = 'CLO-TS-001' AND user_id = v_user_id);

INSERT INTO stock_movements (id, product_id, type, quantity, notes, user_id, created_at)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM products WHERE sku = 'FOOD-CF-001' AND user_id = v_user_id LIMIT 1),
    'out',
    15,
    'Internal use INT-2024-001 - Office pantry supply',
    v_user_id,
    NOW() - INTERVAL '2 days'
WHERE EXISTS (SELECT 1 FROM products WHERE sku = 'FOOD-CF-001' AND user_id = v_user_id);

INSERT INTO stock_movements (id, product_id, type, quantity, notes, user_id, created_at)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM products WHERE sku = 'OFF-PEN-002' AND user_id = v_user_id LIMIT 1),
    'in',
    16,
    'Stock adjustment ADJ-2024-001 - Physical count correction',
    v_user_id,
    NOW() - INTERVAL '1 day'
WHERE EXISTS (SELECT 1 FROM products WHERE sku = 'OFF-PEN-002' AND user_id = v_user_id);

RAISE NOTICE '✅ Dummy data inserted successfully!';
RAISE NOTICE '📊 Categories: 8';
RAISE NOTICE '🏢 Suppliers: 8';
RAISE NOTICE '📦 Products: 20';
RAISE NOTICE '📈 Stock Movements: 5';
RAISE NOTICE '';
RAISE NOTICE '🎉 You can now test the application with sample data!';

END $$;
