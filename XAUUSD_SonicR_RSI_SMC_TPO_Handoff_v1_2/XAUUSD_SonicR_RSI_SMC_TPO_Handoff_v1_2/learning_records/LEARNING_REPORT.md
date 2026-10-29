# BÁO CÁO HỌC TẬP VÀ KIỂM CHỨNG TRI THỨC — PHASE 0 (LEARNING REPORT)

**Dự án:** Bộ chỉ báo quan sát thị trường XAUUSD — Sonic R. + RSI Trend Pulse + SMC + TPO  
**Phiên bản Knowledge Base:** 1.2.0  
**Ngày thực hiện:** 2026-10-29  
**Môi trường đích mặc định:** Exness Terminal Web / TakeProfit Indie v5  
**Trạng thái cổng học tập (Learning Gate Status):** `PENDING` (Đã hoàn thành nghiên cứu và kiểm chứng, đang chờ Người quản lý phê duyệt)  
**Cam kết kỷ luật Phase 0:** TUYỆT ĐỐI KHÔNG TẠO MỚI, CHỈNH SỬA, REFACTOR HOẶC THỬ NGHIỆM CODE CHỈ BÁO NÀO.

---

## MỤC A: PHẠM VI VÀ DANH MỤC TÀI LIỆU ĐÃ ĐỌC

### 1. Các tệp nội bộ đã đọc toàn văn 100% (Exact Workspace Files Read)
Đã đọc toàn bộ hồ sơ theo đúng thứ tự bắt buộc quy định tại `00_BAT_DAU_TAI_DAY.md` và `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md`:

1. **Bộ tài liệu Knowledge Base (từ 00 đến 16):**
   - `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` (Quy trình học và hệ thống nhãn bằng chứng)
   - `KNOWLEDGE_BASE/01_PROJECT_MISSION_AND_INVARIANTS.md` (Mục tiêu 4 module, ranh giới bất biến cấm giao dịch)
   - `KNOWLEDGE_BASE/02_SONIC_R_METHOD_AND_PROJECT_ADAPTATION.md` (Phương pháp gốc vs biến thể dự án)
   - `KNOWLEDGE_BASE/03_RSI_TREND_PULSE_AND_FORMULAS.md` (Công thức RSI Wilder, EMA9/WMA45 trên RSI, vai trò đa khung)
   - `KNOWLEDGE_BASE/04_SMC_CONCEPTS_AND_DEFINITION_CONTROL.md` (Thuật ngữ cấu trúc, cấm đoán thuật toán từ EX5)
   - `KNOWLEDGE_BASE/05_TPO_MARKET_PROFILE_AND_USER_SPEC.md` (TPO vs Volume Profile, row height, hướng dẫn người dùng)
   - `KNOWLEDGE_BASE/06_INDIE_V5_RUNTIME_AND_PLATFORM_COMPATIBILITY.md` (Indie v5, Exness Web, `BlockProfile`, `calc_on`)
   - `KNOWLEDGE_BASE/07_MTF_SERIES_CAUSALITY_AND_REPAINT.md` (Anchor vs confirmation time, closed bar, repaint logic)
   - `KNOWLEDGE_BASE/08_SYMBOL_SESSIONS_TIMEZONES_AND_ROW_HEIGHT.md` (Quy cách XAUUSD, múi giờ server, DST)
   - `KNOWLEDGE_BASE/09_TEST_EVIDENCE_AND_CHANGE_CONTROL.md` (5 cấp độ kiểm chứng, quản trị thay đổi)
   - `KNOWLEDGE_BASE/10_GLOSSARY.md`, `KNOWLEDGE_BASE/11_SOURCE_REGISTER_AND_CLAIM_MAP.md`, `KNOWLEDGE_BASE/12_PERSISTENT_MEMORY_PROTOCOL.md`, `KNOWLEDGE_BASE/13_LEARNING_ASSESSMENT.md`, `KNOWLEDGE_BASE/14_OPEN_QUESTIONS_AND_SOURCE_BLOCKERS.md`, `KNOWLEDGE_BASE/15_LEARNING_REPORT_TEMPLATE.md`, `KNOWLEDGE_BASE/16_KNOWLEDGE_COVERAGE_MATRIX.md`.
