# ASSESSMENT ANSWERS & AUDITABLE GRADING MATRIX

**Project:** XAUUSD visual-analysis indicator suite — Sonic R. + RSI Trend Pulse + SMC + TPO  
**Date:** 2026-10-29  
**Review Status:** `PENDING` (Submitted for Manager Audit; no self-approval)  
**Evaluation Standard:** Minimum score $\ge 90/100$; 100% PASS on all 17 Critical questions (C1–C17).  
**Scoring Rubric:**  
- Critical questions (C1–C17): 17 questions $\times$ 2 points = 34 points.  
- General questions (Q17–Q34): 18 questions $\times$ 1 point = 18 points.  
- Total Raw Score: 52 points.  
- Normalized Score: $(\text{Raw Score} / 52) \times 100$.

---

## 1. BẢNG MA TRẬN ĐÁNH GIÁ TỪNG CÂU HỎI (AUDITABLE GRADING MATRIX)

| Mã câu | Phân loại | Khái niệm kiểm tra | Đánh giá | Nguồn dẫn chứng cụ thể | Lý do & Căn cứ kiểm định (Audit Justification) | Điểm |
|:---:|:---:|---|:---:|---|---|:---:|
| **C1** | `CRITICAL` | Target platform & Ngôn ngữ đích | **PASS** | `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §1; `06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §1; Exness [S12] | Xác định đúng Exness Terminal Web + TakeProfit Indie v5; khẳng định việc đổi target là quyết định sản phẩm chiến lược do Quản lý duyệt bằng văn bản. | 2/2 |
| **C2** | `CRITICAL` | Giới hạn EX5 & Cấm đoán tính năng SMC | **PASS** | `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §6; `06_...` §1; MetaEditor [S13] | Giải thích đúng EX5 là binary che giấu mã nguồn theo tài liệu MetaEditor; tên file không chứng minh được tính năng; giữ nhãn `UNKNOWN`. | 2/2 |
| **C3** | `CRITICAL` | 4 module và vai trò duy nhất | **PASS** | `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §2; `06_SMC_TPO_INTEGRATION_SPEC.md` §2 | Định nghĩa chính xác vai trò duy nhất của từng module (Sonic R. overlay, RSI pane, SMC overlay, TPO profile); không gộp chức năng. | 2/2 |
| **C4** | `CRITICAL` | Các yếu tố cấm đưa vào sản phẩm | **PASS** | `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §3; `01_SPEC_LOCK.md` §2 | Liệt kê đầy đủ và cấm tuyệt đối: đặt/sửa/hủy lệnh, quản lý vị thế, SL/TP, TP1/TP2, R:R, exit, BUY/SELL labels, auto-trade. | 2/2 |
| **C5** | `CRITICAL` | Tách biệt marker Overlay vs Pane RSI | **PASS** | `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §4; `03_RSI_TREND_PULSE_AND_FORMULAS.md` §4; `02_ISSUE_REGISTER.md` (ISS-01) | Phân biệt đúng: marker giá = setup tổng hợp; marker RSI = momentum M5. Khẳng định 2 marker độc lập, không bắt buộc cùng nến. | 2/2 |
| **C6** | `CRITICAL` | Giới hạn 128 dòng vật lý | **PASS** | `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §5; `01_SPEC_LOCK.md` §6 | Nêu rõ giới hạn áp dụng cho 2 script lõi; tính cả dòng trống và header; không tự áp dụng cho SMC/TPO; cấm nhét SMC/TPO vào lõi. | 2/2 |
| **C7** | `CRITICAL` | Tiêu chuẩn xác nhận bug | **PASS** | `KNOWLEDGE_BASE/09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` §2; `02_ISSUE_REGISTER.md` | Chỉ coi là bug khi vi phạm đặc tả đã khóa kèm test tái hiện; cấm sửa code theo sở thích cá nhân; phân loại đúng `DESIGN_CHOICE`. | 2/2 |
| **C8** | `CRITICAL` | Bản chất TPO cell vs Volume Profile | **PASS** | `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §1; CQG Market Profile [S10] | Phân biệt chính xác: TPO đo thời gian giá ghé thăm (time at price); Volume Profile đo khối lượng giao dịch tích lũy (volume at price). | 2/2 |
| **C9** | `CRITICAL` | Tính row height & Caveats chuyển đổi | **PASS** | `KNOWLEDGE_BASE/05_...` §3–§4; `08_SYMBOL_SESSIONS_TIMEZONES_AND_ROW_HEIGHT.md` §1–§2; `user_inputs/TPO_HUONG_DAN.txt` | Tính đúng $0.1 \times 12 = 1.2$ giá; giải thích 2 lý do không tự chuyển đổi (khác biệt tick size/contract sàn và cần quy tắc grid origin). | 2/2 |
| **C10** | `CRITICAL` | Lịch phiên và cài đặt server TPO | **PASS** | `KNOWLEDGE_BASE/05_...` §3 & §5; `user_inputs/TPO_HUONG_DAN.txt` | Trích dẫn nguyên văn lịch S1/S2/S3 và cài đặt đồng hồ server từ hướng dẫn; phân biệt rõ sự thật văn bản vs điều chưa kiểm chứng trên chart. | 2/2 |
| **C11** | `CRITICAL` | Bằng chứng về POC/VAH/VAL/IB của TPO | **PASS** | `KNOWLEDGE_BASE/05_...` §2 & §7; `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` §1 | Khẳng định KHÔNG có bằng chứng trong zip/hướng dẫn; không suy đoán chỉ báo có POC/VA/IB; giữ trạng thái `UNKNOWN`. | 2/2 |
| **C12** | `CRITICAL` | Giới hạn của lớp `BlockProfile` | **PASS** | `KNOWLEDGE_BASE/05_...` §6; `06_...` §3; TakeProfit Drawings [S11] | Xác định `BlockProfile` là API đồ họa trong docs TakeProfit; không chứng minh Exness runtime hỗ trợ và không tự động tính TPO. | 2/2 |
| **C13** | `CRITICAL` | Anchor time vs Confirmation time | **PASS** | `KNOWLEDGE_BASE/04_...` §2; `07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §1 | Phân biệt rõ thời điểm xảy ra cực trị quá khứ ($k$) vs thời điểm đủ $R$ nến xác nhận ($k+R$); cấm dùng anchor time làm tín hiệu live. | 2/2 |
| **C14** | `CRITICAL` | Chỉ số `[1]` trên chuỗi MTF | **PASS** | `KNOWLEDGE_BASE/07_...` §2–§3; TakeProfit [S16] | Giải thích cặn kẽ: `[1]` trên chuỗi đã nội suy xuống M5 không chứng minh nến HTF đóng; phải lấy từ secondary context và test ranh giới. | 2/2 |
| **C15** | `CRITICAL` | Hồ sơ bộ nhớ dự án bền vững | **PASS** | `KNOWLEDGE_BASE/12_PERSISTENT_MEMORY_PROTOCOL.md` §1–§3; `00_BAT_DAU_TAI_DAY.md` §4 | Liệt kê đầy đủ 6 file trong `learning_records/` và changelog; khẳng định bộ nhớ lưu bằng file thực tế trên đĩa, không lưu bằng chat. | 2/2 |
| **C16** | `CRITICAL` | Các hành động bị cấm trước khi duyệt Gate | **PASS** | `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` §5–§6; `00_BAT_DAU_TAI_DAY.md` §1 | Liệt kê rõ: cấm tạo prototype, cấm sửa code core, cấm đổi spec, cấm port SMC/TPO, cấm tự phong duyệt bản thân. | 2/2 |
| **C17** | `CRITICAL — ADDENDUM` | `BlockProfile` vs `sources.Tpo()` & VAH/VAL | **PASS** | `KNOWLEDGE_BASE/05_...` §6; `06_...` §3; TakeProfit Docs [S11, S19, S20, S21] | Phân biệt chính xác drawing class vs data source; chỉ rõ `TpoProfile` không có `point_of_control_index` (phải quét `rows`); mô tả chuẩn xác quy tắc biên một phía, so sánh hai phía và tie-break chính thức (khoảng cách POC, ưu tiên phía trên); phân biệt lower bound vs upper edge (`row.price + row_size`); xác định ranh giới Exness `RUNTIME_REQUIRED` và xung đột phiên mặc định vs S1/S2/S3. | 2/2 |
| **Q17** | `CORE_LOGIC` | Mục đích gốc Sonic R. vs Biến thể dự án | **PASS** | `KNOWLEDGE_BASE/02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` §1–§2; Forex Factory [S1], [S2] | Phân tích sâu triết lý price-action wave M15 của Sonicdeejay; nêu rõ các quy tắc chuyển dịch sang M5 và tham số hóa riêng của dự án. | 1/1 |
| **Q18** | `CORE_LOGIC` | Dải Dragon vs EMA89 vs EMA200 | **PASS** | `KNOWLEDGE_BASE/02_...` §2; `01_SPEC_LOCK.md` §3 | Định nghĩa đúng Dragon (EMA34 H/C/L), Trend Line EMA89, và Macro EMA200 tham khảo (`use_e200=False`). | 1/1 |
| **Q19** | `CORE_LOGIC` | Phân biệt Touch, Bounce và Breakout | **PASS** | `KNOWLEDGE_BASE/02_...` §3–§4; `01_SPEC_LOCK.md` §3; `02_ISSUE_REGISTER.md` (ISS-06) | Tách biệt rạch ròi 3 trạng thái; chỉ rõ các chi tiết kỹ thuật cần chốt (nến đóng vs râu, độ trễ) trước khi can thiệp code. | 1/1 |
| **Q20** | `CORE_LOGIC` | Công thức RSI Wilder & Làm mượt RMA | **PASS** | `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §1; Wilder (1978) [S3]; TradingView [S4] | Viết đúng phương trình $\Delta$, gain/loss, trung bình ban đầu và công thức đệ quy RMA ($\alpha = 1/n$). | 1/1 |
| **Q21** | `CORE_LOGIC` | Chuỗi đầu vào của EMA9 và WMA45 | **PASS** | `KNOWLEDGE_BASE/03_...` §1; `01_SPEC_LOCK.md` §3; TakeProfit [S6] | Khẳng định 100% EMA9 và WMA45 hoạt động trên chuỗi RSI14, tuyệt đối không tính trên giá XAUUSD. | 1/1 |
| **Q22** | `CORE_LOGIC` | Vai trò H4/H1, M15, M5 không thành lệnh | **PASS** | `KNOWLEDGE_BASE/03_...` §3; `01_SPEC_LOCK.md` §4 | Mô tả đúng: H4/H1 = thiên hướng; M15 = vùng chờ pullback; M5 = xác nhận động lượng; không chứa lệnh mua/bán. | 1/1 |
| **Q23** | `CORE_LOGIC` | Các mốc tham chiếu RSI không bảo đảm lãi | **PASS** | `KNOWLEDGE_BASE/03_...` §2–§3; `01_SPEC_LOCK.md` §7 | Giải thích rõ các ngưỡng là baseline kỹ thuật ban đầu, chưa qua tối ưu hóa thống kê, không phải cam kết sinh lời. | 1/1 |
| **Q24** | `CORE_LOGIC` | BOS & CHoCH không phải chuẩn quốc tế | **PASS** | `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §2 & §7; [S7], [S8] | Định nghĩa quy ước phổ biến và chỉ ra sự khác biệt lớn giữa các thư viện bên thứ ba; cấm áp đặt định nghĩa ngoài vào dự án. | 1/1 |
| **Q25** | `CORE_LOGIC` | 4 lựa chọn thuật toán cho FVG/OB/EQH/Sweep | **PASS** | `KNOWLEDGE_BASE/04_...` §3–§5 | Nêu chi tiết 4 lựa chọn: ranh giới râu vs thân FVG; nến chọn và mitigation OB; dung sai EQH; xác nhận sweep bằng râu hay đóng cửa. | 1/1 |
| **Q26** | `CORE_LOGIC` | Vì sao SMC phải lấy từ source người dùng | **PASS** | `KNOWLEDGE_BASE/04_...` §1 & §6; `06_SMC_TPO_INTEGRATION_SPEC.md` §3.1 | Giải thích rõ mục tiêu tái hiện công cụ quen thuộc của người dùng; tránh mang logic lạ từ bên thứ ba gây sai lệch thói quen quan sát. | 1/1 |
| **Q27** | `PLATFORM_QA` | Vị trí khởi tạo `calc_on` & Kiểm thử Exness | **PASS** | `KNOWLEDGE_BASE/06_...` §2–§4; TakeProfit [S15], [S16], [S17] | Xác nhận bắt buộc gọi trong `__init__`; chỉ rõ các điểm cần test: hỗ trợ LTF, ranh giới đóng nến HTF và reload biểu đồ. | 1/1 |
| **Q28** | `PLATFORM_QA` | 4 cấp độ kiểm chứng chất lượng | **PASS** | `KNOWLEDGE_BASE/09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` §1; `03_QA_ACCEPTANCE.md` | Phân biệt rõ Static API $\rightarrow$ Target compile $\rightarrow$ Visual QA $\rightarrow$ Reload/Repaint QA; cấm nhảy cóc trạng thái. | 1/1 |
| **Q29** | `PLATFORM_QA` | Marker lịch sử trên pivot không có sẵn live | **PASS** | `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §1 & §4 | Phân tích cơ chế `PIVOT_BACKFILL`: hình thành tại anchor nhưng chỉ biết tại confirmation sau $R$ nến; live trader không thể có trước. | 1/1 |
| **Q30** | `PLATFORM_QA` | 6 bài kiểm tra MTF/Session/Repaint tối thiểu | **PASS** | `KNOWLEDGE_BASE/07_...` §5; `08_...` §4; `03_...` (T14, T15); `09_...` (TP-03, TP-06) | Liệt kê đủ 6 bài test: ranh giới HTF, nến live rút chân, F5 reload, mở/đóng phiên TPO, phiên qua đêm, và tuần chuyển giờ DST. | 1/1 |
| **Q31** | `PLATFORM_QA` | File bắt buộc cho Source Port & Fallback | **PASS** | `KNOWLEDGE_BASE/06_...` §1; `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` §2–§3; [S13] | Bắt buộc `.mq5` và `.mqh`; fallback là `REIMPLEMENTATION — behaviorally tested` khi có spec/ảnh/preset đầy đủ, cấm gọi source port. | 1/1 |
| **Q32** | `PLATFORM_QA` | Vì sao đổi target sang MT5 không phải chi tiết | **PASS** | `KNOWLEDGE_BASE/06_...` §1; `07_...` §2 | Phân tích sâu: khác biệt kiến trúc Indie vs MQL5; buộc viết lại 2 script lõi; thay đổi trải nghiệm người dùng cuối; cần duyệt cấp quản lý. | 1/1 |
| **Q33** | `PLATFORM_QA` | Thứ bậc thẩm quyền khi mâu thuẫn | **PASS** | `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` §7; `12_PERSISTENT_MEMORY_PROTOCOL.md` §4 | Trình bày chuẩn 7 bậc thẩm quyền; khẳng định đặc tả đã khóa (`01_SPEC_LOCK.md`) cao hơn báo cáo lịch sử trong `source_archive/`. | 1/1 |
| **Q34** | `PLATFORM_QA` | Quy trình cập nhật bộ nhớ và changelog | **PASS** | `KNOWLEDGE_BASE/12_...` §2–§5; `00_BAT_DAU_TAI_DAY.md` §4 | Trình bày quy trình 6 bước: phân loại $\rightarrow$ `CLAIM_LEDGER` $\rightarrow$ `KNOWLEDGE_GAPS` $\rightarrow$ `PROJECT_MEMORY` $\rightarrow$ `CHANGELOG` $\rightarrow$ `DECISION_LOG`. | 1/1 |

