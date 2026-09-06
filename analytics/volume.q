/ Volume Weighted Average Price (VWAP) & Liquidity metrics

.analytics.getVWAP:{[assetSym; timeInterval]
    select 
        vwap: size wavg price, 
        totalVolume: sum size, 
        tradeCount: count i 
    by time.minute xbar timeInterval 
    from trades 
    where sym = assetSym
 };
