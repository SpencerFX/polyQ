/ Historical Database (HDB) Loader
\l config/settings.q

/ Mount HDB Directory passed via CLI or default.
/ .Q.l runs `cd` with its argument, so it needs a bare path (no leading `:`);
/ key/existence checks need the `:`-prefixed hsym form.
hdbRaw: $[count .z.x; first .z.x; .config.HDBPATH];
hdbDir: `$ $[":" = first hdbRaw; 1 _ hdbRaw; hdbRaw];
hdbDirH: hsym hdbDir;

/ Bind listening port from config unless one was supplied via -p
if[not system"p"; @[system; "p ", string .config.HDB_PORT; {[e] -2 "WARN: could not bind port: ", e}]];

$[count key hdbDirH;
    [.Q.l hdbDir;
     0N! "HDB successfully mounted from ", string hdbDir];
    0N! "WARN: HDB directory not found, starting empty: ", string hdbDir
 ];

/ Sym mapping reload function
.hdb.reload:{
    system "l .";
    0N! "HDB Reloaded.";
 };
