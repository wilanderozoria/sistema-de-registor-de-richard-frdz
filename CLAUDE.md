# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This project is a single-page web application for a shopping and logistics service (Richard FdezGsm). It provides a professional landing page with an integrated interactive quote calculator that generates order summaries and sends them via WhatsApp.

## Technical Architecture
- **Stack**: Pure Vanilla HTML5, CSS3, and JavaScript (No external frameworks).
- **Structure**: Single-file architecture (`index.html`) containing all styles, markup, and logic.
- **Styling**: 
  - Uses CSS Variables (`:root`) for a consistent dark theme.
  - Responsive design utilizing Flexbox and CSS Grid.
  - Specialized `@media print` rules to format receipts for 80mm thermal printers.
- **Logic**:
  - Real-time calculation engine for product totals, commissions, and shipping.
  - Dynamic DOM manipulation for updating the quote summary and receipt modal.
  - WhatsApp API integration for sending formatted order data.

## Key Components
- **Cotizador**: The main functional area where users input order details.
- **Order Modal**: A receipt preview that allows the user to verify data before printing or sending.
- **Print Engine**: Custom CSS that hides the UI and isolates the receipt for thermal printing.

## Development Guidance
- **Testing**: Open `index.html` in any modern web browser.
- **Printing**: To test the receipt format, open the Order Modal and use the browser's print dialog (Ctrl+P).
- **Configuration**: The WhatsApp number is stored as a constant `WHATSAPP_NUMBER` at the beginning of the `<script>` block.
