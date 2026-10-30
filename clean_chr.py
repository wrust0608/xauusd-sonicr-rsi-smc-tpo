import re

files = [
    r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Profiles\Charts\Default\chart01.chr",
    r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Profiles\Templates\default.tpl",
    r"C:\Users\nvhoa\AppData\Roaming\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Profiles\Templates\XAUUSD_SonicR_System.tpl"
]

def clean_file(path):
    with open(path, "r", encoding="utf-16le") as f:
        content = f.read()

    # 1. In SMC_MarketStructure_Overlay: remove all <graph>...</graph> blocks
    smc_pattern = re.compile(
        r"(path=Indicators\\XAUUSD_Suite\\SMC_MarketStructure_Overlay\.ex5[\s\S]*?)(<graph>[\s\S]*?</graph>\s*)+",
        re.MULTILINE
    )
    content = smc_pattern.sub(r"\1", content)

    # 1b. In TPO_Session_Profile: remove all <graph>...</graph> blocks
    tpo_pattern = re.compile(
        r"(path=Indicators\\XAUUSD_Suite\\TPO_Session_Profile\.ex5[\s\S]*?)(<graph>[\s\S]*?</graph>\s*)+",
        re.MULTILINE
    )
    content = tpo_pattern.sub(r"\1", content)

    # 1c. In RSI_Trend_Pulse_Pane: ensure the 7 <graph> blocks exist
    rsi_graphs = """<graph>
name=RSI 14
draw=1
style=0
width=1
color=16777215
</graph>

<graph>
name=EMA 9 (on RSI)
draw=1
style=0
width=1
color=16776960
</graph>

<graph>
name=WMA 45 (on RSI)
draw=1
style=0
width=2
color=42495
</graph>

<graph>
name=HTF Bull (45)
draw=1
style=0
width=2
color=8388352
</graph>

<graph>
name=HTF Bear (55)
draw=1
style=0
width=2
color=255
</graph>

<graph>
name=Bull Momentum
draw=3
style=0
width=2
arrow=233
color=8388352
</graph>

<graph>
name=Bear Momentum
draw=3
style=0
width=2
arrow=234
color=255
</graph>
"""
    if "name=RSI 14" not in content and "path=Indicators\\XAUUSD_Suite\\RSI_Trend_Pulse_Pane.ex5" in content:
        content = re.sub(
            r"(path=Indicators\\XAUUSD_Suite\\RSI_Trend_Pulse_Pane\.ex5[\s\S]*?fixed_height=-1\s*\n)",
            r"\1" + rsi_graphs,
            content
        )

    # 2. In SonicR_Setup_Overlay: change arrow=159 to arrow=233 for Bull Setup and arrow=234 for Bear Setup
    content = content.replace("InpEnablePopup=true", "InpEnablePopup=false")

    bull_pattern = re.compile(r"(<graph>\s*name=Potential Bull Setup\s*draw=3\s*style=0\s*width=2\s*)arrow=\d+(\s*color=\d+\s*</graph>)")
    content = bull_pattern.sub(r"\g<1>arrow=233\2", content)

    bear_pattern = re.compile(r"(<graph>\s*name=Potential Bear Setup\s*draw=3\s*style=0\s*width=2\s*)arrow=\d+(\s*color=\d+\s*</graph>)")
    content = bear_pattern.sub(r"\g<1>arrow=234\2", content)

    # 3. Clean any empty lines inside <indicator> tags
    content = re.sub(r"\n\s*\n\s*\n+", "\n\n", content)

    # 4. Ensure window_type=3 (maximized) and fore=1 (candlesticks in foreground)
    content = re.sub(r"window_type=\d+", "window_type=3", content)
    content = re.sub(r"fore=\d+", "fore=1", content)
    content = re.sub(r"scale=\d+", "scale=8", content)

    with open(path, "w", encoding="utf-16le") as f:
        f.write(content)
    print(f"Cleaned {path}")

for f in files:
    clean_file(f)
