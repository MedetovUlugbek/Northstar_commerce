# NorthStar Commerce Analytics — Project Journal

**Author:** Ulugbek Medetov  
**Tools:** PostgreSQL, SQL, VS Code, Tableau  
**Dataset:** Olist Brazilian E-Commerce Dataset

## Project Overview

NorthStar Commerce Analytics is an end-to-end business intelligence portfolio project built from raw e-commerce data.

The goal is to:

- design a relational PostgreSQL database
- import and validate the source data
- answer business questions with SQL
- create reporting views
- build an executive Tableau dashboard
- present the project as a portfolio case study

## Business Problem

NorthStar Commerce needs a reliable reporting system to understand:

- merchandise-value trends
- customer activity
- product-category performance
- payment behavior
- order status
- delivery performance

The final dashboard will help management monitor business performance and identify operational issues.

## Database Structure

The project uses six tables:

- `customers`
- `orders`
- `products`
- `order_items`
- `payments`
- `category_translation`

Main relationships:

      customers
         |
         v
       orders
     /         \ 
    v           v
order_items   payments
    |
    v
products
    |
    v
category_translation

## Data Quality Validation

All six Olist source files were successfully loaded into PostgreSQL.
The database contains 99,441 orders, 112,650 order-item records,
103,886 payments, 32,951 products, and 99,441 customer records.

Referential-integrity checks found no orphan records, confirming that
all orders, products, customers, order items, and payments connect
correctly across the relational schema.

Key data-quality findings included:

- 610 products with missing category information
- 2 products with missing physical measurements
- 8 delivered orders with missing delivery timestamps
- 166 records where the carrier timestamp precedes purchase
- 23 records where customer delivery precedes carrier handoff
- 2 credit-card payment records with zero installments
- 3 undefined payment records with zero payment value
- 2 product categories without English translations

Further investigation showed that the timestamp issues vary in severity.
Most carrier-before-purchase records differ by only a few hours, but at least
two records contain much larger differences of approximately 4 days and
171 days. The 23 records where customer delivery occurs before carrier
handoff contain differences ranging from about 1 day to more than 16 days.

No source records were modified during validation. Instead, the findings
will guide the filtering and labeling rules used in future analysis.

### Implications for Future Analysis

- Merchandise-value, order-count, and customer analysis can continue to use the full
  dataset because the identified timestamp issues do not affect prices,
  payments, order ownership, or product relationships.

- Category-based analysis requires special handling because 610 products have
  no category and 2 categories have no English translation. If these records
  are excluded during joins, category merchandise value and category order counts will
  be understated. Future category queries should preserve these records and
  display a clear fallback label for missing or untranslated categories.

- Delivery-time analysis should exclude the 8 delivered orders with no
  customer delivery timestamp because delivery duration cannot be calculated
  for those records.

- Fulfillment-time analysis should exclude the 166 records where the carrier
  timestamp is earlier than the purchase timestamp. These records would
  otherwise create negative fulfillment durations and distort averages,
  medians, and minimum values.

- Shipping-time analysis should exclude the 23 records where customer delivery
  occurs before carrier handoff. These records would otherwise produce
  negative shipping durations.

- On-time delivery analysis should require both a valid customer delivery date
  and an estimated delivery date. Orders with impossible timestamp sequences
  should be excluded from the KPI denominator so they do not distort the
  on-time delivery rate.

- Product weight and dimensional analysis should exclude only the 2 products
  with missing measurements. Those products should remain included in sales,
  merchandise-value, and order analysis.

- Payment-method analysis should review the 2 zero-installment credit-card
  payments separately. Because both records have positive payment values,
  they should not be treated as missing merchandise value, but they may be excluded from
  installment-count averages.

- The 3 `not_defined` payment records have payment values of 0.00. They should
  remain in the raw data but should be excluded or shown separately when
  comparing payment-method usage or payment value.

The raw tables will remain unchanged. Any exclusions, fallback labels, or
business rules will be applied later in SQL queries and reporting views so
that the original imported data remains available for auditing.

## Foreign-Key Constraints

After validating that the imported tables contained no orphan records, foreign-key constraints were added to enforce the main database relationships:

- `orders.customer_id` references `customers.customer_id`
- `order_items.order_id` references `orders.order_id`
- `order_items.product_id` references `products.product_id`
- `payments.order_id` references `orders.order_id`

These constraints prevent future records from referencing customers, orders, or products that do not exist.

The category translation relationship was not constrained because two non-null product categories do not have matching rows in the translation table.
