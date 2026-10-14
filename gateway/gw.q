/ Gateway Server (GW) - Acts as single point of entry for user queries
\l config/settings.q

/ Tier Handles
.gw.rdbHandle: 0Ni;
.gw.hdbHandle: 0Ni;

/ Bind listening port from config unless one was supplied via -p
if[not system"p"; @[system; "p ", string .config.GW_PORT; {[e] -2 "WARN: could not bind port: ", e}]];

.gw.rdbAddr: `$ ":", (string .config.TP_HOST),  ":", string .config.TP_PORT;
.gw.hdbAddr: `$ ":", (string .config.HDB_HOST), ":", string .config.HDB_PORT;

.gw.connectTiers:{[]
    .gw.rdbHandle: @[hopen; .gw.rdbAddr; {0N!"RDB Connection Failed: ",x; 0Ni}];
    .gw.hdbHandle: @[hopen; .gw.hdbAddr; {0N!"HDB Connection Failed: ",x; 0Ni}];
 };

/ Init connection
.gw.connectTiers[];

/ Remote execution stubs. These are sent by value over IPC and evaluated on the
/ target tier, so the RDB/HDB processes do not need them predefined.
.gw.execRDB:{[tbl; asset] ?[tbl; enlist (=; `sym; enlist asset); 0b; ()]};
.gw.execHDB:{[tbl; sDt; eDt; asset] ?[tbl; ((within; `date; (sDt; eDt)); (=; `sym; enlist asset)); 0b; ()]};

/ Unified Query Router
.gw.query:{[tableName; startDate; endDate; assetSym]
    0N! "Routing query for ", string[tableName], " between ", string[startDate], " and ", string[endDate];
    if[null .gw.rdbHandle; .gw.connectTiers[]];

    / If the range spans both history and today, hit HDB + RDB and merge
    $[(endDate >= .z.D) and (startDate < .z.D);
        [
            rdbRes: .gw.rdbHandle (.gw.execRDB; tableName; assetSym);
            hdbRes: .gw.hdbHandle (.gw.execHDB; tableName; startDate; endDate - 1; assetSym);
            / HDB rows carry a virtual `date` column the RDB rows lack -> union-join
            :hdbRes uj rdbRes
        ];
      endDate >= .z.D;
        :.gw.rdbHandle (.gw.execRDB; tableName; assetSym);
        :.gw.hdbHandle (.gw.execHDB; tableName; startDate; endDate; assetSym)
    ];
 };
