# KNOWLEDGE GAPS & SOURCE BLOCKERS REGISTER

**Project:** XAUUSD visual-analysis indicator suite — Sonic R. + RSI Trend Pulse + SMC + TPO  
**Review Date:** 2026-10-29  
**Current Gate Status:** `PENDING`  
**Rule:** Tuyệt đối không tự suy đoán để lấp khoảng trống. Chỉ đóng gap khi có bằng chứng xác thực (source, ảnh chụp, log runtime hoặc quyết định bằng văn bản của người quản lý).

---

## 1. Phân loại khoảng trống kiến thức (Summary of Gaps)

| Nhóm khoảng trống | Số lượng mục | Hướng giải quyết |
|---|:---:|---|
| **P0 — Chặn triển khai chính xác (Source & Runtime Blockers)** | 5 | Cần người dùng cung cấp tài liệu/nguồn (`.mq5/.mqh`, ảnh, preset) hoặc thực hiện smoke test runtime Exness. |
| **P1 — Cần giải quyết trước khi đóng băng hành vi (Design & Audit Gaps)** | 5 | Có thể giải quyết thông qua rà soát sâu mã nguồn Stage 4, tài liệu kỹ thuật và quyết định của người quản lý. |

---

## 2. Danh mục chi tiết các khoảng trống P0 (Critical Blockers)

### GAP-01: Thiếu mã nguồn SMC (`SC_MarketStructure.ex5`)
- **Mức độ ưu tiên:** P0 (Chặn port mã nguồn).
- **Mô tả hiện trạng:** Người dùng chỉ cung cấp tệp nhị phân `SC_MarketStructure.ex5` (138 KB). Theo tài liệu chính thức của MetaEditor ([S13]), tệp EX5 được biên dịch từ `.mq5/.mqh` và che giấu hoàn toàn thuật toán nguồn. Không thể dịch ngược hoặc phục hồi thuật toán nguyên bản từ binary.
- **Tác động:** Không thể thực hiện "Source Port" (chuyển ngữ mã nguồn 1:1 sang Indie). Tên file không chứng minh indicator có BOS, CHoCH, OB, FVG, EQH/EQL hay Sweep.
- **Bằng chứng cần thiết để đóng gap:**
  - *Phương án A (Ưu tiên):* Người dùng cung cấp mã nguồn `SC_MarketStructure.mq5` và toàn bộ thư viện `.mqh` liên quan.
  - *Phương án B (Thay thế):* Nếu không có source, người dùng cung cấp tài liệu đặc tả hành vi (Behavioral Spec), ảnh chụp đầy đủ tab Inputs/Parameters và 3–5 ảnh chart minh họa các kịch bản thực tế. Khi đó, module được hạ nhãn thành `REIMPLEMENTATION — behaviorally tested` thay vì `SOURCE PORT`.
- **Trạng thái:** `OPEN — Chờ người dùng cung cấp`.

### GAP-02: Thiếu mã nguồn và đầu ra đầy đủ của TPO (`TPO_Session_v1.01.zip`)
- **Mức độ ưu tiên:** P0 (Chặn port mã nguồn).
- **Mô tả hiện trạng:** Tệp zip chỉ chứa `TPO Session.ex5` và `HUONG_DAN.txt`. Văn bản hướng dẫn chỉ nêu cấu hình row height (`InpTickSize=0.1`, `InpTicksPerRow=12` $\rightarrow$ row = 1.2 giá), chế độ đồng hồ server và lịch phiên S1/S2/S3. Không có mô tả về các đầu ra đồ họa (POC, VAH/VAL, Initial Balance, profile cells/letters/blocks).
- **Tác động:** Không thể biết indicator gốc có tính toán và vẽ POC, VAH/VAL hay Initial Balance không. Nếu tự ý code các mức này sẽ vi phạm nguyên tắc không suy đoán.
- **Bằng chứng cần thiết để đóng gap:**
  - Người dùng cung cấp `TPO Session.mq5` và `.mqh` phụ thuộc; HOẶC
  - File preset `.set`, ảnh chụp tab Inputs và ảnh chụp chart thực tế có chú thích rõ các đường/vùng mà indicator đang vẽ.
- **Trạng thái:** `OPEN — Chờ người dùng cung cấp`.

### GAP-03: Khả năng tương thích của `BlockProfile` và Native TPO API (`sources.Tpo()`) trên runtime Exness Terminal Web
- **Mức độ ưu tiên:** P0 (Chặn thiết kế đồ họa và nguồn dữ liệu TPO).
- **Mô tả hiện trạng:** Tài liệu TakeProfit Indie mô tả hai cơ chế liên quan đến TPO:
  1. Lớp đối tượng đồ họa `indie.drawings.BlockProfile` ([S11]) với các hàm `add_column`, `add_cell`, `add_level`.
  2. Nguồn dữ liệu TPO có cấu trúc `sources.Tpo()` và đối tượng `TpoProfile` (`indie.data`) ([S19, S20, S21]) cung cấp sẵn `point_of_control`, `initial_balance_high/low`, price rows (trong khi VAH/VAL phải tự tính toán mở rộng).
  Tuy nhiên, Exness Terminal Web là một môi trường nhúng lưu trữ (hosted runtime), chưa có bằng chứng xác nhận Exness đã kích hoạt `BlockProfile` hoặc mở thư viện `indie.data.sources.Tpo()`.
