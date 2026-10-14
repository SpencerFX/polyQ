import argparse
import json
import logging
import time
import websocket
from qpython import qconnection

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

POLYMARKET_WS_URL = "wss://ws-subscriptions-clob.polymarket.com/ws/market"

class PolyQAdapter:
    def __init__(self, q_host: str, q_port: int, asset_ids: list):
        self.q_host = q_host
        self.q_port = q_port
        self.asset_ids = asset_ids
        self.q = None
        self.connect_q()

    def connect_q(self):
        while True:
            try:
                self.q = qconnection.QConnection(host=self.q_host, port=self.q_port)
                self.q.open()
                logging.info(f"Connected to kdb+ RDB at {self.q_host}:{self.q_port}")
                break
            except Exception as e:
                logging.error(f"Failed to connect to kdb+: {e}. Retrying in 3s...")
                time.sleep(3)

    def on_message(self, ws, message):
        try:
            data = json.loads(message)
            # Dispatch to kdb+ asynchronous feed parser .feed.upd
            if isinstance(data, list):
                for item in data:
                    self.q.async_('.feed.upd', item.get('event_type', 'raw'), json.dumps(item))
            elif isinstance(data, dict):
                event_type = data.get('event_type', data.get('type', 'raw'))
                self.q.async_('.feed.upd', event_type, json.dumps(data))
        except Exception as e:
            logging.error(f"Error parsing/pushing WS payload: {e}")

    def on_open(self, ws):
        logging.info("WebSocket connection established. Subscribing to assets...")
        sub_payload = {
            "assets_ids": self.asset_ids,
            "type": "market"
        }
        ws.send(json.dumps(sub_payload))

    def run(self):
        ws = websocket.WebSocketApp(
            POLYMARKET_WS_URL,
            on_open=self.on_open,
            on_message=self.on_message,
            on_error=lambda ws, e: logging.error(f"WS Error: {e}"),
            on_close=lambda ws, c, m: logging.warning("WS Connection Closed")
        )
        ws.run_forever()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Polymarket WS to kdb+ Adapter")
    parser.add_argument("--host", default="localhost", help="kdb+ RDB host")
    parser.add_argument("--port", type=int, default=5010, help="kdb+ RDB port")
    parser.add_argument("--assets", nargs="+", default=["1001", "1002"], help="Asset/Token IDs")
    args = parser.parse_args()

    adapter = PolyQAdapter(args.host, args.port, args.assets)
    adapter.run()
