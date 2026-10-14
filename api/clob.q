/ Query historical CLOB midpoint / orderbook REST endpoints
.api.getMidpoint:{[tokenId]
    url: "https://clob.polymarket.com/midpoint?token_id=", string tokenId;
    raw: system "curl -s \"", url, "\"";
    .feed.parseJSON raze raw
 };
