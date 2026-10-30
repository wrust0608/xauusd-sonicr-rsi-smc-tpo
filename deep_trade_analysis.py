import re
from datetime import datetime

log_path = r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Tester\D0E8209F77C8CF37AD8BF550E51FF075\Agent-127.0.0.1-3000\logs\20261030.log"

with open(log_path, "r", encoding="utf-16le", errors="ignore") as f:
    text = f.read()

# Pattern for strategy trades
# e.g., market buy 0.1 XAUUSD sl: 4031.31 tp: 4041.81 (4034.54 / 4034.81 / 4034.54)
trade_pattern = re.compile(r"(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2})\s+market (buy|sell) 0\.1 XAUUSD sl: ([\d\.]+) tp: ([\d\.]+)")
sl_pattern = re.compile(r"(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2})\s+stop loss triggered #(\d+)")
tp_pattern = re.compile(r"(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2})\s+take profit triggered #(\d+)")

trades = trade_pattern.findall(text)
print(f"Parsed {len(trades)} executed trades.")

# Print first 15 and last 15 trades
print("\n--- SAMPLE TRADE SEQUENCES ---")
for t in trades[:10]:
    print(f"Time: {t[0]} | Type: {t[1].upper()} | SL: {t[2]} | TP: {t[3]}")

print("\n--- RECENT TRADE SEQUENCES ---")
for t in trades[-10:]:
    print(f"Time: {t[0]} | Type: {t[1].upper()} | SL: {t[2]} | TP: {t[3]}")