2. **Đặc tả và Hồ sơ quản trị đã khóa:**
   - `01_SPEC_LOCK.md` (Đặc tả đã khóa v1.0)
   - `06_SMC_TPO_INTEGRATION_SPEC.md` (Đặc tả mở rộng v1.1)
   - `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` (Cổng tương thích nền tảng và phân định EX5 vs Indie)
   - `02_ISSUE_REGISTER.md` (12 vấn đề kỹ thuật từ ISS-01 đến ISS-12)
   - `03_QA_ACCEPTANCE.md` (Kế hoạch QA T01–T16 cho hai script lõi)
   - `09_SMC_TPO_QA_ACCEPTANCE.md` (Kế hoạch QA mở rộng cho SMC và TPO)
3. **Mã nguồn tham chiếu và hiện vật gốc:**
   - `reference/SonicR_Setup_Overlay_stage4_reference.indie` (Đúng 116 dòng vật lý, SHA-256 khớp 100% baseline)
   - `reference/RSI_Trend_Pulse_Pane_stage4_reference.indie` (Đúng 83 dòng vật lý, SHA-256 khớp 100% baseline)
   - `user_inputs/TPO_HUONG_DAN.txt` (Kiểm tra mã băm SHA256 khớp 100% với `user_inputs/SHA256SUMS.txt`)
4. **Hồ sơ lưu trữ lịch sử:**
   - Đã đọc toàn bộ 8 tài liệu trong `source_archive/` (`stage1_research_and_knowledge_lock.md`, `stage2_...`, `stage3_...`, `stage4_...`).

### 2. Danh mục URL nguồn chính thức đã kiểm tra (Official URLs Verified)
Toàn bộ các URL chính thức trong `KNOWLEDGE_BASE/11_SOURCE_REGISTER_AND_CLAIM_MAP.md` đều **truy cập thành công và đã được kiểm chứng trực tiếp**:
- **[S12] Exness Help Center:** `https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal` — Xác nhận Exness Terminal Web dùng Indie của TakeProfit để viết custom indicators.
- **[S13] MetaEditor Help:** `https://www.metatrader5.com/en/metaeditor/help/development/compile` — Xác nhận file EX5 là executable che giấu thuật toán nguồn, không thể phục hồi mã gốc nếu thiếu source.
- **[S10] CQG Market Profile Help:** `https://help.cqg.com/cqgic/25/Documents/marketprofilemp.htm` — Xác nhận TPO là đơn vị đo thời gian chấp nhận giá (30 phút/bracket), khác biệt hoàn toàn với Volume Profile.
- **[S11] TakeProfit Indie Drawings:** `https://takeprofit.com/docs/indie/Library-reference/package-indie-drawings` — Xác nhận lớp `BlockProfile` tồn tại trong tài liệu `indie.drawings` với `add_column`, `add_cell`, `add_level`.
- **[S15], [S16], [S17] TakeProfit Indie Context & Changelog:** `https://takeprofit.com/docs/indie/Request-additional-instruments` và `https://takeprofit.com/docs/indie/Changelog` — Xác nhận `Context.calc_on()` phải gọi từ `__init__`, và hỗ trợ LTF bắt đầu từ Indie v5.14.0.
- **[S19], [S20], [S21] TakeProfit TPO Profiles & indie.data:** `https://takeprofit.com/docs/indie/tpo-profiles`, `https://takeprofit.com/docs/indie/Library-reference/package-indie-data` và Changelog — Xác nhận TakeProfit bổ sung nguồn dữ liệu TPO profile native (`sources.Tpo()`, `TpoProfile`) từ bản cập nhật tháng 09/2026.
*(Không có nguồn nào bị chặn hoặc không truy cập được).*

---

## MỤC B: TỔNG HỢP KIẾN THỨC CHUYÊN SÂU THEO 8 CHỦ ĐỀ CỐT LÕI

