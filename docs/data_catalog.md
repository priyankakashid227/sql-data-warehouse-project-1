# Gold Layer Data Catalog

The Gold layer is the **business-level data representation** structure to support **analytical and reporting use cases**.  
It consists of **dimension tables** and **fact tables** for specific business metrics.

---

## 1. `gold.dim_customers`

**Purpose:** Store customer details enriched with demographic and geographic data

| Column Name       | Data Type | Description |
|------------------|-----------|-------------|
| customer_key      | INT       | Surrogate key for customer (unique) |
| customer_id       | VARCHAR   | Original customer ID from source |
| first_name        | VARCHAR   | Customer first name |
| last_name         | VARCHAR   | Customer last name |
| gender            | CHAR(1)   | Customer gender (M/F) |
| dob               | DATE      | Date of birth |
| age               | INT       | Age calculated from DOB |
| email             | VARCHAR   | Customer email |
| phone             | VARCHAR   | Customer phone number |
| address           | VARCHAR   | Customer address |
| city              | VARCHAR   | City name |
| state             | VARCHAR   | State name |
| country           | VARCHAR   | Country name |
| postal_code       | VARCHAR   | Postal code / ZIP |
| registration_date | DATE      | Date customer registered |

---

## 2. `gold.dim_products`

**Purpose:** Store product details enriched with category and business info

| Column Name       | Data Type | Description |
|------------------|-----------|-------------|
| prd_key           | INT       | Surrogate product key |
| product_id        | INT       | Original product ID from source |
| product_number    | VARCHAR   | Product number / code |
| product_name      | VARCHAR   | Name of the product |
| category_id       | INT       | Category ID from source |
| category          | VARCHAR   | Category name |
| subcategory       | VARCHAR   | Sub-category name |
| maintenance       | VARCHAR   | Maintenance info |
| cost              | DECIMAL   | Product cost |
| product_line      | VARCHAR   | Product line info |
| start_date        | DATE      | Product start date |

---

## 3. `gold.dact_sales`

**Purpose:** Store transactional sales data linking **products** and **customers**

| Column Name       | Data Type | Description |
|------------------|-----------|-------------|
| order_number      | INT       | Sales order number |
| product_key       | INT       | Surrogate product key from `dim_products` |
| customer_key      | INT       | Surrogate customer key from `dim_customers` |
| order_date        | DATE      | Sales order date |
| shipping_date     | DATE      | Date of shipment |
| due_date          | DATE      | Payment due date |
| sales_amount      | DECIMAL   | Total sales value |
| quantity          | INT       | Quantity sold |
| price             | DECIMAL   | Price per unit |

---

**Notes:**  
- Surrogate keys (`customer_key`, `prd_key`) are generated for analytical purposes.  
- Gold layer tables are **ready for reporting and BI use cases**.  
- Fact table `dact_sales` links all transactions with corresponding dimensions for analytics.
