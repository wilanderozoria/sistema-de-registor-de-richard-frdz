---
name: abarrotes-punto-de-venta
description: >
  Use this skill when designing, implementing, auditing, or extending a retail
  point-of-sale/inventory system inspired by the publicly documented
  Abarrotes Punto de Venta (AbarrotesPDV) 6 feature set. Covers sales, products,
  customers, inventory, cash cuts, reports, invoices, configuration, peripherals,
  multi-company/multi-user operation, keyboard workflows, and data integrity.
  Treat this as a functional reference, not as a request to copy proprietary
  source code, branding, assets, or implementation.
---

# Abarrotes Punto de Venta — Functional Reference Skill

## Mission

When this skill is active, act as a senior POS/product engineer familiar with the
publicly documented functionality of Abarrotes Punto de Venta (AbarrotesPDV) 6.
Use the feature model below as a reference when planning or implementing a POS.

Important:
- Reproduce functional concepts, not proprietary source code.
- Do not copy AbarrotesPDV/Elevanta branding, logos, screenshots, text, or source code.
- If a requested feature is not confirmed by the public documentation below,
  mark it as `UNCONFIRMED` instead of inventing behavior.
- Prefer a clean, modern implementation suitable for the user's own product.
- Preserve existing project architecture unless a migration is explicitly requested.

## Product model

AbarrotesPDV is a Windows desktop point-of-sale system focused on retail/abarrotes.
Public documentation identifies these major areas:

1. Sales
2. Customers
3. Products
4. Inventory
5. Purchases / suppliers where applicable to the related product ecosystem
6. Invoices / fiscal documents
7. Cash cuts
8. Reports
9. Configuration
10. Peripheral devices
11. Backup/maintenance
12. Multi-company / multi-user / multi-cash-register capabilities

The AbarrotesPDV 6 public development tracker explicitly lists many of these
modules and individual controls/features.

## Core sales workflow

The sales screen should be designed for very fast cashier operation.

### Product entry

Support the documented concepts:
- Product barcode/code entry
- Add product with Enter
- Product search
- Product list
- Common/manual article entry
- Quantity and line-item handling
- Delete selected item
- Wholesale pricing mode
- Inventory entry/exit shortcuts where applicable
- Product verifier
- Recover previous tickets
- Put a ticket on hold / waiting
- Resume a waiting ticket
- Charge/checkout
- Current ticket total
- Same-day ticket/devolution access

Documented keyboard concepts include:
- `F10` search
- `F11` wholesale
- `F7` inventory entries
- `F8` inventory exits
- `F9` verifier
- `F5` recover tickets
- `F6` ticket on hold
- `F12` charge
- `DEL` remove article
- `CTRL+P` common article
- `ENTER` add product

Do not blindly copy shortcuts if they conflict with the host application's
existing shortcuts. Preserve the user-facing concept first.

### Checkout

The checkout layer should support:
- Cart subtotal
- Discounts/promotions when enabled
- Taxes when enabled
- Final total
- Payment method selection
- Amount received
- Change calculation
- Ticket generation/printing
- Association of a sale with a customer when applicable
- Credit sale when credit is enabled
- Sale history/recovery

If a payment method is not explicitly confirmed in the current project, implement
it through a configurable payment-method registry instead of hard-coding it.

## Products / catalog

Provide a product catalog with:
- Create product
- Edit product
- Delete/deactivate product
- Search product
- Barcode/code
- Product name
- Sale price
- Cost price
- Current stock
- Minimum stock
- Category
- Unit of measure
- Tax configuration where applicable
- Product status
- Optional wholesale price
- Optional promotional price/rules

The public AbarrotesPDV 6 tracker explicitly lists:
- New
- Modify
- Delete
- Categories
- Sold articles report
- Promotions
- Import
- Catalog
- Product search by article, sale price, code, and stock

### Bulk import

Design import as a safe transactional operation:
1. Parse source data.
2. Validate required fields.
3. Detect duplicate barcodes/codes.
4. Preview changes.
5. Let the user confirm.
6. Write changes atomically.
7. Produce an import result/error report.

Excel/CSV import is a known capability in the related Eleventa product
documentation; if implemented, keep the importer format configurable.

## Categories

Products should support categories/groups.

Category operations:
- Create
- Rename/edit
- Deactivate/delete only when safe
- Assign products
- Filter/report by category

Never allow deletion of a category that would orphan products without an
explicit reassignment strategy.

## Customers

Customer management should support the documented concepts:
- Customer catalog
- New customer
- Modify customer
- Delete/deactivate customer
- Account statement
- Customer balances report

For credit-enabled systems, maintain:
- Credit limit (optional)
- Current balance
- Transaction history
- Payments
- Credit sales
- Returns/adjustments

Every balance-affecting operation must create an immutable ledger entry.

## Inventory

Inventory is a first-class module.

### Inventory operations

