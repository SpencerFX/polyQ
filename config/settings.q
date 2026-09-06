/ Config file for polyQ system environment
\d .config

HDBPATH: getenv[`POLYQ_HDB]
if[null HDBPATH; HDBPATH: `:/data/polyQ/hdb];

TP_HOST: `${getenv[`TP_HOST]}
if[null TP_HOST; TP_HOST: `localhost];

TP_PORT: "I"$getenv[`TP_PORT];
if[null TP_PORT; TP_PORT: 5010];

HDB_PORT: "I"$getenv[`HDB_PORT];
if[null HDB_PORT; HDB_PORT: 5012];

GW_PORT: "I"$getenv[`GW_PORT];
if[null GW_PORT; GW_PORT: 5000];

\d .