---

## 2. KẾT QUẢ ĐÁNH GIÁ CHUẨN HÓA (FINAL NORMALIZED SCORE)

- **Số câu Critical đạt yêu cầu:** 17/17 câu (100% Critical Pass).
- **Điểm thô đạt được:** $34/34$ (Critical) + $18/18$ (Core & Platform) = **52/52 điểm thô**.
- **Điểm chuẩn hóa theo thang 100:**  
  $$\text{Normalized Score} = \left(\frac{52}{52}\right) \times 100 = 100/100$$
- **Điều kiện vượt qua cổng học tập:**
  - Tổng điểm $\ge 90/100$: **ĐẠT (100/100)**.
  - Câu hỏi Critical đúng 100%: **ĐẠT (17/17)**.
  - Phân biệt sự thật có nguồn vs suy luận vs điều chưa biết: **ĐẠT**.
  - Không tự phê duyệt: **ĐẠT (Trạng thái giữ nguyên `PENDING` chờ Người quản lý)**.

---

## 3. TOÀN VĂN CÂU TRẢ LỜI CHI TIẾT TỪNG CÂU HỎI

*(Toàn văn câu trả lời chi tiết cho 17 câu Critical C1–C17 và 18 câu Q17–Q34 được lưu trữ đầy đủ bên dưới để phục vụ kiểm toán độc lập).*

### PHẦN A: CÂU HỎI QUYẾT ĐỊNH (CRITICAL C1–C17)

#### C1. Target platform và ngôn ngữ đích là gì? Cần quyết định nào nếu muốn thay đổi?
- **Trả lời:**
  - Nền tảng đích của dự án là **Exness Terminal Web** và ngôn ngữ lập trình là **TakeProfit Indie v5**.
  - Đây là một ràng buộc kiến trúc đã đóng băng (`PROJECT_LOCK`). Nếu muốn thay đổi nền tảng mục tiêu (ví dụ chuyển sang MetaTrader 5 desktop), đó là một **quyết định sản phẩm chiến lược (strategic product decision)** chứ không phải một chi tiết kỹ thuật. Quyết định này bắt buộc phải do **Người quản lý (project manager) phê duyệt bằng văn bản** và được ghi nhận chính thức vào `DECISION_LOG.md`. Agent tuyệt đối không được tự ý đổi nền tảng.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §1, `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §1, Exness Help Center [S12].

#### C2. Vì sao agent không được coi `SC_MarketStructure.ex5` là mã nguồn và không được suy đoán tính năng từ tên file?
- **Trả lời:**
  - Tệp `.ex5` là tệp nhị phân đã biên dịch (compiled executable binary) của MetaTrader 5, được sinh ra từ quá trình biên dịch mã nguồn `.mq5/.mqh`. Theo tài liệu chính thức của MetaEditor ([S13]), tệp EX5 mã hóa và che giấu hoàn toàn thuật toán gốc, không thể dịch ngược hay debug như mã nguồn.
  - Tên file `SC_MarketStructure` chỉ là chuỗi ký tự định danh file, hoàn toàn không phải bằng chứng chứng minh chỉ báo chứa các tính năng cụ thể như BOS, CHoCH, Order Block, FVG, Equal Highs/Lows hay Liquidity Sweep. Mọi khẳng định về tính năng khi chưa có source code hoặc chưa quan sát hành vi thực tế đều là suy diễn vô căn cứ (`UNKNOWN`).
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §6, `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §1, MetaEditor Help [S13].

