/ Real-time Database (RDB) Server
\l config/settings.q
\l db/schema.q
\l feed/parser.q
\l feed/normalizer.q

/ Bind listening port from config unless one was supplied via -p
if[not system"p"; @[system; "p ", string .config.TP_PORT; {[e] -2 "WARN: could not bind port: ", e}]];

/ Real-time log file setup
.rdb.logFile:`$":rdb_log_",string[.z.D],".log";
/ Initialise a valid (empty) kdb+ message log the first time, so -11! can replay it
if[() ~ key .rdb.logFile; .rdb.logFile set ()];
/ Append handle to the replay log
.rdb.logHandle: @[hopen; .rdb.logFile; {[e] -2 "WARN: could not open rdb log: ",e; 0Ni}];

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
    {[t; d; dt]
        tbl: value t;
        if[not count tbl; :(::)];
        / Splayed partition path MUST end in a slash, e.g. `:hdb/2026.01.01/quotes/
        path: hsym `$ (1 _ string d), "/", (string dt), "/", (string t), "/";
        path set .Q.en[d] tbl;
        @[`.; t; :; 0 # tbl];
    }[; hdbDir; dt] each tablesToSave;
    / Backfill any tables that had no rows today so history stays queryable
    @[.Q.chk; hdbDir; {[e] 0N! "WARN: .Q.chk: ", e}];
 };