### 1. Mục tiêu và Kiến trúc Dự án
- **Kiến thức:** Dự án xây dựng bộ công cụ hỗ trợ người dùng **tự quan sát trực quan bối cảnh thị trường XAUUSD** gồm 4 lớp độc lập: (1) Sonic R. Overlay; (2) RSI Trend Pulse Pane; (3) SMC Overlay; (4) TPO Session Profile.
- **Bằng chứng:** `01_SPEC_LOCK.md`, `06_SMC_TPO_INTEGRATION_SPEC.md` (`PROJECT_LOCK`).
- **Caveats & Ranh giới:** Tuyệt đối cấm thêm logic đặt/sửa/hủy lệnh, quản lý vị thế, SL/TP, R:R, nhãn BUY/SELL hay auto-trade. Hai script lõi bị giới hạn tối đa $\le 128$ dòng vật lý (tính cả dòng trống và header).
- **Unknowns:** Mức độ hỗ trợ hiển thị đồng thời 4 module trên Exness Terminal Web mà không gây quá tải giao diện (visual clutter).

### 2. Phương pháp Sonic R.
- **Kiến thức:** Gốc từ Sonicdeejay [S1] và traderathome [S2] trên Forex Factory. Là hệ thống swing M15 dựa trên Price Action Wave (L-H-HL cho lệnh Mua; H-L-LH cho lệnh Bán), lấy dải Dragon (EMA 34 High/Close/Low) làm vùng tham chiếu nhịp hồi giá trị, đồng thuận với Trend Line (EMA 89 Close) và hỗ trợ/kháng cự ngang. Tuyệt đối không giao dịch theo MA cross mù quáng.
- **Biến thể dự án:** Khung quan sát M5; phân biệt rõ Touch (chạm Dragon) $\ne$ Bounce (`trig_mode=0` - bật khỏi Dragon) $\ne$ Swing Breakout (`trig_mode=1` - phá vỡ đỉnh swing H); EMA 200 là tham số tùy chọn (`use_e200=False`); mốc giá tròn động theo bước `rnd_step=10.0`.
- **Caveats:** Sonic R. không đảm bảo lợi nhuận trên XAUUSD. Cần chốt rõ định nghĩa đỉnh H và đáy HL là cực trị vùng quét hay pivot xác nhận có độ trễ (vấn đề ISS-05).
- **Unknowns:** Quy tắc reset chu kỳ khóa sóng (`lock_u_bar/lock_ph`) trong trường hợp xuất hiện đỉnh mới thấp hơn đỉnh cũ (ISS-07).

### 3. RSI Trend Pulse và Công thức Toán học
- **Kiến thức:** RSI 14 tính trên Close theo chuẩn Wilder (1978), khởi tạo bằng trung bình 14 nến đầu và làm mượt đệ quy bằng kỹ thuật RMA ($\alpha = 1/14$). **Hai đường EMA 9 và WMA 45 được tính toán trực tiếp trên chuỗi RSI 14**, không tính trên giá XAUUSD.
- **Phân tầng đa khung:** H4/H1 xác định thiên hướng (RSI & EMA9 vs WMA45, slope, tangle); M15 xác định vùng chờ pullback (40–50 hoặc 50–60 hoặc WMA45); M5 xác nhận động lượng (phân kỳ Regular/Hidden hoặc Double Bottom/Top kết hợp RSI cross EMA9 trên nến đóng).
- **Caveats:** Marker trên biểu đồ giá (setup tổng hợp) và marker trong pane RSI (xác nhận momentum M5) là 2 sự kiện độc lập. Snapshot Stage 4 hiện gộp điều kiện H4/H1/M15 vào Script 2 là một specification mismatch (ISS-01) cần xử lý có kiểm soát.
- **Unknowns:** Sự khác biệt nhỏ về giá trị ban đầu (seed/warm-up) giữa thuật toán built-in của Indie và MQL5 gốc.

### 4. Smart Money Concepts (SMC)
- **Kiến thức:** SMC là tập hợp thuật ngữ hành động giá tùy ý trong cộng đồng (Pivot, HH/HL/LH/LL, BOS, CHoCH, MSS, FVG, Order Block, EQH/EQL, Liquidity Sweep), không có quy chuẩn phần mềm quốc tế duy nhất. Các thư viện bên thứ ba (LuxAlgo, QuantumAlgo) có thuật toán rất khác nhau.
- **Ranh giới:** Tệp `SC_MarketStructure.ex5` là binary nhị phân của MT5, che giấu mã nguồn. Tuyệt đối không được đoán tính năng từ tên file hoặc tự ý chép code SMC từ nguồn khác.
- **Caveats & Unknowns:** Toàn bộ tính năng thực tế của `SC_MarketStructure` hiện là `UNKNOWN — Source required`. Cần mã nguồn `.mq5/.mqh` hoặc đặc tả hành vi và ảnh chụp tham số từ người dùng.