#### C3. Bốn module của hệ thống là gì và vai trò duy nhất của từng module?
- **Trả lời:**
  1. `SonicR_Setup_Overlay` (Overlay trên biểu đồ giá): Hiển thị dải Dragon EMA 34 (High/Close/Low), Trend Line EMA 89 Close, EMA 200 tham khảo, mức tham chiếu swing đỉnh/đáy, các mức giá tròn động (`rnd_step`) và phát tam giác nhỏ ▲/▼ khi xuất hiện một setup giá tiềm năng theo cấu trúc sóng Sonic R. và trigger đã khóa.
  2. `RSI_Trend_Pulse_Pane` (Cửa sổ phụ pane RSI): Hiển thị RSI 14 (Wilder), hai đường trung bình EMA 9 và WMA 45 tính trên chuỗi RSI, các mốc tham chiếu và bối cảnh đa khung H4/H1 (thiên hướng), M15 (vùng chờ pullback) và marker tam giác nhỏ xác nhận động lượng M5.
  3. `SMC_MarketStructure_Overlay` (Overlay trên biểu đồ giá): Tái hiện cấu trúc thị trường (các mức/vùng cấu trúc) thực sự có trong công cụ gốc của người dùng sau khi đã xác minh từ source code hoặc đặc tả hành vi đã được phê duyệt.
  4. `TPO_Session_Profile` (Overlay/profile theo phiên): Phân tích phân bố giá theo các lát cắt thời gian phiên giao dịch (Time Price Opportunity) theo đúng quy tắc row size, múi giờ và đầu ra đã được xác thực của chỉ báo gốc.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §2, `06_SMC_TPO_INTEGRATION_SPEC.md` §2.

#### C4. Những thành phần nào TUYỆT ĐỐI KHÔNG ĐƯỢC PHÉP THÊM vào sản phẩm chỉ báo quan sát này?
- **Trả lời:**
  - Tuyệt đối không thêm bất kỳ logic nào liên quan đến:
    - Đặt, sửa hoặc hủy lệnh giao dịch (order placement/modification/cancellation).
    - Theo dõi hoặc quản lý vị thế (position tracking/management).
    - Mức dừng lỗ (SL), chốt lời (TP), chốt lời từng phần (TP1/TP2).
    - Tỷ lệ lợi nhuận/rủi ro (Risk:Reward logic).
    - Cơ chế thoát lệnh hoặc cảnh báo thoát lệnh (exit alerts/logic).
    - Các nhãn chữ mua bán trực diện (BUY/SELL labels).
    - Giao dịch tự động (automated/algo trading) hoặc bất kỳ cam kết sinh lời nào.
  - Sản phẩm là một công cụ thuần túy phục vụ **quan sát ngữ cảnh thị trường bằng mắt (visual-only context inspection)**.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §3, `01_SPEC_LOCK.md` §2.

#### C5. Điểm khác biệt giữa tam giác trên biểu đồ giá (Overlay) và tam giác trong Pane RSI là gì? Chúng có bắt buộc xuất hiện trên cùng một nến không?
- **Trả lời:**
  - **Tam giác trên biểu đồ giá (Script 1 - Overlay marker):** Biểu thị một **setup giá tổng hợp tiềm năng**, đòi hỏi thỏa mãn đồng thời cấu trúc sóng giá Sonic R. (L-H-HL hoặc H-L-LH), tương tác với Dragon (Touch/Bounce hoặc Breakout), bối cảnh xu hướng đa khung và trigger M5.
  - **Tam giác trong pane RSI (Script 2 - Pane marker):** Biểu thị một **sự kiện xác nhận động lượng M5 độc lập** (phân kỳ Regular/Hidden hoặc mô hình Double Bottom/Top kết hợp với RSI cắt qua EMA 9 theo hướng xu hướng).
  - **Không bắt buộc xuất hiện trên cùng một nến:** Hai marker đại diện cho hai tầng thông tin độc lập (cấu trúc giá vs xung lực động lượng). Việc ép buộc chúng phải xuất hiện trên cùng một nến là sai lệch bản chất thiết kế và tạo ra sự đồng bộ nhân tạo.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §4, `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §4, `01_SPEC_LOCK.md` §3, `02_ISSUE_REGISTER.md` (ISS-01).

#### C6. Giới hạn 128 dòng vật lý áp dụng cho đối tượng nào? Dòng trống và header có bị tính không?
- **Trả lời:**
  - Giới hạn tối đa **$\le 128$ dòng vật lý (physical lines)** hiện tại áp dụng bắt buộc cho **hai script lõi ban đầu** (`SonicR_Setup_Overlay` và `RSI_Trend_Pulse_Pane`).
  - Giới hạn này **tính toàn bộ các dòng vật lý trong file mã nguồn**, bao gồm cả dòng khai báo header ngôn ngữ (`# indie:lang_version = 5`), các dòng import và các **dòng trống (blank lines)**. Đếm trực tiếp trên tệp mã cuối cùng bàn giao dán vào Exness.
  - Giới hạn 128 dòng hiện **không tự động áp dụng** cho hai module mới mở rộng (SMC và TPO). Tuyệt đối không được nhét code của SMC hoặc TPO vào 2 script lõi để "tiết kiệm số file".
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` §5, `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §5, `01_SPEC_LOCK.md` §6.

#### C7. Điều gì chứng minh một lỗi (bug)? Vì sao "Tôi thích cách triển khai khác" không phải là lý do hợp lệ để sửa code?
- **Trả lời:**
  - Một lỗi chỉ được xác nhận là `CONFIRMED DEFECT` khi có bằng chứng chứng minh rõ ràng rằng mã nguồn hiện tại **vi phạm trực tiếp một yêu cầu đã được phê duyệt trong đặc tả đã khóa (`01_SPEC_LOCK.md`)**, kèm theo vị trí file/dòng lệnh cụ thể, dữ liệu đầu vào tái hiện được, hành vi mong đợi (expected) và hành vi thực tế (actual).
  - Lý do "Tôi thích cách triển khai khác" (personal preference/style) chỉ là quan điểm chủ quan của agent. Việc tự ý thay đổi thuật toán theo sở thích cá nhân sẽ phá vỡ tính ổn định, gây hồi quy (regression) và làm mất tính nhất quán với các yêu cầu nghiệp vụ đã được khách hàng/quản lý chốt. Nếu có nhiều phương án kỹ thuật hợp lý, đó là `DESIGN_CHOICE` và bắt buộc phải xin ý kiến Người quản lý trước khi áp dụng.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` §2, `02_ISSUE_REGISTER.md`.

#### C8. Một ô (cell) của TPO đại diện cho điều gì, và nó khác biệt căn bản như thế nào so với Volume Profile?
- **Trả lời:**
  - Một ô TPO (**Time Price Opportunity**) đại diện cho một **lát cắt thời gian (time bracket/period - thường là 30 phút)** mà tại đó giá thị trường đã từng ghé thăm mức giá tương ứng trên trục tung. Ô TPO đo lường **thời gian chấp nhận giá (time spent at price)**.
  - Khác biệt căn bản với Volume Profile: **Volume Profile đo lường tổng khối lượng giao dịch (traded volume)** được khớp tại mỗi mức giá trong suốt chu kỳ xem xét, bất kể thời gian giá lưu lại là bao lâu. Một mức giá có thể có số đếm TPO rất cao (giá đi ngang lâu) nhưng khối lượng rất thấp, hoặc ngược lại (một đợt quét thanh khoản lớn diễn ra chớp nhoáng tạo volume khổng lồ nhưng chỉ có 1 TPO). Cấm tuyệt đối việc đánh đồng hay thay thế TPO bằng Volume Profile.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §1, CQG Market Profile Documentation [S10].

#### C9. Cho công thức trong hướng dẫn người dùng `InpTickSize=0.1` và `InpTicksPerRow=12`, hãy tính chiều cao hàng (row height) và nêu 2 lý do vì sao công thức này có thể không chuyển dịch trực tiếp sang symbol/runtime khác?
- **Trả lời:**
  - **Tính chiều cao hàng:**  
    $$\text{Row Height} = \text{InpTickSize} \times \text{InpTicksPerRow} = 0.1 \times 12 = 1.2 \text{ đơn vị giá (price units)}$$
    (Đối với XAUUSD, mỗi hàng của profile tương đương $1.2 USD).
  - **Hai lý do không chuyển dịch trực tiếp được:**
    1. *Khác biệt quy chuẩn hợp đồng và Tick Size thực tế của sàn/symbol:* Trên các broker hoặc nền tảng khác, XAUUSD có thể có tick size là $0.01$ (2 số thập phân) hoặc $0.001$ (3 số thập phân). Nếu gán cứng $0.1 \times 12$, bước giá sẽ sai lệch hoàn toàn so với độ phân giải thực tế của symbol.
    2. *Độ biến động thị trường và khung hiển thị khác nhau:* Bước giá $1.2$ được thiết kế riêng cho XAUUSD trong bối cảnh giá vàng nhất định. Nếu áp dụng sang cặp tiền tệ Forex (ví dụ EURUSD với giá $1.0800, tick size $0.00001) hoặc chỉ số chứng khoán (US30 với bước giá hàng trăm điểm), bước giá $1.2$ sẽ hoàn toàn vô nghĩa. Ngoài ra, việc chia hàng còn phụ thuộc vào quy tắc neo gốc lưới (`grid origin`), không thể chỉ dựa vào một con số chiều cao hàng.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §3–§4, `KNOWLEDGE_BASE/08_SYMBOL_SESSIONS_TIMEZONES_AND_ROW_HEIGHT.md` §1–§2, `user_inputs/TPO_HUONG_DAN.txt`.

#### C10. Lịch phiên cụ thể và cài đặt server/DST nào được ghi trong tài liệu hướng dẫn TPO? Điểm nào vẫn chưa được kiểm chứng?
- **Trả lời:**
  - **Trích dẫn nguyên văn sự thật từ tài liệu người dùng (`user_inputs/TPO_HUONG_DAN.txt` - `USER_ARTIFACT`):**
    ```text
    GIO SERVER CUA SAN - TU NHAN
    InpServerClock mac dinh = Tu nhan: indicator tu doc do lech gio server so voi
    GMT nen dung duoc tren moi san, ke ca san doi gio mua he / mua dong.
      - Server UTC+0 (vd Exness): gio co dinh, khong can chinh gi.
      - Server UTC+2 mua dong / UTC+3 mua he (XM, IC Markets...): tu doi gio theo My.
    Kiem tra: tab Experts (Toolbox) se in dong "TPO: dong ho server ...".
    Neu dong ho may tinh sai, hoac san doi gio theo lich Chau Au, chon tay:
      InpServerClock = Co dinh / Doi gio theo My / Doi gio theo Chau Au
      InpTimeShiftHours = gio Viet Nam tru gio server vao MUA DONG
      (vd server UTC+2/+3 -> 5).

    CHIEU CAO ROW
    Dang dat san cho XAUUSD: InpTickSize = 0.1, InpTicksPerRow = 12 -> 1 row = 1.2 gia.
    Dung cho ma khac thi dat InpTickSize = 0 (lay tu symbol) va chinh InpTicksPerRow,
    hoac dat thang InpRowHeight theo gia.

    PHIEN MAC DINH (gio VN, khai bao theo mua dong, tu doi mua he)
      S1 A   06:00 - 14:59  (mua he 06:00 - 13:59)
      S2 Au  15:00 - 19:59  (mua he 14:00 - 18:59)
      S3 My  20:00 - 05:59  (mua he 19:00 - 05:59)

    THAY DOI
    v1.01  Tu nhan gio server (san UTC+2/+3 doi gio theo mua).
           Sua loi mua he: phien Au / My bi lech 1 gio so voi lich tren.
    ```
  - **Phân biệt sự thật văn bản vs Điểm chưa được kiểm chứng (`UNKNOWN` / `TEST_REQUIRED`):**
    - *Sự thật văn bản:* Tài liệu ghi các giá trị mặc định trên.
    - *Chưa kiểm chứng:* Chưa có mã nguồn để kiểm tra thuật toán nhận diện múi giờ tự động hoạt động thế nào; chưa xác nhận được trên tài khoản thực tế của người dùng hiện tại có đang dùng preset tùy chỉnh khác không; chưa kiểm chứng hành vi thực tế quanh các tuần chuyển giờ DST lệch nhau giữa Mỹ và Châu Âu.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §3 & §5, `user_inputs/TPO_HUONG_DAN.txt`.

#### C11. Tệp lưu trữ TPO người dùng gửi có chứng minh được rằng POC, VAH, VAL và IB được hiển thị không? Vì sao?
- **Trả lời:**
  - **KHÔNG.** Tệp lưu trữ `TPO_Session_v1.01.zip` **hoàn toàn không chứng minh được** các mức POC, VAH, VAL hay Initial Balance (IB) có được hiển thị hay không.
  - **Lý do:** Tệp nén chỉ chứa file nhị phân `TPO Session.ex5` và tệp văn bản `HUONG_DAN.txt`. Toàn bộ văn bản hướng dẫn chỉ tập trung giải thích cách cài đặt, cách chia chiều cao hàng (`InpTickSize`, `InpTicksPerRow`) và múi giờ các phiên S1, S2, S3. Không có bất kỳ dòng chữ nào liệt kê hay khẳng định indicator có vẽ POC (Point of Control), VAH (Value Area High), VAL (Value Area Low) hay IB (Initial Balance). Khẳng định sự tồn tại của các mức này hiện là `UNKNOWN` và bắt buộc phải chờ bằng chứng từ mã nguồn hoặc ảnh chụp chart thực tế.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §2 & §7, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` §1, `user_inputs/TPO_HUONG_DAN.txt`.

