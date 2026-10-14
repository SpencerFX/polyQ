/ Normalization routines: converting raw dicts/JSON to schema-compliant tables

.feed.normalize:{[evtType; rawDict]
    if[evtType ~ "quotes";
        bids: rawDict`bids;
        asks: rawDict`asks;
        bestBid: $[count bids; "F"$bids[0]`price; 0.0];
        bestBidSz: $[count bids; "F"$bids[0]`size; 0.0];
        bestAsk: $[count asks; "F"$asks[0]`price; 0.0];
        bestAskSz: $[count asks; "F"$asks[0]`size; 0.0];
        
        :([]
            time: enlist .z.p;
            sym: `$rawDict`asset_id;
            market: `$rawDict`market;
            bidPrice: enlist bestBid;
            bidSize: enlist bestBidSz;
            askPrice: enlist bestAsk;
            askSize: enlist bestAskSz
        )
    ];

    if[evtType ~ "trades";
        :([]
            time: enlist .z.p;
            sym: `$rawDict`asset_id;
            market: `$rawDict`market;
            side: `$lower rawDict`side;
            price: enlist "F"$rawDict`price;
            size: enlist "F"$rawDict`size;
            maker: `$rawDict`maker;
            taker: `$rawDict`taker
        )
    ];

    :();
 };