### 5. TPO / Market Profile
- **Kiến thức:** TPO (Time Price Opportunity) đo lường sự chấp nhận giá theo các lát cắt thời gian phiên (thường 30 phút/bracket). Khác biệt hoàn toàn với Volume Profile đo khối lượng giao dịch tích lũy theo mức giá.
- **Dữ liệu đã xác thực từ tài liệu người dùng (`user_inputs/TPO_HUONG_DAN.txt`):** XAUUSD mặc định `InpTickSize=0.1`, `InpTicksPerRow=12` $\rightarrow$ row height = 1.2 giá; 3 phiên S1 (Á: 06:00–14:59/13:59), S2 (Âu: 15:00–19:59/14:00–18:59), S3 (Mỹ: 20:00–05:59/19:00–05:59 vắt qua đêm); đồng hồ server tự nhận (UTC+0 không cần chỉnh, UTC+2/+3 tự đổi giờ theo Mỹ).
- **Phân định hai API TPO trong Indie v5:**
  1. *Lớp đồ họa `indie.drawings.BlockProfile` [S11]:* Cung cấp các phương thức dựng trực quan `add_column`, `add_cell`, `add_level` nhưng không tự động tính toán số liệu TPO.
  2. *Nguồn dữ liệu native `sources.Tpo()` & `TpoProfile` [S19, S20, S21]:* Cung cấp dữ liệu có cấu trúc gồm POC, Initial Balance high/low, row size và metadata block. Tuy nhiên, `TpoProfile` **không có sẵn VAH/VAL** mà tài liệu yêu cầu script phải tự tính toán: bắt đầu tại POC, mỗi bước mở rộng vào đúng 1 hàng kề có số TPO lớn hơn, tie-break theo khoảng cách đến POC và ưu tiên hàng trên; phân biệt lower bound của hàng (`rows[i].price`) với biên trên hình học của VAH (`rows[high_index].price + row_size`) cho đến khi đạt $\ge 70\%$ tổng TPO. Đồng thời nguồn này mặc định gộp phiên cả ngày, xung đột với lịch 3 phiên Việt Nam S1/S2/S3 của người dùng.
- **Caveats:** Tài liệu người dùng KHÔNG chứng minh chỉ báo có vẽ POC, VAH/VAL hay Initial Balance. Các mức này phải giữ nguyên trạng thái `UNKNOWN`.
- **Unknowns:** Khả năng hỗ trợ của lớp `BlockProfile` và `sources.Tpo()` trên runtime Exness Terminal Web (`RUNTIME_REQUIRED`); quy tắc neo gốc lưới (`grid origin`) và quy tắc gán nến vắt ngang ranh giới phiên.

### 6. Nền tảng Indie v5 và Exness Terminal Web
- **Kiến thức:** Exness Terminal Web hỗ trợ custom indicators viết bằng Indie v5 của TakeProfit. Hàm `Main` thực thi theo nến và cập nhật thời gian thực. Bắt buộc gọi `Context.calc_on()` bên trong hàm `__init__` thông qua `@sec_context`.
- **Caveats:** Chuyển target sang MT5 desktop là quyết định sản phẩm chiến lược, buộc phải viết lại toàn bộ 2 script lõi sang MQL5. Agent không được tự quyết định.
- **Unknowns:** Phiên bản engine Indie cụ thể đang chạy trên máy chủ Exness (hỗ trợ LTF `calc_on` bắt đầu từ v5.14.0).