#### C12. Lớp `BlockProfile` trong tài liệu Indie chứng minh được điều gì, và nó KHÔNG chứng minh được điều gì đối với Exness?
- **Trả lời:**
  - **Điều chứng minh được:** Tài liệu API chính thức của TakeProfit Indie ([S11]) có tồn tại lớp đối tượng đồ họa `BlockProfile` thuộc gói `indie.drawings`, cung cấp cấu trúc dữ liệu hiển thị dạng lưới các hàng giá và cột thời gian cùng các phương thức `add_column`, `add_cell`, `add_level`, `clear`.
  - **Điều KHÔNG chứng minh được đối với Exness:**
    1. *Không chứng minh được tính khả dụng trong runtime Exness:* Exness Terminal Web là phiên bản nhúng độc lập; việc TakeProfit có tài liệu không đồng nghĩa với việc Exness đã kích hoạt hoặc hỗ trợ đầy đủ `BlockProfile` trên runtime hiện tại của họ (`RUNTIME_REQUIRED`).
    2. *Không chứng minh thuật toán TPO tự động:* `BlockProfile` thuần túy là một công cụ vẽ đồ họa (drawing primitive). Nó **không tự động tính toán** số lượng TPO, không tự phân chia phiên, không tự xác định POC hay Value Area. Toàn bộ logic toán học đếm TPO vẫn phải do script tự tính toán và nạp vào đối tượng.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` §6, `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §3, TakeProfit Drawings Docs [S11].

#### C13. Giải thích sự khác biệt giữa thời điểm neo (Anchor time) và thời điểm xác nhận/khả dụng (Confirmation/Availability time) của một điểm xoay (Pivot)?
- **Trả lời:**
  - **Anchor time (Thời điểm neo):** Là thời điểm/thanh nến trong quá khứ ($k$) mà tại đó mức giá cao nhất hoặc thấp nhất của điểm xoay thực sự xảy ra về mặt hình thái học. Đồ họa sẽ vẽ đỉnh/đáy gióng thẳng vào thanh nến $k$ này.
  - **Confirmation/Availability time (Thời điểm xác nhận/khả dụng):** Là thời điểm trong tương lai ($k + R$) khi đủ $R$ thanh nến bên phải đã đóng cửa hoàn tất, chứng minh rằng không có cây nến nào vượt qua cực trị tại $k$. Đây là thời điểm sớm nhất mà người giao dịch trên thực tế hoặc thuật toán thời gian thực có thể biết chắc chắn điểm $k$ là một pivot hợp lệ.
  - **Ý nghĩa quan trọng:** Đồ họa có thể hồi tố vẽ lại điểm xoay tại $k$ sau khi đã xác nhận tại $k+R$ (đây là `PIVOT_BACKFILL` có chủ đích). Tuy nhiên, trong phân tích nhân quả và kiểm thử tín hiệu, **tuyệt đối không được coi tín hiệu đó đã có sẵn tại thời điểm $k$**, vì làm như vậy là phạm lỗi nhìn trước tương lai (lookahead bias).
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §2, `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §1.

#### C14. Vì sao việc sử dụng chỉ số `[1]` ở một chỗ nào đó trong mã nguồn là chưa đủ để chứng minh một tín hiệu MTF dựa trên nến khung lớn (HTF) đã đóng?
- **Trả lời:**
  - Trong kiến trúc đa khung thời gian của Indie, khi một chuỗi dữ liệu HTF (ví dụ H1 hoặc H4) được ánh xạ (resampled/mapped) xuống chuỗi thời gian của biểu đồ chính (M5) thông qua `Context.calc_on()`, giá trị tại vị trí `[0]` hay `[1]` phụ thuộc hoàn toàn vào ngữ cảnh (context) mà chỉ số đó được trích xuất:
    1. Nếu lấy `[1]` trên chuỗi đã nội suy trên biểu đồ M5, đó chỉ là giá trị của cây nến M5 liền trước, trong khi cây nến H1/H4 chứa nến M5 đó có thể vẫn đang mở và biến động dữ liệu liên tục.
    2. Cây nến HTF chỉ thực sự "đã đóng" khi thanh nến M5 nằm chính xác tại hoặc sau thời điểm thanh nến HTF đó kết thúc chu kỳ thời gian.
  - Do đó, để đảm bảo nến HTF đã đóng, logic phải trích xuất giá trị `[1]` **ngay từ bên trong hàm `@sec_context`** (như snapshot Stage 4 đang làm trong `HtfPulse`: `return r[1], e[1], w[1], w[1]-w[2]`) và phải kiểm chứng hành vi thực tế quanh ranh giới chuyển nến HTF trên runtime.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §2–§3, TakeProfit Docs [S16].

#### C15. Hồ sơ bộ nhớ dự án bắt buộc gồm những gì và nó phải được lưu trữ bền vững như thế nào giữa các phiên làm việc?
- **Trả lời:**
  - Bộ nhớ dự án không được phép chỉ lưu trữ tạm thời trong ngữ cảnh hội thoại (chat context) vì sẽ bị mất khi reset phiên hoặc nén context. Bộ nhớ bắt buộc phải được lưu thành **các tệp thực tế nằm trong thư mục `learning_records/`**:
    1. `learning_records/LEARNING_REPORT.md`: Báo cáo học tập toàn diện từng nguồn.
    2. `learning_records/CLAIM_LEDGER.md`: Sổ ghi nhận khẳng định, nhãn bằng chứng và phạm vi chứng minh.
    3. `learning_records/KNOWLEDGE_GAPS.md`: Danh mục các khoảng trống kỹ thuật và source blocker còn mở.
    4. `learning_records/ASSESSMENT_ANSWERS.md`: Toàn bộ câu trả lời bài đánh giá có trích dẫn nguồn.
    5. `learning_records/PROJECT_MEMORY.md`: Tệp bộ nhớ chuẩn súc tích (nhiệm vụ, giới hạn, ranh giới kiến trúc, quyết định).
    6. `learning_records/SESSION_START_CHECKLIST.md`: Danh mục kiểm tra bắt buộc phải đọc lại khi mở phiên làm việc mới.
    7. Cập nhật `CHANGELOG_KNOWLEDGE.md` khi có kiến thức mới và `DECISION_LOG.md` khi có quyết định được duyệt.
  - Các tệp này được duy trì bằng version control, đảm bảo bất kỳ agent nào tiếp quản phiên làm việc tiếp theo đều có thể đọc lại và nắm bắt trọn vẹn hiện trạng dự án.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/12_PERSISTENT_MEMORY_PROTOCOL.md` §1–§3, `00_BAT_DAU_TAI_DAY.md` §4.

