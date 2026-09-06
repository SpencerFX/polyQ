/ Toxic Flow / Order Flow Imbalance (OFI) calculation

.analytics.calcOFI:{[assetSym]
    qData: select time, bidPrice, bidSize, askPrice, askSize from quotes where sym = assetSym;
    
    / Calculate deltas
    qData: update 
        dBid: signum[bidPrice - xprev[1; bidPrice]],
        dAsk: signum[askPrice - xprev[1; askPrice]]
    from qData;

    qData: update 
        ofi: $[dBid > 0; bidSize; dBid = 0; bidSize - xprev[1; bidSize]; 0] -
             $[dAsk < 0; askSize; dAsk = 0; askSize - xprev[1; askSize]; 0]
    from qData;
    
    select time, ofi from qData
 };
