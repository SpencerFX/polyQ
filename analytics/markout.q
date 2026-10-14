/ Post-trade Markout analysis (evaluating price impact 1s, 5s, 10s post-execution)

.analytics.tradeMarkout:{[assetSym; horizonWindow]
    / Keep sym in the projection - aj needs the join columns in both tables
    trds: select sym, time, price, side, size from trades where sym = assetSym;
    / Shift each trade forward by the markout horizon, then as-of join the
    / prevailing quote at that later time to get the post-trade mid.
    trdsFwd: update time: time + horizonWindow from trds;
    mids: `sym`time xasc select sym, time, midPost: 0.5 * (bidPrice + askPrice) from quotes;
    trdsWithPostQuote: aj[`sym`time; trdsFwd; mids];

    select
        time: time - horizonWindow,
        price,
        midPost,
        pnlMarkout: ?[side = `buy; midPost - price; price - midPost]
    from trdsWithPostQuote
 };