Support:
- Stock entry
- Stock adjustment
- Low-stock report
- Inventory valuation
- Movement history
- Product-specific Kardex/history

Adjustments should record:
- Product
- Previous quantity
- Quantity delta
- New quantity
- Reason
- User
- Timestamp
- Reference/source document when available

Typical reasons:
- Damaged merchandise
- Theft/shrinkage
- Counting discrepancy
- Data-entry correction
- Other configured reasons

Never silently modify stock.

### Low stock

Allow a minimum-stock threshold per product.

The low-stock report should identify:
- Product
- Current quantity
- Minimum quantity
- Deficit
- Category
- Optional supplier

### Inventory valuation

Show at minimum:
- Cost value
- Sale value
- Units in stock

Keep valuation formulas explicit and consistent.

### Movement history / Kardex

For each product, provide chronological movements:
- Sale
- Return
- Purchase/entry
- Manual adjustment
- Inventory correction
- Other stock-affecting events

Each movement should be traceable to a source transaction.

## Purchases and suppliers

For a full modern POS, include:
- Supplier catalog
- Supplier contact information
- Purchase/receiving documents
- Purchased products
- Quantities
- Unit cost
- Total cost
- Inventory update
- Purchase history
- Supplier balances if credit purchases are supported

The current Eleventa documentation describes a dedicated purchases/providers
module with supplier catalog, purchase lists, purchase orders, and merchandise
receiving. Treat these as `related-product reference features`, not necessarily
as proof that every item exists identically in every AbarrotesPDV 6 build.

## Promotions and pricing

Support configurable:
- Standard sale price
- Wholesale price
- Promotional price/rule
- Effective dates
- Quantity thresholds
- Customer-specific pricing if the business requires it

Pricing rules must be deterministic and tested for:
- Multiple promotions
- Quantity changes
- Returns
- Tax calculation
- Manual price overrides

Do not allow a cashier to override price silently if permissions require approval.

## Tickets

Tickets should contain enough information to reconstruct the transaction:
- Ticket/transaction ID
- Date/time
- Cashier/user
- Register/cash register
- Products
- Quantities
- Unit prices
- Discounts
- Taxes
- Payment methods
- Amount received
- Change
- Customer, when applicable
- Totals

Support:
- Print ticket
- Reprint when permitted
- Recover tickets
- Put ticket on hold
- Return/devolution workflow

A reprint must never create a second sale.

## Returns / devolutions

Returns should be implemented as controlled reverse transactions:
- Identify original sale when possible.
- Identify returned products and quantities.
- Validate returnable quantity.
- Update stock according to configured policy.
- Reverse/adjust financial totals.
- Record reason.
- Record user and timestamp.
- Link return to original sale.

Never delete the original sale to simulate a return.

## Cash register / cuts / shifts

Provide:
- Opening cash amount
- Cash movements
- Sales by payment method
- Cash received
- Refunds/returns
- Expected cash
- Actual counted cash
- Difference/variance
- Cashier/user
- Register
- Shift/open-close timestamps
- End-of-day cut
- Printable cut report

A cut should be a snapshot/reconciliation, not a destructive reset of sales data.

## Reports

Build a report framework rather than isolated screens.

At minimum consider:
- Sales by date
- Sales by cashier
- Sales by register
- Sales by product
- Best-selling products
- Sales by category
- Revenue
- Cost
- Gross profit
- Inventory value
- Low stock
- Inventory movements
- Customer balances
- Cash cuts
- Returns
- Payment methods

Reports should support:
- Date range
- Filters
- Sorting
- Pagination
- Export when supported by the host project
- Print-friendly view

Always distinguish revenue from profit.

## Invoicing / fiscal documents

AbarrotesPDV 6's public development tracker lists:
- Invoices from sales
- Global invoices
- Monthly reports
- Invoice configuration/folios
- Tax/fiscal-related product fields

Because fiscal rules depend on jurisdiction, implement fiscal logic through a
country-specific adapter.

For Dominican Republic projects, do NOT blindly implement Mexico-specific SAT/CFDI
behavior. Use an abstraction such as:

`FiscalProvider -> DominicanProvider`

and keep NCF/tax/e-invoicing rules isolated from the core POS.

## Configuration

Organize configuration into:

### General
- Enabled features
- Cashier settings
- Database settings
- Preloaded articles/products
- Invoicing settings
- Folio/sequence configuration

### Personalization
- Program logo
- Ticket layout
- Payment methods
- Taxes
- Currency symbol
- Units of measure

### Devices
- Receipt printer
- Barcode scanner
- Cash drawer
- Electronic scale

### Maintenance
- Automatic backup
- License/status
- Automatic updates

Settings should be permission-protected when they can affect accounting,
pricing, taxation, or inventory.

## Hardware integration

Design hardware behind interfaces:

