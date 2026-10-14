/ Bid-Ask Spread and Depth Metrics

.analytics.getSpreadMetrics:{[assetSym]
    select 
        time,
        sym,
        bidPrice,
        askPrice,
        spread: askPrice - bidPrice,
        midPrice: 0.5 * (bidPrice + askPrice),
        relativeSpreadBps: 10000 * (askPrice - bidPrice) % (0.5 * (bidPrice + askPrice))
    from quotes 
    where sym = assetSym
 };
