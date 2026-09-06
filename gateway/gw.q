/ Gateway Server (GW) - Acts as single point of entry for user queries
if[not system"p"; system"p 5000"];

/ Tier Handles
.gw.rdbHandle: 0N;
.gw.hdbHandle: 0N;

.gw.connectTiers:{[]
    .gw.rdbHandle: @[hopen; `:localhost:5010; {0N!"RDB Connection Failed: ",x; 0N}];
    .gw.hdbHandle: @[hopen; `:localhost:5012; {0N!"HDB Connection Failed: ",x; 0N}];
 };

/ Init connection
.gw.connectTiers[];

/ Unified Query Router
.gw.query:{[tableName; startDate; endDate; assetSym]
    0N! "Routing query for ", string[tableName], " between ", string[startDate], " and ", string[endDate];
    
    / If date includes today, hit RDB + HDB
    $[(endDate >= .z.D) and (startDate < .z.D);
        [
            rdbRes: .gw.rdbHandle (`.gw.execRDB; tableName; assetSym);
            hdbRes: .gw.hdbHandle (`.gw.execHDB; tableName; startDate; endDate - 1; assetSym);
            :hdbRes , rdbRes
        ];
      endDate >= .z.D;
        :.gw.rdbHandle (`.gw.execRDB; tableName; assetSym);
        :.gw.hdbHandle (`.gw.execHDB; tableName; startDate; endDate; assetSym)
    ];
 };

/ Remote execution stubs
.gw.execRDB:{[tbl; asset] ?[tbl; enlist (=; `sym; enlist asset); 0b; ()]};
.gw.execHDB:{[tbl; sDt; eDt; asset] ?[tbl; ((within; `date; (sDt; eDt)); (=; `sym; enlist asset)); 0b; ()]};
