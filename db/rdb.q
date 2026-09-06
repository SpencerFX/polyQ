/ Real-time Database (RDB) Server
\l db/schema.q
\l feed/parser.q
\l feed/normalizer.q

/ Command line port check
if[not system"p"; system"p 5010"];

/ Real-time log file setup
.rdb.logFile:`$":rdb_log_",string[.z.D],".log";
if[null type key .rdb.logFile; .rdb.logHandle: hopen .rdb.logFile];

/ Universal entry point called asynchronously by Python Adapter
.feed.upd:{[evtType; payload]
    parsed: .feed.parseJSON[payload];
    if[count parsed;
        normalized: .feed.normalize[evtType; parsed];
        if[count normalized;
            / Append to in-memory tables & log
            .[`$evtType; (); ,; normalized];
            if[not null .rdb.logHandle; .rdb.logHandle enlist (`.feed.upd; evtType; payload)]
        ]
    ];
 };

/ EOD Flush logic to persist data to HDB format
.rdb.endOfDay:{[dt; hdbDir]
    /.rdb.endOfDay[.z.D; `:/data/polyQ/hdb]
    0N! "Executing EOD save for date: ", string dt;
    tablesToSave: `quotes`trades`l2book`probTrack;
    {[t; d]
        path: .Q.par[d; t; `];
        path set .Q.en[d] get t;
        delete from t;
    }[; hdbDir] each tablesToSave;
    .Q.chk[hdbDir];
 };
