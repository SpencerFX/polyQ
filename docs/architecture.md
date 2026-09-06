# Architecture Documentation

polyQ uses a multi-tiered q/kdb+ architecture:
1. **Adapter Tier:** Python websocket process ingesting CLOB feeds.
2. **Feed & Normalization Tier:** q-based handlers for table normalization and schema casting.
3. **Database Tier:** RDB for tick data and real-time book updates; HDB for historical query resolution.
4. **Analytics Tier:** Probability, Spread, VWAP, Markout, Impact, and Flow modules.
5. **Gateway Tier:** Unified async routing layer for external client requests.
