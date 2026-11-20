# BookVerse Retail Business Intelligence & Sales Analytics

A MySQL business analytics project exploring bookstore sales, customer purchasing behaviour, product and genre performance, and inventory position.

## Project overview

BookVerse Retail Pvt. Ltd. is a fictional online and offline bookstore. This project uses relational database design, data validation, and SQL analysis to turn its catalog, customer, and order data into business insights.

**Role:** Junior Data Analyst  
**Tools:** MySQL, MySQL Workbench, SQL, CSV datasets

## Business objectives

- Measure sales performance, order volume, units sold, and sales trends.
- Understand customer activity, repeat purchasing, customer value, and geography.
- Compare books, authors, and genres using sales quantity and recorded revenue.
- Review stock levels and estimate catalog-price inventory value.
- Identify titles that may merit replenishment or slow-moving-stock review.

## Database design

The database is named `BookVerse_DB` and contains three related tables:

| Table | Purpose | Primary key |
|---|---|---|
| `Books` | Book catalog, genre, price, and stock | `Book_ID` |
| `Customers` | Customer profile and location | `Customer_ID` |
| `Orders` | Order date, quantity, and recorded amount | `Order_ID` |

The `Orders` table references `Customers` through `Customer_ID` and `Books` through `Book_ID`.

## Dataset and validation

The project presentation reports 500 rows in each core table (1,500 total). The supplied order data covers **9 December 2022 to 7 December 2024**.

The final imported tables were checked for record counts, missing values, duplicate IDs and full rows, and referential integrity. The reported validation results were:
- 0 missing values across the three final tables.
- 0 duplicate IDs and 0 duplicate full rows.
- 0 order records with a missing customer or book reference.

## Selected findings

Based on the supplied dataset and the project's SQL analysis:

- 500 order records represent **2,697 units sold** and **75,628.66** in recorded sales amount.
- Average order amount: **151.26**.
- **307** customers appear in the order data; **139** of those active customers placed more than one order.
- Romance had the highest recorded genre sales amount (**13,086.98**), followed by Mystery (**12,788.45**).
- **64** titles had stock of 10 units or fewer; **5** titles had zero stock.
- **183** catalog titles did not appear in the supplied order records.

> Amounts are shown as recorded in the source data; no currency symbol was specified. Inventory value is an analytical estimate based on catalog price multiplied by stock, not an accounting valuation. Replenishment and slow-moving-stock examples are review candidates, not automatic decisions.

## Business recommendations

1. Review high-selling titles with low current stock before procurement.
2. Investigate titles with high stock and low observed sales, considering margin and demand context.
3. Monitor Romance and Mystery performance alongside inventory mix.
4. Build customer-retention reporting around repeat and one-time buyers.
5. Maintain reusable SQL queries for sales, customer activity, genre performance, and stock exceptions.

## Repository contents

This repository is being organized to include the database setup, analytical SQL, project documentation, and supporting material. Only files that are available and verified will be added.

## Project scope note

The project brief lists a Power BI dashboard as a possible deliverable. The available project presentation documents SQL analysis and findings; it does not establish that a Power BI dashboard was completed.

## Team

- **Team Leader:** Sakkam Meghana
- **Team Member:** Padavala Bhargav Kumar

---

*BookVerse Retail BI & Sales Analytics — MySQL Business Analytics Project.*