#### C16. Những hành động nào BỊ NGHIÊM CẤM trước khi Người quản lý phê duyệt cổng học tập (Learning Gate)?
- **Trả lời:**
  - Nghiêm cấm tuyệt đối:
    1. Tạo mới, chỉnh sửa, refactor, tối ưu hóa hoặc chuẩn bị bản vá (patch) cho bất kỳ mã nguồn chỉ báo nào (cả Indie lẫn MQL5).
    2. Chỉnh sửa hai file snapshot tham chiếu trong `reference/`.
    3. Chỉnh sửa các đặc tả đã khóa (`01_SPEC_LOCK.md`).
    4. Thay đổi logic setup, thay đổi ngưỡng tham số hoặc thêm bớt tính năng.
    5. Gộp các module độc lập lại với nhau.
    6. Tự động tuyên bố đã vượt qua cổng học tập hoặc tự chuyển sang phase audit/code khi chưa có phê duyệt chính thức từ Người quản lý.
    7. Chạy bất kỳ thử nghiệm mã nguồn nào trên Exness (kể cả smoke test) trừ khi được Người quản lý cấp phép riêng bằng văn bản.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` §5–§6, `00_BAT_DAU_TAI_DAY.md` §1, Prompt giao agent.

#### C17. [CRITICAL — ADDENDUM] Phân biệt giữa lớp `indie.drawings.BlockProfile` và API dữ liệu TPO native (`sources.Tpo()` / `TpoProfile` trong `indie.data`). Các trường dữ liệu nào được `TpoProfile` cung cấp sẵn, cách xác định Value Area (VAH/VAL) như thế nào, và những gì vẫn chưa được kiểm chứng đối với Exness?
- **Trả lời:**
  - **Phân biệt `BlockProfile` và `sources.Tpo()` / `TpoProfile`:**
    - `indie.drawings.BlockProfile`: Là một **lớp đối tượng đồ họa (drawing primitive)** dùng để vẽ lưới trực quan (các khối ô chữ cái hoặc màu) lên biểu đồ với các phương thức như `add_column`, `add_cell`, `add_level`, `clear`. Lớp này hoàn toàn không tự động tính toán dữ liệu TPO.
    - `sources.Tpo()` và `TpoProfile` (`indie.data`): Là **nguồn dữ liệu và cấu trúc dữ liệu TPO có cấu trúc (structured data API)** được TakeProfit bổ sung trong tài liệu cập nhật (tháng 09/2026), cho phép yêu cầu dữ liệu TPO profile qua cú pháp `request_series[TpoProfile](source=sources.Tpo(...), time_frame=...)`.
  - **Các trường dữ liệu được cung cấp sẵn trên `TpoProfile`:**
    - `point_of_control`: Mức giá (price level) có số lượng TPO tích lũy lớn nhất trong phiên (POC). *Lưu ý quan trọng:* `TpoProfile` **không** có thuộc tính `point_of_control_index`.
    - `initial_balance_high` & `initial_balance_low`: Mức giá cao nhất và thấp nhất của Initial Balance (biên độ khung thời gian ban đầu của phiên).
    - `row_size`: Độ cao của mỗi hàng giá (row height).
    - Danh sách các hàng giá (`rows`) và metadata các block/cột thời gian (`row.block_indexes`, `len(row.block_indexes)`).
  - **Thuật toán xác định Value Area (VAH / VAL) chuẩn xác theo tài liệu TakeProfit:**
    - Đối tượng `TpoProfile` **KHÔNG** cung cấp sẵn các thuộc tính `value_area_high`, `value_area_low` hay tỷ lệ Value Area. Script bắt buộc phải tự tính toán theo quy trình thuật toán chính thức:
      1. *Kiểm tra an toàn (Guard condition):* Xác nhận profile có dữ liệu (`len(profile.rows) > 0`). Nếu `rows` rỗng thì không truy cập.
      2. *Xác định chỉ số hàng chứa POC (`poc_index`):* Vì `TpoProfile` không cung cấp thuộc tính `point_of_control_index`, script duyệt qua danh sách `rows` theo đúng quy trình tài liệu TakeProfit để tìm chỉ số hàng có số lượng TPO lớn nhất (`len(row.block_indexes)`), cập nhật chỉ số khi gặp hàng có số lượng block strictly lớn hơn (hoặc đối chiếu `row.price == profile.point_of_control`). Số TPO ban đầu là `covered = len(rows[poc_index].block_indexes)`. Khởi tạo cận trên và cận dưới: `low_index = poc_index`, `high_index = poc_index`.
      3. *Vòng lặp mở rộng từng bước (Single-row iterative expansion):* Trong mỗi vòng lặp, kiểm tra sự tồn tại của hàng kề trên (`has_up = (high_index + 1 < len(rows))`) và hàng kề dưới (`has_down = (low_index - 1 >= 0)`).
      4. *Quy tắc chọn đúng một hàng:*
         - Nếu cả hai phía đều không còn hàng (`not has_up and not has_down`): Dừng vòng lặp ngay lập tức.
         - **Trường hợp biên một phía (One-sided boundary):**
           - Nếu chỉ còn hàng phía trên (`has_up and not has_down`): Chọn hàng phía trên (`high_index + 1`).
           - Nếu chỉ còn hàng phía dưới (`has_down and not has_up`): Chọn hàng phía dưới (`low_index - 1`).
         - **Trường hợp hai phía (Two-sided comparison):** Nếu cả hai hàng kề đều tồn tại:
           - So sánh số lượng TPO: Hàng nào có số TPO lớn hơn strictly (`len(rows[idx].block_indexes)`) sẽ được chọn.
           - **Quy tắc xử lý hòa (Official Tie-break Rule):** Nếu số TPO của hai hàng bằng nhau, so sánh khoảng cách của chúng đến POC (`abs(candidate_index - poc_index)`). Hàng nào gần POC hơn sẽ được chọn. Nếu khoảng cách đến POC cũng bằng nhau, **chọn hàng phía trên (`high_index + 1`)**.
      5. *Cộng dồn số lượng TPO:* Chỉ cộng số TPO của **duy nhất hàng vừa được chọn** vào `covered` (tuyệt đối không cộng cả hai hàng kề trong một bước) và cập nhật chỉ số biên tương ứng (`high_index += 1` hoặc `low_index -= 1`).
      6. *Điều kiện dừng:* Lặp lại các bước trên cho đến khi `covered >= total_blocks * value_area_ratio` (với `value_area_ratio` mặc định thường là $0.70$, tương ứng 70% tổng số TPO của toàn profile).
      7. *Quy ước hình học biên giá (Boundary Geometry Convention):*
         - Thuộc tính `rows[i].price` là **biên dưới (lower bound)** của hàng giá thứ `i`.
         - Do đó:
           - $\text{VAL} = \text{rows}[\text{low\_index}].\text{price}$ (chính là biên dưới của hàng thấp nhất thuộc Value Area).
           - $\text{VAH}_{\text{lower}} = \text{rows}[\text{high\_index}].\text{price}$ (biên dưới của hàng cao nhất thuộc Value Area).
           - $\text{VAH}_{\text{upper}} = \text{rows}[\text{high\_index}].\text{price} + \text{profile}.\text{row\_size}$ (biên trên hình học thực tế của Value Area).
  - **Những điểm chưa được kiểm chứng đối với Exness (`RUNTIME_REQUIRED` & xung đột phiên):**
    1. *Khả năng hỗ trợ của runtime Exness:* Exness Terminal Web là môi trường nhúng do Exness vận hành; việc TakeProfit có tài liệu không chứng minh runtime Exness hiện tại đã kích hoạt `BlockProfile` hay thư viện `indie.data.sources.Tpo()`. Cả hai bắt buộc phải được kiểm chứng qua smoke test tối thiểu trên runtime Exness (`RUNTIME_REQUIRED`).
    2. *Xung đột cấu hình phiên:* Nguồn `sources.Tpo()` của Indie mặc định gộp cả pre-market, main session và post-market thành một profile ngày. Trong khi đó, đặc tả của người dùng (`TPO Session v1.01`) yêu cầu chia thành **3 phiên riêng biệt theo giờ Việt Nam**: S1 Á (06:00–14:59/13:59), S2 Âu (15:00–19:59/14:00–18:59) và S3 Mỹ (20:00–05:59/19:00–05:59 qua đêm) cùng bước giá cố định $0.1 \times 12 = 1.2$. Do đó, native API không tự động đáp ứng yêu cầu phiên của người dùng nếu không có giải pháp mapping phiên tùy biến.
- **Nguồn dẫn chứng chính thức:**
  - TakeProfit TPO Profiles Docs: `https://takeprofit.com/docs/indie/Profile-data/TPO-profiles` [S19]
  - TakeProfit Package indie.data: `https://takeprofit.com/docs/indie/Library-reference/package-indie-data` [S20]
  - TakeProfit Package indie.data.sources: `https://takeprofit.com/docs/indie/Library-reference/package-indie-data-sources`
  - TakeProfit Guide Changelog: `https://takeprofit.com/docs/guide/changelog` [S21]
  - TakeProfit Drawings Docs: `https://takeprofit.com/docs/indie/Library-reference/package-indie-drawings` [S11]
  - Exness Help Center: `https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal` [S12]
  - Hướng dẫn cấu hình TPO của người dùng: `user_inputs/TPO_HUONG_DAN.txt`.

---

### PHẦN B: LOGIC CỐT LÕI VÀ KIẾN TRÚC (Q17–Q26)

