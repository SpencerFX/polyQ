/ Config file for polyQ system environment
/ Every value can be overridden via an environment variable; sane defaults otherwise.
\d .config

/ Helper: environment variable as string, or default when unset/empty
getStr:{[k; dflt] v: getenv k; $[count v; v; dflt]};
/ Helper: environment variable as int, or default when unset/empty/non-numeric
getInt:{[k; dflt] v: "J"$ getStr[k; ""]; $[null v; dflt; v]};

HDBPATH: getStr[`POLYQ_HDB; "/data/polyQ/hdb"];

TP_HOST:  `$ getStr[`POLYQ_TP_HOST;  "localhost"];
HDB_HOST: `$ getStr[`POLYQ_HDB_HOST; "localhost"];

TP_PORT:  getInt[`POLYQ_TP_PORT;  5010];
HDB_PORT: getInt[`POLYQ_HDB_PORT; 5012];
GW_PORT:  getInt[`POLYQ_GW_PORT;  5000];

\d .