### 7. Nhân quả Thời gian và Chống Repaint
- **Kiến thức:** Tách biệt 3 mốc thời gian: *Anchor time* (nến xảy ra cực trị), *Confirmation time* (nến đủ độ trễ $R$ để xác nhận), *Availability time* (thời điểm tín hiệu khả dụng). Mọi trigger M5 phải dùng nến M5 đã đóng. Bối cảnh HTF phải dựa trên nến HTF đã đóng.
- **Caveats:** Hồi tố pivot (`PIVOT_BACKFILL`) là hành vi trực quan hợp lệ, nhưng cấm coi đó là tín hiệu có sẵn tại thời điểm anchor. Sự kết hợp giữa giá trị `[1]` và `offset=-1` trong `plot.Marker` của Stage 4 có nguy cơ làm lệch nến (ISS-04).
- **Unknowns:** Tính ổn định thực tế của marker sau khi F5/reload trên Exness Terminal Web.

### 8. QA và Quản trị Thay đổi
- **Kiến thức:** Phân tách rạch ròi 5 cấp độ kiểm chứng: `CODE REVIEWED` $\rightarrow$ `STATIC API CHECKED` $\rightarrow$ `COMPILED ON EXNESS` $\rightarrow$ `VISUAL QA PASSED` $\rightarrow$ `REPAINT TEST PASSED`. Cấm tuyệt đối việc dùng mô phỏng tay để tuyên bố đã compile hay pass repaint.
- **Quản trị thay đổi:** Chỉ sửa code khi có `CONFIRMED DEFECT` vi phạm đặc tả đã khóa. Các trường hợp có nhiều phương án là `DESIGN_CHOICE`, thiếu bằng chứng là `TEST REQUIRED`, thiếu mã nguồn là `SOURCE BLOCKER`.

---

## MỤC C: SỔ THEO DÕI KHẲNG ĐỊNH VÀ BẰNG CHỨNG (CLAIM LEDGER SUMMARY)

Đã hoàn thiện đầy đủ tại tệp thực tế: `learning_records/CLAIM_LEDGER.md` gồm 24 khẳng định then chốt (bao gồm CLM-21 đến CLM-24 về native TPO API và tính toán VAH/VAL):
- 5 khẳng định `PROJECT_LOCK` (Mục tiêu 4 module, ranh giới cấm giao dịch, giới hạn 128 dòng, tính độc lập của marker, vai trò HTF).
- 4 khẳng định `PRIMARY_SOURCE` (Sonic R. Price Action Wave, Wilder RSI RMA, CQG TPO vs Volume Profile, traderathome EMA 200).
- 8 khẳng định `OFFICIAL_API_DOC` (Exness dùng Indie v5, MetaEditor EX5 che giấu mã nguồn, TakeProfit `BlockProfile`, `calc_on` trong `__init__`, Indie algorithms, `sources.Tpo()`, `TpoProfile`, thuật toán tính VAH/VAL tích lũy 70%).
- 1 khẳng định `USER_ARTIFACT` (Hướng dẫn TPO: row height = 1.2, lịch phiên S1/S2/S3, đồng hồ server).
- 3 khẳng định `INFERENCE` / `DESIGN_CHOICE` (Confirmation lag của pivot, nguy cơ lookahead khi dùng index `[1]` trên chuỗi MTF, xung đột phiên mặc định vs S1/S2/S3).
- 3 khẳng định `UNKNOWN` (SMC có BOS/CHoCH/OB/FVG hay không; TPO có POC/VAH/VAL hay không; Runtime Exness có compile thành công và pass repaint hay không).

---

## MỤC D: CÂU TRẢ LỜI CÁC VẤN ĐỀ KIẾN TRÚC TRỌNG YẾU

