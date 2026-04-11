/*====================================================
 Script Name: 01_database_exploration.sql

 Purpose:
 - Explore database structure and metadata

 Description:
 - This script helps understand available tables and columns
 - First step before any analysis

 Key Steps:
 1. View all tables
 2. View all columns of a specific table
====================================================*/

-- View all tables
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- View columns of customer table
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