- `BarcodeScanner`
- `ReceiptPrinter`
- `CashDrawer`
- `Scale`

The application must still work without hardware connected.

Hardware failures should not corrupt the sale.

## Search UX

Product search should be optimized for a cashier:
- Search by barcode
- Search by product name
- Search by code
- Show price
- Show stock
- Select with keyboard
- Enter to add
- Escape to cancel
- Fast response on large catalogs

Avoid modal dialogs for routine cashier operations.

## Multi-company / multi-user / multi-register

The public AbarrotesPDV comparison and documentation identify multi-company,
multi-user, and multi-register/network concepts.

Model tenancy explicitly:

`Company -> Store -> Register -> User -> Shift -> Transactions`

Use role-based permissions such as:
- Administrator
- Manager
- Cashier
- Inventory operator

Never trust client-side permissions alone. Enforce authorization at the
backend/data layer.

For multi-register deployments, use transaction IDs and concurrency controls so
two registers cannot corrupt the same stock count.

## Database model

A robust implementation should normally include entities similar to:

- companies
- stores
- registers
- users
- roles
- permissions
- shifts
- products
- categories
- units
- prices
- promotions
- customers
- customer_accounts
- suppliers
- purchases
- purchase_items
- inventory_movements
- stock_balances
- sales
- sale_items
- payments
- returns
- return_items
- cash_movements
- cash_cuts
- fiscal_documents
- settings
- audit_logs

Use immutable transaction records wherever possible.

## Data integrity rules

Mandatory invariants:

1. Every sale has at least one valid line unless explicitly cancelled.
2. Every sale total is reproducible from its lines, discounts, taxes and payments.
3. A completed sale cannot be silently edited.
4. Inventory changes must have a movement record.
5. A return cannot exceed the returnable quantity.
6. Cash cuts cannot delete transaction history.
7. Reprinting a ticket cannot create a transaction.
8. Imports must be atomic or explicitly report partial failure.
9. Financial/audit records should have timestamps and user identity.
10. Backend authorization must be enforced server-side.
11. Currency calculations must use decimal-safe arithmetic, not binary floating
   point for persisted monetary values.
12. All timestamps should be stored consistently and displayed in the business
   timezone.

## UX principles

The reference product is designed for speed and simplicity.

When building a comparable system:
- Prioritize keyboard workflows.
- Keep the sale screen uncluttered.
- Make barcode scanning instantaneous.
- Keep the current ticket visible.
- Make total/payment state impossible to miss.
- Avoid unnecessary animations.
- Provide clear success/error feedback.
- Make inventory changes explainable.
- Make destructive actions require confirmation.
- Prefer progressive disclosure over huge forms.

## Implementation workflow for Claude Code

Before changing code:

1. Inspect the repository.
2. Identify framework, database, auth and existing modules.
3. Read project-level `AGENTS.md`, `CLAUDE.md`, and relevant skills.
4. Map existing features to the module model above.
5. Do not rebuild an existing working subsystem unnecessarily.
6. Propose the smallest architecture-compatible change.
7. Implement.
8. Run tests/lint/build.
9. Test the affected workflow manually when possible.
10. Report files changed, behavior added, tests run, and remaining limitations.

For a new POS module, implement in this order unless the user specifies otherwise:

1. Data model + migrations
2. Product/catalog
3. Inventory ledger
4. Sales/cart
5. Payments
6. Customers/credit
7. Cash shifts/cuts
8. Reports
9. Purchases/suppliers
10. Fiscal/invoicing adapter
11. Hardware adapters
12. Backups/import/export
13. Multi-register synchronization
14. Advanced analytics

## Feature verification labels

When documenting functionality, use one of:

- `CONFIRMED`: directly documented by AbarrotesPDV public documentation.
- `RELATED`: documented in the current Eleventa product/manual and relevant to
  the same product lineage/ecosystem, but not proven identical in AbarrotesPDV.
- `INFERRED`: reasonable engineering behavior inferred from the feature.
- `UNCONFIRMED`: do not present as an existing AbarrotesPDV feature.

## Public research baseline

Research performed September 16, 2026.

Primary references:
- AbarrotesPDV official manual: https://www.abarrotespdv.com/manual/default.aspx
- AbarrotesPDV product page: https://www.abarrotespdv.com/abarrotes-punto-de-venta/default.aspx
- AbarrotesPDV public development/feature tracker:
  https://www.abarrotespdv.com/dev-todo.aspx
- AbarrotesPDV version notes:
  https://www.abarrotespdv.com/notas-version.aspx
- AbarrotesPDV vs Eleventa feature comparison:
  https://www.abarrotespdv.com/abarrotespdv-vs-eleventa.aspx
- Eleventa learning/manual hub:
  https://eleventa.com/aprender
- Eleventa POS overview:
  https://eleventa.com/punto-de-venta

These sources are reference material. They do not grant permission to copy
proprietary code or branding.
