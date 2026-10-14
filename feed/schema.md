# Feed Payload Schemas

## Incoming WebSocket Event Formats (JSON)

### Book / Quote Event (`book`)
```json
{
  "event_type": "quotes",
  "asset_id": "712391293019",
  "market": "0x918f...23a",
  "bids": [{"price": "0.54", "size": "1200"}],
  "asks": [{"price": "0.56", "size": "800"}],
  "timestamp": "1772885614000"
}
```

### Trade Event (`last_trade_price`)
```json
{
  "event_type": "trades",
  "asset_id": "712391293019",
  "market": "0x918f...23a",
  "side": "BUY",
  "price": "0.55",
  "size": "300",
  "maker": "0x123...",
  "taker": "0x456..."
}
```
