import re

log_path = r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Tester\D0E8209F77C8CF37AD8BF550E51FF075\Agent-127.0.0.1-3000\logs\20261030.log"

with open(log_path, "r", encoding="utf-16le", errors="ignore") as f:
    lines = f.readlines()

trades = []
sl_hits = 0
tp_hits = 0
open_buys = 0
open_sells = 0

for line in lines:
    if "market buy" in line:
        open_buys += 1
    elif "market sell" in line:
        open_sells += 1
    elif "stop loss triggered" in line:
        sl_hits += 1
    elif "take profit triggered" in line:
        tp_hits += 1

print(f"Total Market Buys: {open_buys}")
print(f"Total Market Sells: {open_sells}")
print(f"Stop Loss Triggered: {sl_hits}")
print(f"Take Profit Triggered: {tp_hits}")
if (sl_hits + tp_hits) > 0:
    win_rate = (tp_hits / (sl_hits + tp_hits)) * 100
    print(f"Win Rate: {win_rate:.2f}%")