1. **Target platform và lý do:** Exness Terminal Web dùng ngôn ngữ TakeProfit Indie v5. Đây là lựa chọn đã khóa của dự án để người dùng quan sát trực tiếp trên nền tảng web không cần cài đặt phần mềm MT5 desktop.
2. **Bốn module và vai trò duy nhất:** `SonicR_Setup_Overlay` (setup giá và vùng tham chiếu), `RSI_Trend_Pulse_Pane` (động lượng đa khung), `SMC_MarketStructure_Overlay` (cấu trúc thị trường đã xác thực), `TPO_Session_Profile` (phân bố giá theo phiên).
3. **Ranh giới trực quan (Visual-only boundaries):** Tuyệt đối không có lệnh mua/bán, quản lý vị thế, SL/TP, trailing stop hay auto-trade.
4. **Ngữ nghĩa của Marker:** Marker giá (setup tổng hợp) và marker RSI (momentum confirmation) biểu thị 2 tầng thông tin độc lập, không bắt buộc cùng nến.
5. **Quy tắc 128 dòng:** Áp dụng cho từng script trong 2 script lõi; đếm tất cả dòng vật lý (kể cả dòng trống và header).
6. **Giới hạn tệp EX5:** EX5 là file nhị phân đã biên dịch, không phải source Indie, không thể suy đoán thuật toán.
7. **TPO vs Volume Profile:** TPO đo thời gian lưu lại của giá theo từng lát cắt thời gian; Volume Profile đo khối lượng giao dịch tích lũy theo mức giá.
8. **Giới hạn của `BlockProfile`:** Là API đồ họa trong tài liệu TakeProfit; chưa được kiểm chứng trên runtime Exness và không tự tính toán TPO.
9. **Anchor time vs Confirmation time:** Điểm xoay hình thành tại anchor time nhưng chỉ có thể biết và sử dụng tại confirmation time (sau khi $R$ nến bên phải đóng cửa).
10. **Chính sách nến đóng:** Mọi trigger M5 bắt buộc dùng nến M5 đã đóng; bối cảnh HTF dùng nến HTF đã đóng thông qua `calc_on` trong `__init__`.
11. **Native TPO Data API vs Yêu cầu người dùng:** `sources.Tpo()` cung cấp cấu trúc dữ liệu TPO nhưng không có sẵn VAH/VAL. Script phải tự tính toán mở rộng từng hàng kề (so sánh và chọn 1 hàng có TPO cao hơn mỗi bước, tie-break theo khoảng cách POC rồi ưu tiên hàng trên, VAH upper edge = `rows[high_index].price + row_size`) đến khi đạt $\ge 70\%$. Nguồn này mặc định gộp phiên cả ngày, không tự động tương thích với lịch 3 phiên Việt Nam S1/S2/S3 của người dùng. Cả `BlockProfile` và `sources.Tpo()` đều cần kiểm chứng trên Exness (`RUNTIME_REQUIRED`).

---

## MỤC E: CÁC NGUỒN CÒN THIẾU VÀ DANH MỤC KNOWLEDGE GAPS

Đã hoàn thiện đầy đủ tại tệp thực tế: `learning_records/KNOWLEDGE_GAPS.md` gồm 5 khoảng trống P0 và 5 khoảng trống P1:
- **P0 Blockers:**
  - `GAP-01`: Thiếu mã nguồn `SC_MarketStructure.mq5/.mqh` hoặc đặc tả hành vi chi tiết.
  - `GAP-02`: Thiếu mã nguồn `TPO Session.mq5/.mqh`, preset hoặc ảnh chụp các đầu ra thực tế.
  - `GAP-03`: Khả năng hỗ trợ `BlockProfile` và native TPO API (`sources.Tpo()`) cùng phiên bản Indie trên Exness cần smoke test tối thiểu độc lập; giải quyết xung đột phiên mặc định vs S1/S2/S3.
  - `GAP-04`: Thiếu danh mục kiểm kê tính năng chi tiết của SMC.
  - `GAP-05`: Cần xác nhận điểm neo gốc lưới (`grid origin`) và quy tắc gán nến ranh giới phiên của TPO.
- **P1 Gaps:**
  - `GAP-06`: Xác nhận quy cách hợp đồng/tick size XAUUSD trên tài khoản Exness thực tế.
  - `GAP-07`: Xác nhận bảng kiểm thử múi giờ và chuyển đổi DST cho phiên TPO.
  - `GAP-08`: Rà soát các vấn đề kỹ thuật của snapshot Stage 4 trong `02_ISSUE_REGISTER.md` (ISS-01 đến ISS-12).
  - `GAP-09`: Kiểm tra phiên bản Indie v5 trên Exness và tính năng `calc_on` khung thời gian nhỏ.
  - `GAP-10`: Giải pháp chống quá tải giao diện (visual clutter) khi bật đồng thời 4 module.

