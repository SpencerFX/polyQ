/ Toxic Flow / Order Flow Imbalance (OFI) calculation

.analytics.calcOFI:{[assetSym]
    qData: select time, bidPrice, bidSize, askPrice, askSize from quotes where sym = assetSym;
    
    / Calculate deltas
    qData: update 
        dBid: signum[bidPrice - xprev[1; bidPrice]],
        dAsk: signum[askPrice - xprev[1; askPrice]]
    from qData;

    / Vectorised conditional: the 5-arg $[b1;r1;b2;r2;else] "cond" form needs
    / atoms, so nest the 3-arg form which broadcasts over the column vectors.
    qData: update
        ofi: ?[dBid > 0; bidSize; ?[dBid = 0; bidSize - xprev[1; bidSize]; 0f]] -
             ?[dAsk < 0; askSize; ?[dAsk = 0; askSize - xprev[1; askSize]; 0f]]
    from qData;
    
    select time, ofi from qData
 };
