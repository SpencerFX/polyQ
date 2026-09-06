/ Historical Database (HDB) Loader
if[not system"p"; system"p 5012];

/ Mount HDB Directory passed via CLI or default
hdbDir: `$.z.x 0;
if[null hdbDir; hdbDir: `:/data/polyQ/hdb];

if[not null type key hdbDir;
    .Q.l[hdbDir];
    0N! "HDB successfully mounted from ", string hdbDir;
 ];

/ Sym mapping reload function
.hdb.reload:{
    system "l .";
    0N! "HDB Reloaded.";
 };
