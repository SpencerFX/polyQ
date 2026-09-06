/ Post-trade Markout analysis (evaluating price impact 1s, 5s, 10s post-execution)

.analytics.tradeMarkout:{[assetSym; horizonWindow]
    trds: select time, price, side, size from trades where sym = assetSym;
    / As-of join to grab quotes post-trade
    trdsWithPostQuote: aj[`sym`time; trds; select sym, time, midPost: 0.5 * (bidPrice + askPrice) from quotes];
    
    select 
        time,
        price,
        midPost,
        pnlMarkout: $[side=`buy; midPost - price; price - midPost]
    from trdsWithPostQuote
 };