- **Tác động & Ranh giới kiến trúc:**
  - Nếu Exness không hỗ trợ `BlockProfile` hay `sources.Tpo()`, giải pháp TPO sẽ phải tự tính toán từ nến M5/M30 và vẽ bằng các đối tượng đồ họa cơ bản (`LineSegment`, `plot.line`).
  - Hơn nữa, native `sources.Tpo()` mặc định gộp cả pre-market, main session và post-market thành một profile ngày, KHÔNG tự động tương thích với lịch 3 phiên tùy biến theo giờ Việt Nam (S1 Á, S2 Âu, S3 Mỹ) và cấu hình row height $1.2$ của indicator gốc `TPO Session v1.01`. Không được tự ý thay thế đặc tả của người dùng bằng native API.
- **Bằng chứng cần thiết để đóng gap:**
  - Chạy smoke test tối thiểu độc lập trên Exness Terminal Web (khi được Quản lý cấp phép) để kiểm tra: (a) `BlockProfile` có vẽ được không; (b) `sources.Tpo()` có gọi được không.
- **Trạng thái:** `OPEN — Cần smoke test trên Exness (RUNTIME_REQUIRED)`.

### GAP-04: Danh mục tính năng (Feature Inventory) của SMC
- **Mức độ ưu tiên:** P0 (Chặn triển khai logic).
- **Mô tả hiện trạng:** Chưa có bảng kiểm kê chi tiết về từng tính năng SMC: quy tắc xác nhận đỉnh/đáy (số nến left/right), điều kiện phá vỡ BOS/CHoCH (dùng giá đóng cửa hay râu nến), vòng đời của vùng cung cầu/Order Block (kéo dài bao nhiêu nến, điều kiện vô hiệu hóa, điều kiện xóa/giữ lại khi bị xuyên qua).
- **Tác động:** Nguy cơ đưa vào logic SMC của bên thứ ba (như LuxAlgo [S7], QuantumAlgo [S8]) làm sai lệch hoàn toàn hành vi của công cụ mà người dùng đang quen sử dụng.
- **Bằng chứng cần thiết để đóng gap:**
  - Bảng kiểm kê tính năng được trích xuất từ source hoặc xác nhận bằng văn bản giữa người quản lý và người dùng.
- **Trạng thái:** `OPEN — Chờ thông tin từ người dùng`.

### GAP-05: Thuật toán binning giá và xử lý nến giao ranh giới phiên của TPO
- **Mức độ ưu tiên:** P0 (Chặn thuật toán TPO).
- **Mô tả hiện trạng:** Dù đã biết `row_height = 1.2`, thuật toán gom giá vào hàng (binning) vẫn đòi hỏi một điểm gốc lưới (grid origin). Ví dụ: `floor(price / 1.2) * 1.2` hay neo theo mức giá mở cửa của phiên? Ngoài ra, khi một nến M30/M15 nằm vắt ngang thời điểm đóng/mở phiên (ví dụ 14:59 sang 15:00), nến đó được phân bổ về phiên nào? Một nến quét qua nhiều hàng giá thì tính tất cả các hàng hay chỉ giá đóng cửa?
- **Tác động:** Sai lệch hình dạng profile và số lượng đếm TPO so với bản gốc MT5.
- **Bằng chứng cần thiết để đóng gap:**
  - Kiểm tra source code hoặc chạy đối chiếu song song giữa MT5 và bản thử nghiệm trên cùng chuỗi nến lịch sử.
- **Trạng thái:** `OPEN — Chờ source code hoặc dữ liệu đối chiếu`.

---

## 3. Danh mục chi tiết các khoảng trống P1 (Design & Audit Gaps)

### GAP-06: Xác nhận thông số hợp đồng và múi giờ hiển thị của XAUUSD trên Exness
- **Mức độ ưu tiên:** P1.
- **Mô tả hiện trạng:** Hướng dẫn ghi `InpTickSize=0.1`, nhưng trên Exness giá vàng có thể hiển thị 2 hoặc 3 chữ số thập phân (`digits = 2` hoặc `digits = 3`, `tick_size = 0.01` hoặc `0.001`). Cần xác nhận quy cách hợp đồng thực tế trên tài khoản Exness đang dùng.
- **Hướng giải quyết:** Có thể kiểm tra trực tiếp thông số hợp đồng (Contract Specifications) trên Exness Terminal hoặc bảng dữ liệu giá.
- **Trạng thái:** `OPEN — Có thể giải quyết bằng nghiên cứu/kiểm tra tài khoản`.

