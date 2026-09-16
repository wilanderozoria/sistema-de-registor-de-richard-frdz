# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This project is a single-page web application for a shopping and logistics service (Richard FdezGsm). It provides a professional landing page with an integrated interactive quote calculator, a repair equipment tracking system, and an accessories sales module.

## Technical Architecture
- **Stack**: Pure Vanilla HTML5, CSS3, and JavaScript (No external frameworks).
- **Backend/DB**: Supabase (PostgreSQL).
- **Structure**: Single-file architecture (`index.html`) containing all styles, markup, and logic.
- **Styling**: 
  - Uses CSS Variables (`:root`) for a consistent dark theme.
  - Responsive design utilizing Flexbox and CSS Grid.
  - Specialized `@media print` rules to format receipts for 80mm thermal printers.
- **Logic**:
  - Real-time calculation engine for product totals, commissions, and shipping.
  - Supabase integration for persisting repair entries, sales data, and inventory.
  - Dynamic DOM manipulation for updating quotes, repair lists, and invoice modals.
  - WhatsApp API integration for sending formatted order and invoice data.

## Database Schema (Supabase)
The application interacts with the following tables:
- **`sales`**: Stores accessory sales (`item`, `price`, `client`, `warranty`).
- **`repairs`**: Stores equipment repair entries (`client`, `cedula`, `phone`, `imei`, `brand`, `condition`, `missing`, `price`, `date`).
- **`products`**: Inventory catalog (`code`, `name`, `current_stock`, `min_stock`, `cost_price`, `sale_price`, `category`, `unit`, `status`).
- **`product_movements`**: Audit log for stock changes (`product_id`, `amount`, `reason`, `type`, `previous_stock`, `new_stock`, `username`).

## Key Components
- **Cotizador**: The main functional area for shopping quotes.
- **Entrada de Equipos**: Management of received devices for repair, including registration and release (exit) flow.
- **Ventas**: Module for selling accessories/parts with warranty tracking.
- **Inventory**: Catalog management, stock adjustments, and valuation reports.
- **Invoice Modals**: Separate modal views for shopping receipts, repair exits, and sales invoices.
- **Print Engine**: Custom CSS that isolates the active receipt for thermal printing while hiding all UI controls.

## Development Guidance
- **Testing**: Open `index.html` in any modern web browser.
- **Printing**: To test receipt formats, open a modal and use Ctrl+P. Verify that only the receipt content is visible.
- **Configuration**: 
  - The WhatsApp number is stored as a constant `WHATSAPP_NUMBER` in the `<script>` block.
  - Supabase connection is managed via `SUPABASE_URL` and `SUPABASE_KEY`.
- **Schema Changes**: Any change to the Supabase table columns must be mirrored in the JS mapping functions (e.g., `fetchInventory`) to maintain camelCase compatibility in the frontend.

## Critical Printing & UI Pitfalls (Lessons Learned)
- **Print Visibility**: When using `@media print`, avoid using `* { visibility: visible }` on modals as it reveals hidden UI elements (buttons). Only target the specific print card (e.g., `#invoicePrint`).
- **Modal Overlap**: Always close all other active modals (`closeAllModals()`) before opening a specific invoice modal to prevent CSS conflicts and ensure the correct content is printed.
- **Thermal Layout**: Keep receipt content narrow (max 80mm) and use dashed borders for a professional thermal look.
- **Single File Maintenance**: Since the project is a single large `index.html`, use precise line numbers or unique identifiers when editing to avoid corrupting the structure.