---

## MỤC F: KẾT QUẢ ĐÁNH GIÁ KIẾN THỨC (AUDITABLE ASSESSMENT RESULTS)

- **Đường dẫn tệp bài làm và ma trận chấm điểm:** `learning_records/ASSESSMENT_ANSWERS.md`
- **Số câu hỏi đã hoàn thành:** 35/35 câu hỏi (17 câu Critical C1–C17; 10 câu Core Logic Q17–Q26; 8 câu Platform & Quality Q27–Q34).
- **Kết quả ma trận kiểm toán từng câu:**
  - Phần Critical (C1–C17): Đạt 17/17 câu PASS (100% Critical Pass = 34/34 điểm thô).
  - Phần Core Logic (Q17–Q26): Đạt 10/10 câu PASS (10/10 điểm thô).
  - Phần Platform & Quality (Q27–Q34): Đạt 8/8 câu PASS (8/8 điểm thô).
  - Tổng điểm thô: $52/52$ điểm.
  - **Điểm chuẩn hóa theo rubric:** $(\text{Score} / 52) \times 100 = \mathbf{100/100}$.

---

## MỤC G: DANH MỤC CÁC TỆP BỘ NHỚ VÀ TÀI LIỆU BÀN GIAO ĐÃ HOÀN TẤT

Làm rõ danh mục tài liệu bàn giao gồm **bảy (7) tệp hồ sơ nằm trong `learning_records/`**, **một (1) tệp nhật ký cấp dự án `CHANGELOG_KNOWLEDGE.md`**, và **một (1) tệp kê khai mã băm `MANIFEST_CHECKSUMS.txt`** (tổng cộng 9 tệp trong bundle bàn giao):

1. `learning_records/LEARNING_REPORT.md` (Báo cáo học tập và kiểm chứng này).
2. `learning_records/CLAIM_LEDGER.md` (Sổ theo dõi 24 khẳng định và nhãn bằng chứng).
3. `learning_records/KNOWLEDGE_GAPS.md` (Sổ theo dõi 10 khoảng trống kiến thức và blocker P0/P1).
4. `learning_records/ASSESSMENT_ANSWERS.md` (Toàn văn câu trả lời 35 câu hỏi kèm ma trận kiểm toán chi tiết).
5. `learning_records/PROJECT_MEMORY.md` (Bản ghi nhớ trung tâm súc tích về hiện trạng và bất biến).
6. `learning_records/SESSION_START_CHECKLIST.md` (Quy trình 7 bước kiểm tra an toàn trước mỗi phiên làm việc).
7. `learning_records/README.md` (Mô tả hiện trạng hoàn chỉnh của bộ hồ sơ Phase 0).
8. `CHANGELOG_KNOWLEDGE.md` (Nhật ký thay đổi tri thức cấp dự án).
9. `MANIFEST_CHECKSUMS.txt` (Kê khai kích thước byte và mã băm SHA-256 của toàn bộ hồ sơ bàn giao).

Tất cả các tài liệu trên được đóng gói thành tệp nén: `Phase0_Deliverables_Bundle.zip` tại thư mục gốc dự án, thư mục handoff và thư mục artifact để Người quản lý kiểm tra độc lập.

---

## MỤC H: TUYÊN BỐ CAM KẾT KỶ LUẬT (EXPLICIT STATEMENT)

> **"Tôi xác nhận rằng tôi TUYỆT ĐỐI KHÔNG tạo mới, chỉnh sửa, refactor hoặc viết bất kỳ dòng mã nguồn chỉ báo nào (cả Indie lẫn MQL5) trong suốt Phase 0 này. Toàn bộ mã tham chiếu (`reference/`) và đặc tả đã khóa (`01_SPEC_LOCK.md`) giữ nguyên vẹn 100% mã băm SHA-256 so với baseline gốc. Tôi hiểu rõ rằng việc hoàn thành bài đánh giá kiến thức này không phải là sự tự động cho phép viết code; trạng thái cổng học tập hiện tại là PENDING và tôi sẽ dừng lại tại đây để chờ Người quản lý trực tiếp xem xét, đánh giá và phê duyệt chuyển giai đoạn."**
