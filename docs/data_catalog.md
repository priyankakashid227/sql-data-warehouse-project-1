# Gold Layer Data Catalog

The Gold layer is the business-level data representation structure to support analytical and reporting use cases.
It consists of dimension tables and fact tables for specific business metrics.

## 1. gold.dim_customers
Purpose: Store customer details enriched with demographic and geographic data

| Column Name      | Data Type     | Description |
|-----------------|--------------|-------------|
| customer_key    | INT          | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id     | INT          | Unique numerical identifier assigned to each customer. |
| customer_number | VARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name      | VARCHAR(50)  | The customer's first name, as recorded in the system. |
| last_name       | VARCHAR(50)  | The customer's last name (family name). |
| country         | VARCHAR(50)  | The country of residence for the customer (e.g., 'Australia'). |
| marital_status  | VARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single'). |
| gender          | VARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'N/A'). |
| birthdate       | DATE         | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). |
| create_date     | DATE         | The date and time when the customer record was created in the system. |

---

## 2. gold.dim_products
Purpose: Provide information about the products and their attributes

| Column Name           | Data Type     | Description |
|----------------------|--------------|-------------|
| products_key         | INT          | Surrogate key uniquely identifying each product record in the products dimension table. |
| products_id          | INT          | A unique identifier assigned to the product for internal tracking and referencing. |
| product_number       | VARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name         | VARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size. |
| category_id          | VARCHAR(50)  | A unique identifier for the product's category linking to its high-level classification. |
| category             | VARCHAR(50)  | The broader classification of the product (e.g., Bike, Components) to group related items. |
| subcategory          | VARCHAR(50)  | A more detailed classification of the products within the category. |
| maintenance_required | VARCHAR(50)  | Indicates whether the product requires maintenance (e.g., Yes, No). |
| cost                 | INT          | The cost or base price of the product. |
| product_line         | VARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain). |
| start_date           | DATE         | The date when the product becomes available for sale or use, as recorded in the system. |

---

## 3. gold.fact_sales
Purpose: Stores transactional sales data for analytical purposes

| Column Name    | Data Type       | Description |
|---------------|----------------|-------------|
| order_number  | VARCHAR(50)    | A unique alphanumeric identifier for each sales order (e.g., 'S054496'). |
| products_key  | INT            | Surrogate key linking the order to the dim_products dimension table. |
| customer_key  | INT            | Surrogate key linking the order to the dim_customers dimension table. |
| order_date    | DATE           | The date when the order was placed. |
| shipping_date | DATE           | The date when the order was shipped. |
| due_date      | DATE           | The date when the payment for the order was due. |
| sales_amount  | INT            | The total monetary value of the sales for the line item, in whole currency units (e.g., 25). |
| quantity      | INT            | The number of units of the product ordered for the line item (e.g., 1). |
| price         | INT            | The price per unit of the product for the line item, in whole currency units (e.g., 25). |

---

## Notes:

- Surrogate keys (customer_key, products_key) are generated for analytical purposes.
- Gold layer tables are ready for reporting and BI use cases.
- Fact tables (fact_sales) link all transactions with corresponding dimension tables for analytics.
- All columns have descriptive names and data types aligned for business understanding.
