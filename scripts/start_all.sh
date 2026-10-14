#!/usr/bin/env bash

echo "Starting polyQ Stack..."

# 1. Start RDB
q db/rdb.q -p 5010 &
RDB_PID=$!
echo "RDB started with PID $RDB_PID"

# 2. Start HDB
q db/hdb.q /data/polyQ/hdb -p 5012 &
HDB_PID=$!
echo "HDB started with PID $HDB_PID"

# 3. Start Gateway
q gateway/gw.q -p 5000 &
GW_PID=$!
echo "Gateway started with PID $GW_PID"

# Sleep briefly for Q processes to bind ports
sleep 2

# 4. Start Python WS Feed Adapter
python3 adapter/polyq_ws.py --host localhost --port 5010 &
ADAPTER_PID=$!
echo "Python WS Adapter started with PID $ADAPTER_PID"

echo "polyQ deployment online."
wait