### GAP-07: Xác nhận chính sách đổi giờ mùa hè/mùa đông (DST) cho phiên TPO
- **Mức độ ưu tiên:** P1.
- **Mô tả hiện trạng:** Server Exness hoạt động theo chuẩn UTC+0 quanh năm (không đổi giờ DST). Tuy nhiên, các phiên Á/Âu/Mỹ theo giờ địa phương London và New York đều có sự chuyển đổi giữa giờ mùa hè (EDT/BST) và giờ mùa đông (EST/GMT). Hướng dẫn của tác giả ghi nhận lịch phiên theo giờ Việt Nam có điều chỉnh 1 giờ cho mùa hè.
- **Hướng giải quyết:** Xây dựng bảng ma trận kiểm thử chuyển đổi thời gian (Timezone conversion test matrix) với các mốc thời gian cụ thể trước, trong và sau các tuần chuyển giờ DST của Mỹ và Châu Âu.
- **Trạng thái:** `OPEN — Có thể giải quyết bằng đặc tả kỹ thuật và test case`.

### GAP-08: Rà soát và giải quyết các điểm không khớp trong snapshot Stage 4 (ISS-01 đến ISS-12)
- **Mức độ ưu tiên:** P1.
- **Mô tả hiện trạng:** Sổ vấn đề `02_ISSUE_REGISTER.md` đã liệt kê 12 vấn đề kỹ thuật của Stage 4, trong đó nổi bật:
  - `ISS-01`: Script 2 đang gộp toàn bộ điều kiện setup H4/H1/M15 vào marker M5 momentum thay vì giữ vai trò xác nhận momentum độc lập.
  - `ISS-04`: Sự kết hợp giữa giá trị `[1]` và `offset=-1` trong hàm vẽ Marker có thể làm lệch vị trí hiển thị nến.
  - `ISS-05`: Nhận diện sóng HL/LH dùng cực trị vùng quét hay pivot xác nhận có độ trễ.
  - `ISS-07`: Cơ chế khóa chu kỳ `lock_u_bar/lock_ph` có thể chặn các đỉnh mới thấp hơn trong cùng một xu hướng.
- **Hướng giải quyết:** Thực hiện audit chi tiết ở Phase tiếp theo; đề xuất bản vá tối thiểu có kiểm soát, không tự ý sửa đổi khi chưa có kịch bản test tái hiện và phê duyệt.
- **Trạng thái:** `OPEN — Đang theo dõi trong Issue Register`.

### GAP-09: Kiểm tra phiên bản Indie v5 trên Exness và tính năng `calc_on` khung thời gian nhỏ (LTF)
- **Mức độ ưu tiên:** P1.
- **Mô tả hiện trạng:** Theo changelog của TakeProfit ([S17]), khả năng gọi `calc_on` cho khung thời gian nhỏ hơn (LTF) chỉ xuất hiện từ bản Indie v5.14.0 trở đi. Hiện tại hai script lõi chỉ gọi `calc_on` lên khung thời gian lớn hơn (H4, H1, M15 từ biểu đồ M5), nên không bị ảnh hưởng. Tuy nhiên nếu sau này một module cần gọi dữ liệu M5 từ biểu đồ M30/H1, cần xác nhận Exness đã cập nhật lên phiên bản $\ge 5.14.0$ hay chưa.
- **Hướng giải quyết:** Kiểm tra thông tin phiên bản khi biên dịch trên Exness Terminal Web.
- **Trạng thái:** `OPEN — Cần kiểm tra môi trường thực tế`.

### GAP-10: Đánh giá khả năng hiển thị đồng thời 4 module mà không gây quá tải giao diện (Visual Clutter)
- **Mức độ ưu tiên:** P1.
- **Mô tả hiện trạng:** Khi gắn đồng thời Sonic R. (5 đường EMA + swing + round numbers + markers), SMC (vùng cấu trúc, nhãn BOS/CHoCH), TPO (các khối profile theo phiên) và pane phụ RSI Trend Pulse, biểu đồ có thể bị rối mắt và che khuất nến giá.
- **Hướng giải quyết:** Thiết lập các thông số bật/tắt độc lập cho từng module, sử dụng độ trong suốt `color.rgba` tinh tế, ưu tiên hiển thị nến giá ở lớp trên cùng.
- **Trạng thái:** `OPEN — Thuộc thiết kế UX ở phase sau`.

---

## 4. Tóm tắt yêu cầu cần người dùng cung cấp

Để chuyển từ giai đoạn học tập sang triển khai thực tế mà không vi phạm tính toàn vẹn của mã nguồn, người dùng cần được thông báo và hỗ trợ cung cấp:
1. File mã nguồn gốc `SC_MarketStructure.mq5` và các file thư viện `.mqh` đi kèm (nếu có).
2. File mã nguồn gốc `TPO Session.mq5` và các file thư viện `.mqh` đi kèm (nếu có).
3. Ảnh chụp màn hình rõ nét toàn bộ tab **Inputs/Parameters** của cả 2 indicator trên MT5.
4. Một số ảnh chụp màn hình thực tế trên MT5 thể hiện các mức và nhãn mà 2 indicator vẽ ra trong các điều kiện thị trường khác nhau (trend, sideway, đảo chiều, ranh giới phiên).