#### Q17. Mô tả mục đích phương pháp luận của Sonic R. theo nguồn gốc. Những yếu tố nào trong phiên bản hiện tại là biến thể riêng của dự án?
- **Trả lời:**
  - **Mục đích phương pháp luận gốc (Sonicdeejay [S1], traderathome [S2]):** Sonic R. là hệ thống giao dịch swing khung M15 nhằm giải quyết hai vấn đề: tránh mua bán đuổi theo các cú phá vỡ giả (false breakouts / stop hunts) của Market Maker và tránh bẫy trễ nhịp của các hệ thống giao cắt trung bình động (MA crossover). Phương pháp đặt hành động giá lên hàng đầu (*price-action-first*), đòi hỏi nhận diện cấu trúc sóng 3 nhịp (L-H-HL cho lệnh Mua; H-L-LH cho lệnh Bán), lấy dải Dragon (EMA 34 High/Close/Low) làm vùng tham chiếu giá trị để tìm điểm vào lệnh giá tốt trong nhịp điều chỉnh, đồng thuận với Trend Line (EMA 89 Close) và các mức cản S/R ngang / số tròn.
  - **Các yếu tố biến thể riêng của dự án (`PROJECT_LOCK`):**
    - Tham số hóa cứng cấu trúc sóng trên khung M5 thay vì thuần M15.
    - Bổ sung quy tắc lọc động lượng đa khung từ RSI Trend Pulse (H4/H1/M15/M5).
    - Tách biệt hai chế độ kích hoạt `trig_mode=0` (Bounce - bật khỏi Dragon) và `trig_mode=1` (Swing Breakout - phá vỡ đỉnh swing H).
    - Cài đặt tham số EMA 200 tùy chọn (`use_e200=False`), trong khi phương pháp gốc không yêu cầu EMA 200.
    - Tính toán tự động mức giá tròn động theo bước `rnd_step=10.0`.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` §1–§2, Forex Factory [S1], [S2].

#### Q18. Định nghĩa dải Dragon trong đặc tả hiện tại và phân biệt với EMA 89 và EMA 200?
- **Trả lời:**
  - **Dải Dragon:** Là kênh hành động giá (Price Action Channel) gồm 3 đường Exponential Moving Average chu kỳ 34: $\text{EMA}_{34}(\text{High})$, $\text{EMA}_{34}(\text{Close})$ (đường trục giữa rõ nét hơn), và $\text{EMA}_{34}(\text{Low})$. Dragon đóng vai trò là dải hỗ trợ/kháng cự động và là vùng đệm đo lường biên độ nhịp hồi giá trị.
  - **Đường Trend Line EMA 89 Close:** Đại diện cho xu hướng chủ đạo của khung thời gian lớn hơn (tương đương EMA 22 của H1 khi nhìn trên M15). Đóng vai trò là ranh giới phân định xu hướng chính (giá và Dragon phải nằm trên EMA 89 đối với setup tăng, dưới EMA 89 đối với setup giảm).
  - **Đường Macro EMA 200 Close:** Đường tham chiếu xu hướng vĩ mô dài hạn. Trong Sonic R. nguyên bản không bắt buộc; trong dự án hiện tại là đường hiển thị tham khảo, mặc định tắt làm bộ lọc cứng (`use_e200=False`). Khi bật, giá đóng cửa bắt buộc phải nằm đúng phía EMA 200.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` §2, `01_SPEC_LOCK.md` §3.

#### Q19. Giải thích vì sao Touch, Bounce và Swing Breakout là ba khái niệm tách biệt? Những chi tiết nào cần chốt trước khi sửa code?
- **Trả lời:**
  - **Phân biệt 3 khái niệm:**
    1. *Touch (Chạm dải Dragon):* Giá kiểm định dải Dragon (ví dụ nến tăng có $\text{Low} \le \text{Dragon High}$). Đây chỉ là điều kiện tiền đề báo hiệu nhịp hồi đã vào vùng giá trị, chưa hề có lực xác nhận đảo chiều.
    2. *Bounce (Bật lại):* Giá sau khi chạm Dragon đã phản ứng rút chân và đóng cửa trở lại bên ngoài dải thuận theo xu hướng chính ($\text{Close} > \text{Dragon High}$ và nến tăng). Đây là trigger bắt nhịp sớm tại chân sóng HL.
    3. *Swing Breakout (Phá vỡ đỉnh swing):* Giá sau khi tạo HL tại Dragon đã tăng tiếp diễn và đóng cửa phá vỡ mức đỉnh swing H trước đó ($\text{Close} > \text{Price}_H$). Đây là trigger cổ điển xác nhận nhịp sóng 3 tiếp diễn.
  - **Chi tiết bắt buộc phải chốt trước khi sửa code:**
    - Điều kiện Bounce được tính trên nến chạm ngay lập tức hay cho phép trễ 1–2 nến sau nến Touch?
    - Breakout đỉnh swing H tính theo giá đóng cửa (`Close`) hay chỉ cần râu nến quét qua (`High`)?
    - Điều kiện xác nhận đỉnh H và đáy HL đòi hỏi bao nhiêu nến xác nhận bên trái/phải?
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` §3–§4, `01_SPEC_LOCK.md` §3, `02_ISSUE_REGISTER.md` (ISS-06).

#### Q20. Viết các thành phần công thức RSI và giải thích cơ chế làm mượt của Wilder?
- **Trả lời:**
  - **Công thức RSI:**
    - Với chuỗi giá đóng cửa $C[t]$, độ thay đổi: $\Delta[t] = C[t] - C[t-1]$.
    - Phần tăng: $\text{gain}[t] = \max(\Delta[t], 0)$; Phần giảm: $\text{loss}[t] = \max(-\Delta[t], 0)$.
    - Khởi tạo tại $t = n$ ($n=14$): Lấy trung bình cộng số học của $n$ giá trị gain và loss đầu tiên:
      $$\text{avg\_gain}_0 = \frac{1}{n}\sum_{i=1}^n \text{gain}[i], \quad \text{avg\_loss}_0 = \frac{1}{n}\sum_{i=1}^n \text{loss}[i]$$
    - **Làm mượt kiểu Wilder (RMA / Modified Moving Average):** Với các bước tiếp theo ($t > n$):
      $$\text{avg\_gain}[t] = \frac{\text{avg\_gain}[t-1] \times (n - 1) + \text{gain}[t]}{n}$$
      $$\text{avg\_loss}[t] = \frac{\text{avg\_loss}[t-1] \times (n - 1) + \text{loss}[t]}{n}$$
      (Tương đương với hàm EMA có hệ số $\alpha = 1/n$).
    - Tỷ số sức mạnh tương đối: $RS = \frac{\text{avg\_gain}}{\text{avg\_loss}}$.
    - Chỉ số RSI: $RSI = 100 - \frac{100}{1 + RS}$. (Xử lý biên: nếu $\text{avg\_loss}=0 \rightarrow RSI=100$; nếu $\text{avg\_gain}=0 \rightarrow RSI=0$).
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §1, Wilder (1978) [S3], TradingView [S4].

#### Q21. Xác nhận hai đường EMA 9 và WMA 45 hoạt động trên chuỗi dữ liệu nào?
- **Trả lời:**
  - Hai đường trung bình động EMA 9 và WMA 45 trong dự án **hoạt động trực tiếp trên chuỗi giá trị của RSI 14**, TUYỆT ĐỐI KHÔNG hoạt động trên chuỗi giá đóng cửa của XAUUSD.
  - Cụ thể: $\text{EMA}_9(\text{RSI}_{14})$ là đường trung bình động hàm mũ chu kỳ 9 của RSI; $\text{WMA}_{45}(\text{RSI}_{14})$ là đường trung bình động gia quyền chu kỳ 45 của RSI. Đây là đặc điểm cốt lõi của phương pháp RSI Trend Pulse để nhận diện xung lực và làm mượt dao động của chính RSI.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §1, `01_SPEC_LOCK.md` §3, TakeProfit Algorithms Docs [S6].

#### Q22. Mô tả vai trò của các khung H4/H1, M15 và M5 mà không biến chúng thành các chỉ dẫn đặt lệnh giao dịch?
- **Trả lời:**
  - **H4 và H1 (Directional Context - Bối cảnh thiên hướng):** Cung cấp góc nhìn về xu hướng động lượng lớn. Khi RSI và EMA 9 nằm trên WMA 45, WMA 45 dốc lên và các đường không xoắn chụm, bối cảnh được định nghĩa là thiên hướng tăng (và ngược lại cho giảm). Đóng vai trò là bức tranh định hướng, không phát tín hiệu mua/bán.
  - **M15 (Waiting / Pullback Zone - Vùng quan sát nhịp hồi):** Cung cấp trạng thái điều chỉnh của thị trường. Khi xu hướng tăng, RSI M15 lùi về dải 40–50 hoặc chạm WMA 45, báo hiệu thị trường đang trong nhịp hồi phục kỹ thuật lành mạnh. Trạng thái này nhắc nhở người dùng "chuyển sang chế độ theo dõi", hoàn toàn không phải tín hiệu vào lệnh.
  - **M5 (Momentum Confirmation - Xác nhận động lượng ngắn hạn):** Quan sát sự kiệt sức của nhịp hồi thông qua phân kỳ (Regular/Hidden) hoặc mô hình 2 đáy/đỉnh RSI, kết hợp giao cắt xác nhận giữa RSI và EMA 9 trên nến M5 đã đóng. Sự kiện này chỉ đóng vai trò đánh dấu thời điểm động lượng ngắn hạn đồng thuận trở lại với xu hướng chính.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §3, `01_SPEC_LOCK.md` §4.

#### Q23. Vì sao các mốc tham chiếu và ngưỡng tham số RSI trong dự án không phải là bằng chứng sinh lời?
- **Trả lời:**
  - Các mốc tham chiếu (30, 40, 50, 60, 70), vùng hồi (45 và 55), độ dốc tối thiểu `min_slp=0.05`, khoảng cách chống xoắn `tangle_sp=2.5`, dung sai `w45_tol=2.0`, dung sai 2 đáy `db_tol=3.0`, độ nổi bật `db_prom=4.0` là **các ngưỡng khởi tạo kỹ thuật (engineering baseline parameters)** được đưa ra trong quá trình thiết kế và mô phỏng ý tưởng ban đầu.
  - Chúng chưa từng trải qua quá trình tối ưu hóa thống kê (statistical optimization), walk-forward analysis hay kiểm định tính vững chắc (robustness testing) trên tập dữ liệu lịch sử lớn của XAUUSD. Do đó, chúng chỉ đóng vai trò là các mức tham chiếu trực quan để người dùng theo dõi hành vi giá, hoàn toàn không phải bảo chứng cho lợi nhuận hay tỷ lệ thắng trong giao dịch.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` §2–§3, `01_SPEC_LOCK.md` §7.

