-- ============================================================
-- Project: SQL Inventory & Sales Performance Analysis
-- Author: Ayesha
-- Purpose: Analyze product inventory, stock valuation, supplier performance,
--          and sales metrics to optimize reorder points and sales trends.
-- ============================================================

-- 1. DATABASE SETUP & SCHEMA
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    country VARCHAR(50),
    contact_email VARCHAR(100)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(10, 2),
    quantity_in_stock INT,
    reorder_level INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE sales_orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    order_date DATE,
    quantity_sold INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. SAMPLE DATA INSERTION
INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Logistics Equipment'),
(3, 'Office Supplies');

INSERT INTO suppliers VALUES
(101, 'Global Tech Logistics', 'Spain', 'contact@gtlogistics.es'),
(102, 'Iberia Warehousing Co.', 'Spain', 'info@iberiawarehousing.es'),
(103, 'EuroSupply Express', 'Germany', 'sales@eurosupply.de');

INSERT INTO products VALUES
(1, 'Barcode Scanner Wireless', 1, 101, 85.00, 150, 30),
(2, 'Thermal Label Printer', 1, 101, 220.00, 45, 15),
(3, 'Heavy Duty Pallet Jack', 2, 102, 450.00, 12, 15),
(4, 'Inventory RFID Tags (Pack)', 2, 102, 15.00, 500, 100),
(5, 'Warehouse Safety Vests', 3, 103, 12.50, 80, 25);

INSERT INTO sales_orders VALUES
(501, 1, '2026-08-01', 10, 850.00),
(502, 2, '2026-08-03', 5, 1100.00),
(503, 3, '2026-08-05', 4, 1800.00),
(504, 1, '2026-08-10', 15, 1275.00),
(505, 4, '2026-08-12', 100, 1500.00),
(506, 5, '2026-08-15', 20, 250.00);

-- 3. ANALYTICAL QUERIES & INSIGHTS

-- Query 1: Total Inventory Value per Category
SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products,
    SUM(p.quantity_in_stock) AS total_stock_units,
    SUM(p.quantity_in_stock * p.unit_price) AS total_inventory_value_eur
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_inventory_value_eur DESC;

-- Query 2: Low Stock Alert (Products needing immediate reorder)
SELECT 
    p.product_id,
    p.product_name,
    p.quantity_in_stock,
    p.reorder_level,
    s.supplier_name,
    s.contact_email,
    CASE 
        WHEN p.quantity_in_stock <= p.reorder_level THEN 'CRITICAL: Reorder Needed'
        ELSE 'Sufficient Stock'
    END AS stock_status
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.quantity_in_stock <= p.reorder_level;

-- Query 3: Top Selling Products & Revenue Ranking (Window Function)
SELECT 
    p.product_name,
    c.category_name,
    SUM(so.quantity_sold) AS total_units_sold,
    SUM(so.total_amount) AS total_revenue_eur,
    RANK() OVER (ORDER BY SUM(so.total_amount) DESC) AS revenue_rank
FROM sales_orders so
JOIN products p ON so.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_name, c.category_name;
```[cite: 1]

5. Code paste karne ke baad, top-right par green **`Commit changes...`** button par click kar dein!
