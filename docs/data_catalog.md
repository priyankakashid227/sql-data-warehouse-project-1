# Gold Layer Data Catalog

The Gold layer is the **business-level data representation** structure to support **analytical and reporting use cases**.  
It consists of **dimension tables** and **fact tables** for specific business metrics.

---

## 1. `gold.dim_customers`

**Purpose:** Store customer details enriched with demographic and geographic data

| Column Name       | Data Type       | Description |
|------------------|----------------|-------------|
| customer_key      | INT            | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id       | INT            | Unique numerical identifier assigned to each customer. |
| customer_number   | VARCHAR(50)    | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name        | VARCHAR(50)    | The customer's first name, as recorded in the system. |
| last_name         | VARCHAR(50)    | The customer's last name (family name). |
| country           | VARCHAR(50)    | The country of residence for the customer (e.g., 'Australia'). |
| marital_status    | VARCHAR(50)    | The marital status of the customer (e.g., 'Married', 'Single'). |
| gender            | VARCHAR(50)    | The gender of the customer (e.g., 'Male', 'Female', 'N/A'). |
| birthdate         | DATE           | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). |
| create_date       | DATE           | The date and time when the customer record was created in the system. |

---

## 2. `gold.dim_products`

**Purpose:** Store product details enriched with category and business info

| Column Name       | Data Type       | Description |
|------------------|----------------|-------------|
| prd_key           | INT            | Surrogate product key uniquely identifying each product record in the dimension table. |
| product_id        | INT            | Original product ID from source system. |
| product_number    | VARCHAR(50)    | Product code or number used for tracking and reference. |
| product_name      | VARCHAR(100)   | Name of the product. |
| category_id       | INT            | Original category ID from source system. |
| category          | VARCHAR(50)    | Name of the product category. |
| subcategory       | VARCHAR(50)    | Name of the sub-category under the main category. |
| maintenance       | VARCHAR(50)    | Maintenance information associated with the product. |
| cost              | DECIMAL(18,2)  | Cost of the product. |
| product_line      | VARCHAR(50)    | Product line or group to which the product belongs. |
| start_date        | DATE           | Product start date or the date it became available in the system. |

---

## 3. `gold.dact_sales`

**Purpose:** Store transactional sales data linking **products** and **customers**

| Column Name       | Data Type       | Description |
|------------------|----------------|-------------|
| order_number      | INT            | Sales order number. |
| product_key       | INT            | Surrogate product key referencing `dim_products`. |
| customer_key      | INT            | Surrogate customer key referencing `dim_customers`. |
| order_date        | DATE           | Date when the order was placed. |
| shipping_date     | DATE           | Date when the order was shipped. |
| due_date          | DATE           | Payment due date for the order. |
| sales_amount      | DECIMAL(18,2)  | Total amount of the order. |
| quantity          | INT            | Number of units sold in the order. |
| price             | DECIMAL(18,2)  | Price per unit of product sold. |

---

**Notes:**  
- Surrogate keys (`customer_key`, `prd_key`) are generated for analytical purposes.  
- Gold layer tables are **ready for reporting and BI use cases**.  
- Fact table `dact_sales` links all transactions with corresponding dimension tables for analytics.  
- All columns have descriptive names and data types aligned for business understanding.