#### Q24. Định nghĩa các quy ước thông thường của BOS và CHoCH, đồng thời giải thích vì sao chúng không phải là định nghĩa phần mềm chuẩn hóa phổ quát?
- **Trả lời:**
  - **BOS (Break of Structure - Phá vỡ cấu trúc):** Quy ước phổ biến là sự kiện giá vượt qua một đỉnh swing (trong xu hướng tăng) hoặc đáy swing (trong xu hướng giảm) đã được xác nhận trước đó, đánh dấu sự tiếp diễn của xu hướng hiện tại.
  - **CHoCH (Change of Character - Thay đổi đặc tính):** Quy ước phổ biến là sự kiện giá phá vỡ mức đáy swing quan trọng gần nhất (đang trong xu hướng tăng) hoặc đỉnh swing gần nhất (đang trong xu hướng giảm), đóng vai trò là tín hiệu cảnh báo sớm về khả năng đảo chiều xu hướng.
  - **Vì sao không chuẩn hóa phổ quát:** SMC là tập hợp các thuật ngữ giao dịch tùy ý trong cộng đồng, không có tiêu chuẩn phần mềm quốc tế nào quy định thuật toán của chúng. Giữa các công cụ SMC khác nhau (như LuxAlgo [S7], QuantumAlgo [S8], v.v.), định nghĩa kỹ thuật khác nhau rất xa:
    - Cách xác định swing: dùng pivot 3 nến, 5 nến, hay theo zigzag phần trăm?
    - Điều kiện phá vỡ: chỉ cần râu nến quét qua (wick break) hay bắt buộc giá đóng cửa nằm ngoài (close break)?
    - Phân tầng cấu trúc: có tách biệt giữa Minor Structure (cấu trúc phụ nội bộ) và Major Swing Structure hay không?
    - Vì vậy, không thể lấy định nghĩa của một bên thứ ba bất kỳ áp đặt vào chỉ báo của người dùng.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §2 & §7.

#### Q25. Nêu ít nhất 4 lựa chọn thuật toán ảnh hưởng trực tiếp đến kết quả của FVG, Order Block, Equal Highs và Liquidity Sweep?
- **Trả lời:**
  1. *Quy tắc biên khoảng trống của Fair Value Gap (FVG):* Khoảng cách giữa nến 1 và nến 3 được đo từ râu nến (`High_1` đến `Low_3`) hay thân nến (`Open/Close`)? Có áp dụng bộ lọc kích thước tối thiểu (minimum gap threshold) hay không? Khi giá chạm một phần (partial fill) thì FVG bị thu nhỏ, vô hiệu hóa hay giữ nguyên?
  2. *Quy tắc xác định và ranh giới của Order Block (OB):* Chọn cây nến ngược chiều cuối cùng trước nhịp đẩy mạnh hay chọn toàn bộ cụm nến tích lũy? Vùng OB được tính bằng toàn bộ chiều dài nến (`High-Low`) hay chỉ tính thân nến (`Open-Close`)? Điều kiện hủy bỏ OB (mitigation) là khi giá vừa chạm mép hay khi nến đóng cửa xuyên thủng hoàn toàn qua vùng?
  3. *Dung sai nhận diện đỉnh/đáy bằng nhau (Equal Highs / Equal Lows - EQH/EQL):* Mức chênh lệch giữa 2 đỉnh/đáy được tính theo số pip cố định, số tick, hay chuẩn hóa theo biến động ATR? Khoảng cách tối thiểu và tối đa giữa 2 đỉnh là bao nhiêu cây nến?
  4. *Quy tắc xác nhận quét thanh khoản (Liquidity Sweep):* Cú quét chỉ cần râu nến vượt qua mức cản cũ rồi rút chân lại trong phiên, hay bắt buộc cây nến đó phải đóng cửa trở lại bên dưới mức cản? Có yêu cầu nến xác nhận tiếp theo phải di chuyển mạnh theo chiều ngược lại hay không?
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §3–§5.

#### Q26. Vì sao danh mục tính năng SMC phải bắt nguồn từ mã nguồn hoặc hành vi đã xác thực của người dùng thay vì lấy từ một chỉ báo SMC chung chung?
- **Trả lời:**
  - Vì mục tiêu của dự án là **tái hiện trung thực công cụ quan sát mà người dùng đang sử dụng** trên biểu đồ của họ.
  - Các chỉ báo SMC trôi nổi trên mạng (hoặc mã nguồn mở trên TradingView) có hàng chục biến thể với logic tính toán, số lượng tham số, màu sắc và cách hiển thị hoàn toàn khác nhau. Nếu agent tự ý "sao chép" logic của LuxAlgo hay một thư viện Python bất kỳ, sản phẩm tạo ra sẽ là một chỉ báo hoàn toàn xa lạ đối với người dùng, làm sai lệch các điểm vào lệnh và cấu trúc mà họ đã quen quan sát trên file gốc `SC_MarketStructure.ex5`. Do đó, danh mục tính năng bắt buộc phải được trích xuất từ source `.mq5/.mqh` hoặc qua bảng đặc tả hành vi đã được người dùng xác nhận.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` §1 & §6, `06_SMC_TPO_INTEGRATION_SPEC.md` §3.1.

---

### PHẦN C: NỀN TẢNG, LOGIC THỜI GIAN VÀ CHẤT LƯỢNG (Q27–Q34)

#### Q27. Hàm `Context.calc_on()` có nhiệm vụ gì, và tài liệu chính thức quy định phải khởi tạo nó ở đâu? Điểm nào vẫn bắt buộc phải kiểm thử trên Exness?
- **Trả lời:**
  - **Nhiệm vụ của `Context.calc_on()`:** Kích hoạt việc tính toán một ngữ cảnh thứ cấp (`@sec_context`) trên một khung thời gian khác (HTF hoặc LTF) hoặc trên một mã giao dịch khác, sau đó tự động căn chỉnh và ánh xạ (resample/merge) chuỗi kết quả trở lại dòng thời gian của biểu đồ chính.
  - **Vị trí khởi tạo theo tài liệu chính thức:** Tài liệu của TakeProfit ([S15], [S16]) quy định bắt buộc phải gọi `self.calc_on()` **bên trong hàm khởi tạo `__init__()`** của lớp `Main` (hoặc lớp con của `MainContext`). Tuyệt đối không được gọi `calc_on()` bên trong hàm `calc()`.
  - **Điểm bắt buộc phải kiểm thử trên Exness:**
    1. Runtime thực tế của Exness có hỗ trợ gọi `calc_on` cho khung thời gian nhỏ hơn (LTF) hay không (tính năng chỉ có từ Indie v5.14.0 theo [S17]).
    2. Độ trễ và tính chính xác tại các thanh nến ranh giới khi nến HTF đóng cửa.
    3. Hành vi đồng bộ dữ liệu khi người dùng cuộn ngược lịch sử biểu đồ hoặc tải lại trang (F5).
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §2–§4, TakeProfit Docs [S15], [S16], [S17].

#### Q28. Phân biệt sự khác nhau giữa 4 cấp độ kiểm chứng: Static API check, Target compile, Visual QA và Reload/Repaint QA?
- **Trả lời:**
  1. **Static API check (Kiểm tra API tĩnh):** Đọc mã nguồn và đối chiếu chữ ký hàm, tên tham số, decorator với tài liệu chính thức của Indie (chỉ chứng minh code đúng theo tài liệu, không chứng minh môi trường thực tế chấp nhận).
  2. **Target compile (Biên dịch trên nền tảng đích):** Dán trực tiếp tệp mã nguồn vào trình chỉnh sửa của Exness Terminal Web và nhấn Compile/Add to chart mà không sinh lỗi (chứng minh cú pháp tương thích với phiên bản engine hiện tại của Exness, nhưng chưa chứng minh đồ họa hiển thị đúng hay logic đúng).
  3. **Visual QA (Kiểm định trực quan):** Mở biểu đồ XAUUSD M5 thực tế, kiểm tra tận mắt xem các đường EMA, dải Dragon, mốc giá tròn, mức swing và các tam giác marker có hiển thị rõ nét, đúng tỷ lệ, đúng vị trí và không che khuất nến hay không (kèm ảnh chụp màn hình).
  4. **Reload/Repaint QA (Kiểm định độ ổn định sau tải lại/chống repaint):** Theo dõi sự xuất hiện của marker tại nến đóng thời gian thực, sau đó thực hiện F5/reload hoặc cuộn lịch sử để đối chiếu xem marker đã chốt có bị dịch chuyển vị trí, biến mất hay thay đổi hình thái hay không.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` §1, `03_QA_ACCEPTANCE.md` Phần A.

