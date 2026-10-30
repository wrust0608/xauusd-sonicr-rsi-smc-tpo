import csv
import sys
import codecs
sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())
from collections import defaultdict

csv_path = r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Files\XAUUSD_WickSniper_ThoroughBacktest.csv"

wick_records = []
touch_records = []

with open(csv_path, "r", encoding="utf-8", errors="ignore") as f:
    reader = csv.DictReader(f)
    for row in reader:
        rec_type = row["TYPE"]
        if rec_type == "WICK":
            wick_records.append({
                "time": row["TIME"],
                "zone": row["ZONE"],
                "is_buy": int(row["IS_BUY"]),
                "entry": float(row["ENTRY"]),
                "sl": float(row["SL"]),
                "tp": float(row["TP"]),
                "sl_dist": float(row["SL_DIST"]),
                "wick_ratio": float(row["WICK_RATIO"]),
                "is_win": int(row["IS_WIN"]),
                "r_mult": float(row["R_MULT"]),
                "pl": float(row["PL"]),
                "held": int(row["HELD"])
            })
        elif rec_type == "TOUCH":
            touch_records.append({
                "time": row["TIME"],
                "zone": row["ZONE"],
                "is_buy": int(row["IS_BUY"]),
                "level": float(row["ENTRY"]),
                "win_sl100": int(row["IS_WIN"]),
                "mae": float(row["MAE"]),
                "mfe": float(row["MFE"]),
                "held": int(row["HELD"])
            })

print("=" * 80)
print(f"LOADED DATASET: {len(wick_records)} WICK SETUPS | {len(touch_records)} TOUCH EVENTS")
print("=" * 80)

# 1. GRANULAR BREAKDOWN OF SNIPER TOUCH BY ZONE TYPE
print("\n" + "=" * 80)
print("1. PHÂN TÍCH 'CHẠM CẢN BẬT NGAY' (SNIPER TOUCH) THEO TỪNG LOẠI VÙNG CẢN")
print("=" * 80)
print(f"{'Vùng Cản (Zone)':<22} | {'Tổng Chạm':<9} | {'MAE <= $0.5':<11} | {'MAE <= $1.0':<11} | {'Win SL $1.0':<11} | {'PF (1:2)':<8} | {'Avg MAE':<8}")
print("-" * 88)

touch_by_zone = defaultdict(list)
for t in touch_records:
    touch_by_zone[t["zone"]].append(t)

for zone, items in sorted(touch_by_zone.items(), key=lambda x: len(x[1]), reverse=True):
    tot = len(items)
    mae_05 = sum(1 for x in items if x["mae"] <= 0.50)
    mae_10 = sum(1 for x in items if x["mae"] <= 1.00)
    wins = sum(1 for x in items if x["win_sl100"] == 1)
    losses = tot - wins
    win_rate = (wins / tot) * 100
    pf = (wins * 2.0 / losses) if losses > 0 else 99.9
    avg_mae = sum(x["mae"] for x in items) / tot
    print(f"{zone:<22} | {tot:<9} | {mae_05} ({mae_05/tot*100:4.1f}%) | {mae_10} ({mae_10/tot*100:4.1f}%) | {wins} ({win_rate:4.1f}%) | {pf:6.2f} | ${avg_mae:5.2f}")

# 2. GRANULAR BREAKDOWN OF WICK REJECTION BY ZONE TYPE
print("\n" + "=" * 80)
print("2. PHÂN TÍCH 'BẮT RÂU THỂ CHẾ' (INSTITUTIONAL WICK REJECTION) THEO TỪNG VÙNG")
print("=" * 80)
print(f"{'Vùng Cản (Zone)':<22} | {'Tổng Setup':<10} | {'Thắng (TP)':<10} | {'Thua (SL)':<10} | {'Win Rate':<10} | {'Profit Factor':<13} | {'Net R':<8}")
print("-" * 88)

wick_by_zone = defaultdict(list)
for w in wick_records:
    wick_by_zone[w["zone"]].append(w)

for zone, items in sorted(wick_by_zone.items(), key=lambda x: len(x[1]), reverse=True):
    tot = len(items)
    wins = sum(1 for x in items if x["is_win"] == 1)
    losses = tot - wins
    win_rate = (wins / tot) * 100
    pf = (wins * 2.0 / losses) if losses > 0 else 99.9
    net_r = sum(x["r_mult"] for x in items)
    print(f"{zone:<22} | {tot:<10} | {wins:<10} | {losses:<10} | {win_rate:6.2f}%   | {pf:10.2f}    | {net_r:+6.1f}R")

# 3. WICK RATIO THRESHOLD ANALYSIS (ĐỘ DÀI CỦA RÂU ẢNH HƯỞNG GÌ ĐẾN WIN RATE?)
print("\n" + "=" * 80)
print("3. PHÂN TÍCH TỶ LỆ RÂU NẾN (WICK RATIO) ẢNH HƯỞNG TỚI ĐỘ THẮNG")
print("=" * 80)
print(f"{'Ngưỡng Tỷ Lệ Râu':<22} | {'Số Lệnh':<10} | {'Thắng':<8} | {'Thua':<8} | {'Win Rate':<10} | {'Profit Factor':<12} | {'Net R':<8}")
print("-" * 88)

for threshold in [0.35, 0.45, 0.55, 0.65]:
    items = [w for w in wick_records if w["wick_ratio"] >= threshold]
    tot = len(items)
    if tot == 0: continue
    wins = sum(1 for x in items if x["is_win"] == 1)
    losses = tot - wins
    win_rate = (wins / tot) * 100
    pf = (wins * 2.0 / losses) if losses > 0 else 99.9
    net_r = sum(x["r_mult"] for x in items)
    print(f"Râu >= {int(threshold*100)}% thân nến       | {tot:<10} | {wins:<8} | {losses:<8} | {win_rate:6.2f}%   | {pf:10.2f}   | {net_r:+6.1f}R")

# 4. SL DISTANCE ANALYSIS (KHOẢNG CÁCH SL TỪ RÂU NẾN)
print("\n" + "=" * 80)
print("4. PHÂN TÍCH KHOẢNG CÁCH STOP LOSS (SL DISTANCE FROM WICK TIP)")
print("=" * 80)
for sl_min, sl_max, label in [(0.80, 1.80, "SL Rất Nhỏ ($0.80 - $1.80)"),
                             (1.80, 3.00, "SL Tiêu Chuẩn ($1.80 - $3.00)"),
                             (3.00, 6.00, "SL Rộng / Volatility ($3.00 - $6.00)")]:
    items = [w for w in wick_records if sl_min <= w["sl_dist"] < sl_max]
    tot = len(items)
    if tot == 0: continue
    wins = sum(1 for x in items if x["is_win"] == 1)
    losses = tot - wins
    win_rate = (wins / tot) * 100
    pf = (wins * 2.0 / losses) if losses > 0 else 99.9
    net_r = sum(x["r_mult"] for x in items)
    print(f"{label:<32} | {tot:<8} lệnh | {wins} Thắng ({win_rate:5.1f}%) | PF: {pf:5.2f} | Net: {net_r:+6.1f}R")

print("=" * 80)
