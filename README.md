# polyQ: Polymarket kdb+ Feedhandler & Analytical Engine

polyQ provides an end-to-end q/kdb+ architecture to capture, store, and analyze real-time prediction market data from Polymarket (Polygon / CLOB / Gamma API).

## Quick Start

1. **Install Python dependencies:**
   ```bash
   make setup
   ```

2. **Launch Services:**
   ```bash
   ./scripts/start_all.sh
   ```

3. **Architecture:**
   * **Python Adapter:** Connects to Polymarket WS (`wss://ws-subscriptions-clob.polymarket.com/ws/market`) and pushes raw IPC structs to `rdb.q` (Port 5010).
   * **RDB (5010):** Normalizes feed data, maintains real-time order books, and logs updates to tick disk.
   * **HDB (5012):** Serves partitioned history on disk.
   * **Gateway (5000):** Async router for cross-tier client queries.