#### Q29. Vì sao một marker lịch sử được vẽ trên cây nến điểm xoay (Pivot bar) có thể là hợp lệ nhưng người giao dịch lại KHÔNG THỂ có tín hiệu đó tại thời điểm cây nến đó diễn ra?
- **Trả lời:**
  - Vì điểm xoay (pivot) đòi hỏi điều kiện hình thành đối xứng (ví dụ nến ở giữa phải cao hơn $R$ cây nến bên phải).
  - Khi cây nến pivot đang hình thành và đóng cửa, các cây nến bên phải chưa hề tồn tại, nên thuật toán không thể biết đó là đỉnh hay đáy. Chỉ sau khi $R$ cây nến bên phải đã đóng cửa hoàn toàn mà giá không vượt qua nến pivot, điểm xoay mới được xác nhận.
  - Lúc này, chỉ báo thực hiện việc hồi tố vẽ nhãn/đường quay ngược lại cây nến pivot trong quá khứ để người dùng dễ nhìn cấu trúc sóng (`PIVOT_BACKFILL`). Đây là hành vi hợp lệ về mặt trực quan hóa dữ liệu, nhưng tín hiệu đó **chỉ khả dụng trong thực tế tại thời điểm cây nến thứ $R$ đóng cửa**. Người giao dịch tại thời điểm cây nến pivot xảy ra không thể nhận được tín hiệu này.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §1 & §4.

#### Q30. Liệt kê 6 bài kiểm tra MTF/Session/Repaint tối thiểu bắt buộc đối với dự án này?
- **Trả lời:**
  1. *Kiểm tra ranh giới nến HTF:* Theo dõi hành vi cập nhật và tính toán tại thời điểm chính xác khi nến M15, H1 và H4 đóng cửa đồng thời hoặc đóng riêng lẻ (xác nhận không lấy nhầm dữ liệu đang chạy của nến HTF).
  2. *Kiểm tra nến đang chạy vs nến đóng:* Điều kiện trigger M5 hình thành tạm thời trong nến nhưng sau đó rút chân thất bại trước khi đóng nến (xác nhận marker không được phép xuất hiện hoặc không bị lưu lại).
  3. *Kiểm tra F5 / Reload ổn định (Reload stability):* Ghi lại tọa độ và timestamp của 3–5 marker vừa xuất hiện trên chart live, sau đó bấm F5 tải lại trang web Exness (xác nhận marker lịch sử giữ nguyên vị trí, không nhảy nến).
  4. *Kiểm tra ranh giới mở/đóng phiên TPO:* Kiểm tra cây nến ngay trước, ngay tại thời điểm mở phiên (06:00, 15:00, 20:00) và ngay sau khi đóng phiên (xác nhận nến được gán chính xác vào từng bracket của phiên).
  5. *Kiểm tra phiên vắt qua nửa đêm (Overnight Session):* Kiểm tra phiên Mỹ S3 (bắt đầu từ 20:00 hôm trước đến 05:59 sáng hôm sau) được gom nhóm liên tục thành một profile thống nhất qua ranh giới ngày mới.
  6. *Kiểm tra tác động chuyển đổi giờ mùa hè / mùa đông (DST transition test):* Kiểm tra phân bổ phiên trên chuỗi dữ liệu trước và sau các tuần chuyển giờ DST của thị trường tài chính Mỹ và Châu Âu.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` §5, `KNOWLEDGE_BASE/08_SYMBOL_SESSIONS_TIMEZONES_AND_ROW_HEIGHT.md` §4, `03_QA_ACCEPTANCE.md` (T14, T15), `09_SMC_TPO_QA_ACCEPTANCE.md` (TP-03, TP-06).

#### Q31. Định dạng file đuôi nào là bắt buộc để có thể thực hiện Source Port cho các chỉ báo MT5, và giải pháp thay thế là gì nếu không có các file này?
- **Trả lời:**
  - Để thực hiện **Source Port** (chuyển ngữ mã nguồn nguyên bản), bắt buộc phải có các file mã nguồn văn bản thuần của MetaTrader 5: **`.mq5`** (file mã nguồn chính) và toàn bộ các file thư viện đính kèm **`.mqh`** (include header files).
  - **Giải pháp thay thế (Fallback):** Nếu người dùng không thể cung cấp mã nguồn `.mq5/.mqh`:
    - Chỉ được phép thực hiện **Tái triển khai theo đặc tả hành vi (Behavioral Reimplementation)**.
    - Điều kiện thực hiện: Người dùng phải cung cấp tài liệu mô tả chi tiết yêu cầu, ảnh chụp đầy đủ tab Inputs/Parameters và các ảnh chụp chart thực tế minh họa rõ ràng các trường hợp hoạt động.
    - Sản phẩm tạo ra bắt buộc phải ghi rõ nhãn là `REIMPLEMENTATION — behaviorally tested`, tuyệt đối không được ghi là `SOURCE PORT`.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §1, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` §2–§3, MetaEditor Help [S13].

#### Q32. Vì sao việc chuyển nền tảng mục tiêu từ Exness Web/Indie sang MT5 desktop không phải là một chi tiết triển khai kỹ thuật đơn thuần?
- **Trả lời:**
  - Vì hai nền tảng sử dụng hai hệ sinh thái công nghệ, ngôn ngữ lập trình và mô hình runtime hoàn toàn khác nhau:
    1. *Khác biệt ngôn ngữ và kiến trúc:* Exness Web sử dụng TakeProfit Indie v5 (cú pháp Python, kiến trúc `MainContext`, series indexing theo thời gian thực), trong khi MT5 sử dụng MQL5 (cú pháp C++, kiến trúc buffer hướng đối tượng hoặc cấu trúc mảng `OnCalculate`, quản lý bộ nhớ trực tiếp).
    2. *Tác động hồi quy lên toàn bộ dự án:* Nếu chuyển sang MT5 để tận dụng 2 file `.ex5`, toàn bộ 2 script lõi Sonic R. và RSI Trend Pulse (hiện đang được viết bằng Indie) sẽ **buộc phải viết lại từ đầu bằng MQL5**, đòi hỏi xây dựng lại quy trình kiểm thử, quản trị rủi ro và phê duyệt lại từ khách hàng.
    3. *Thay đổi trải nghiệm người dùng cuối:* Khách hàng đang có nhu cầu theo dõi trực tiếp trên nền tảng web terminal tiện lợi; chuyển sang desktop đòi hỏi cài đặt phần mềm MT5 phức tạp. Vì vậy, đây là quyết định thay đổi sản phẩm chiến lược, bắt buộc phải có sự chấp thuận bằng văn bản của Người quản lý.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` §1, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` §2.

#### Q33. Thứ bậc thẩm quyền (Order-of-authority) được xử lý như thế nào khi một báo cáo lịch sử mâu thuẫn với đặc tả đã khóa hiện tại?
- **Trả lời:**
  - Khi có mâu thuẫn giữa báo cáo lịch sử và đặc tả đã khóa, **Đặc tả đã khóa hiện hành (`01_SPEC_LOCK.md`) luôn có thẩm quyền cao hơn**.
  - Thứ bậc thẩm quyền chính thức của dự án được quy định như sau:
    1. Quyết định rõ ràng mới nhất của người dùng/quản lý được ghi trong `DECISION_LOG.md`.
    2. Đặc tả đã khóa hiện hành (`01_SPEC_LOCK.md`) và đặc tả mở rộng được duyệt (`06_SMC_TPO_INTEGRATION_SPEC.md`).
    3. Mã nguồn thực tế do người dùng cung cấp / hành vi tái hiện từ chỉ báo gốc.
    4. Tài liệu API chính thức của nền tảng runtime đang sử dụng.
    5. Tài liệu nguồn của tác giả sáng lập phương pháp (ví dụ bài viết của Sonicdeejay/traderathome).
    6. Tài liệu giáo dục bên thứ ba.
    7. Suy luận của Agent (thẩm quyền thấp nhất).
  - Báo cáo lịch sử trong `source_archive/` chỉ là bằng chứng về tiến trình làm việc trong quá khứ, không có quyền ghi đè lên các quyết định và đặc tả đã khóa. Cấm tự ý thỏa hiệp ngầm khi có mâu thuẫn.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` §7, `KNOWLEDGE_BASE/12_PERSISTENT_MEMORY_PROTOCOL.md` §4.

#### Q34. Giải thích quy trình cập nhật bộ nhớ dự án và changelog sau khi có một sự thật mới được kiểm chứng hoặc một quyết định của Người quản lý?
- **Trả lời:**
  - Quy trình cập nhật bộ nhớ chuẩn tắc gồm các bước:
    1. *Phân loại thông tin:* Xác định thông tin mới là sự thật được kiểm chứng (`PRIMARY_SOURCE`/`OFFICIAL_API_DOC`/`RUNTIME_REQUIRED`) hay là một quyết định phê duyệt của Người quản lý (`PROJECT_LOCK`/`DECISION`).
    2. *Cập nhật Claim Ledger (`learning_records/CLAIM_LEDGER.md`):* Thêm khẳng định mới, gắn đúng nhãn bằng chứng, ghi rõ nguồn dẫn chứng, phạm vi chứng minh và giới hạn của nguồn.
    3. *Đóng hoặc cập nhật Knowledge Gaps (`learning_records/KNOWLEDGE_GAPS.md`):* Nếu sự thật mới giải quyết được một blocker P0/P1, chuyển trạng thái mục đó từ `OPEN` sang `CLOSED`, trích dẫn bằng chứng cụ thể đã đóng gap.
    4. *Cập nhật Project Memory (`learning_records/PROJECT_MEMORY.md`):* Cập nhật ngắn gọn hiện trạng mới, phiên bản và các ràng buộc vào tệp bộ nhớ trung tâm.
    5. *Ghi nhận vào Changelog (`CHANGELOG_KNOWLEDGE.md`):* Ghi rõ ngày giờ, nội dung kiến thức được bổ sung hoặc đính chính, lý do và các tệp bị ảnh hưởng.
    6. *Ghi nhận vào sổ quyết định (`DECISION_LOG.md`):* CHỈ ghi vào tệp này khi có quyết định chính thức được Người quản lý ký duyệt, nêu rõ tác động và các đặc tả bị thay đổi.
- **Nguồn dẫn chứng:** `KNOWLEDGE_BASE/12_PERSISTENT_MEMORY_PROTOCOL.md` §2–§5, `00_BAT_DAU_TAI_DAY.md` §4.
