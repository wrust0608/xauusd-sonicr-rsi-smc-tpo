# BỘ HỒ SƠ BÀN GIAO AGENT
## Sonic R. + RSI Trend Pulse — XAUUSD / Exness Terminal / Indie v5

**Phiên bản hồ sơ:** 1.0  
**Ngày chốt hồ sơ:** 29-10-2026  
**Trạng thái:** Đặc tả sản phẩm được khóa; mã Stage 4 chỉ là bản tham chiếu chưa được nghiệm thu trên Exness.

## Mục đích của gói này

Gói này giúp một agent tiếp tục triển khai bộ chỉ báo theo đúng mục tiêu ban đầu, đồng thời tạo cơ sở để kiểm toán thay đổi và nghiệm thu có bằng chứng. Không coi báo cáo giai đoạn trước là bằng chứng runtime nếu báo cáo không kèm log hoặc ảnh thực tế.

## Đọc theo thứ tự

1. `01_SPEC_LOCK.md` — yêu cầu không được tự ý thay đổi.
2. `02_ISSUE_REGISTER.md` — điểm mâu thuẫn/rủi ro cần kiểm tra, không được “sửa theo cảm giác”.
3. `03_QA_ACCEPTANCE.md` — bộ kiểm thử và điều kiện đạt.
4. `04_AGENT_WORK_ORDER.md` — chỉ thị công việc giao trực tiếp cho agent.
5. `reference/SonicR_Setup_Overlay_stage4_reference.indie` và `reference/RSI_Trend_Pulse_Pane_stage4_reference.indie` — snapshot mã Stage 4 để đối chiếu, **không phải bản đã được chứng nhận chạy đúng**.
6. `source_archive/` — hồ sơ giai đoạn 1–4 được lưu giữ để truy nguyên lịch sử, xung đột và quyết định.

## Thứ tự ưu tiên khi tài liệu mâu thuẫn

1. Phạm vi bất biến và mục tiêu trong `01_SPEC_LOCK.md`.
2. Các quyết định thiết kế được ghi rõ là đã khóa trong cùng tài liệu.
3. Các phát hiện trong `02_ISSUE_REGISTER.md`, với trạng thái và bằng chứng tương ứng.
4. Mã Stage 4 để xác định hành vi hiện tại của bản tham chiếu.
5. Báo cáo giai đoạn cũ hơn chỉ dùng làm lịch sử, không tự động ưu tiên.

Nếu một yêu cầu chưa đủ rõ để quyết định mà có thể làm thay đổi hành vi tín hiệu, agent phải **dừng thay đổi phần liên quan**, mô tả hai cách hiểu và đề xuất lựa chọn. Không được tự âm thầm chọn.

## Vai trò quản lý

Agent thực hiện kiểm toán và triển khai kỹ thuật. Tôi sẽ là cổng rà soát: xem xét yêu cầu, bằng chứng lỗi, bản diff, số dòng, trạng thái API và kết quả kiểm thử trước khi chấp nhận thay đổi. Người dùng có thể chuyển nguyên gói này cho agent; sau đó gửi lại phản hồi, bản mã, diff, log biên dịch và ảnh biểu đồ để tôi kiểm định tiếp.

---

# ĐẶC TẢ ĐƯỢC KHÓA — PRODUCT & TECHNICAL SPECIFICATION

## 1. Danh tính dự án

- **Tên:** Hệ thống chỉ báo quan sát cấu trúc và nhận diện setup Sonic R. + RSI Trend Pulse cho XAUUSD.
- **Môi trường:** Exness Terminal Web, ngôn ngữ TakeProfit Indie v5.
- **Mục đích:** Làm rõ cấu trúc giá, thiên hướng động lượng đa khung, vùng chờ pullback và những thời điểm có khả năng hình thành setup; hỗ trợ người dùng tự đánh giá bằng mắt.
- **Không phải:** robot giao dịch, chiến lược tự động, công cụ dự đoán chắc chắn hoặc hệ thống quản lý lệnh.

## 2. Phạm vi bất biến — KHÔNG ĐƯỢC LỆCH

Bộ chỉ báo chỉ thực hiện ba nhiệm vụ:

1. Hiển thị cấu trúc giá và các mức tham chiếu quan trọng.
2. Hiển thị trạng thái RSI/động lượng theo chuỗi thời gian đa khung H4 → H1 → M15 → M5.
3. Đánh dấu thật kín đáo các điểm setup tiềm năng hoặc xác nhận động lượng bằng ký hiệu nhỏ ▲/▼.

Tuyệt đối không bổ sung: đặt/sửa/hủy lệnh; theo dõi vị thế; SL/TP; TP1/TP2; tỷ lệ R:R; cơ chế chốt lời; thoát lệnh; cảnh báo thoát lệnh; nhãn chữ BUY/SELL; hay bất kỳ hành động tự động giao dịch nào.

Không được thêm thành phần mới nếu không trực tiếp giúp ba nhiệm vụ phía trên. Không được loại bỏ thành phần cốt lõi chỉ để tiết kiệm dòng mà chưa có phê duyệt.

## 3. Kiến trúc đã khóa: đúng 2 script độc lập

### Script 1 — `SonicR_Setup_Overlay`

**Vị trí:** overlay trên biểu đồ giá.

**Nhiệm vụ:** đưa Sonic R. và điều kiện bối cảnh đa khung lên biểu đồ giá; phát tam giác nhỏ khi đủ điều kiện của một setup tiềm năng.

**Thành phần hiển thị bắt buộc:**

- Dragon: EMA 34 của High, Close và Low (3 chuỗi; hiển thị tinh tế, đường giữa rõ hơn hai biên).
- Trend Line: EMA 89 của Close.
- EMA 200: đường tham khảo; mặc định không bắt buộc làm bộ lọc cứng (`use_e200 = False`).
- Swing High và Swing Low gần nhất đã xác nhận, ghi là mức tham chiếu cấu trúc, không khẳng định đó luôn là hỗ trợ/kháng cự đã được xác thực.
- Hai mức giá tròn động trên/dưới giá theo `rnd_step`, mặc định 10.0 cho XAUUSD, có thể chỉnh.
- Tam giác ▲ dưới nến cho setup tăng tiềm năng, ▼ trên nến cho setup giảm tiềm năng; không có chữ BUY/SELL.

**Logic giá cốt lõi:**

- Tăng: cấu trúc Sonic R. theo hướng L → H → HL, tương tác Dragon, Trend Line EMA 89 và điều kiện động lượng/MTF.
- Giảm: cấu trúc H → L → LH với điều kiện đối xứng.
- Tách ba khái niệm: **Touch** (giá chạm dải Dragon), **Bounce** (giá bật và đóng lại ra ngoài dải theo hướng dự kiến), **Swing Breakout** (giá đóng cửa phá mức swing liên quan). Touch đơn lẻ không phải trigger vào setup.
- `trig_mode = 0` là Bounce; `trig_mode = 1` là Swing Breakout trong snapshot Stage 4. Bất kỳ thay đổi định nghĩa nào phải được chứng minh và ghi log.
- `use_e200 = False` là mặc định: vẽ EMA 200 nhưng không dùng làm điều kiện bắt buộc. Khi bật, giá đóng cửa phải ở đúng phía EMA 200.

### Script 2 — `RSI_Trend_Pulse_Pane`

**Vị trí:** cửa sổ phụ, trục RSI 0–100.

**Nhiệm vụ:** thể hiện động lượng RSI tại khung biểu đồ (dự kiến M5), ngữ cảnh xu hướng H4/H1, vùng chờ M15 và xác nhận động lượng M5.

**Thành phần bắt buộc:**

- RSI 14 (Wilder).
- EMA 9 tính trên chuỗi RSI, không phải giá XAUUSD.
- WMA 45 tính trên chuỗi RSI, không phải giá XAUUSD.
- Mốc tham chiếu 30, 40, 50, 60, 70; dải 40–60 được làm rõ vừa phải.
- Dấu/ngữ cảnh 45 cho HTF tăng + M15 trong vùng chờ; 55 cho HTF giảm + M15 trong vùng chờ.
- Tam giác RSI rất nhỏ chỉ biểu thị xác nhận động lượng M5 theo định nghĩa đã khóa; không dùng để thay thế tam giác setup trên biểu đồ giá.

**Vai trò marker — yêu cầu gốc:**

- Marker ở Script 1 = setup giá tổng hợp tiềm năng sau khi điều kiện giá, MTF và trigger đều đạt.
- Marker ở Script 2 = xác nhận động lượng M5 (phân kỳ/mô hình kết thúc nhịp + RSI cắt EMA 9 theo hướng tương ứng).
- Hai marker không bắt buộc xuất hiện trên cùng một thanh nến, vì chúng biểu thị hai tầng thông tin khác nhau. Snapshot Stage 4 hiện đang gộp điều kiện H4/H1/M15 vào `fire_u/fire_d` của Script 2; đây là điểm không khớp cần xử lý có kiểm soát theo `02_ISSUE_REGISTER.md`, không được sửa lén.

## 4. MTF — khung thời gian và logic tham chiếu

### H4/H1: thiên hướng

- Tính riêng trên mỗi khung: RSI 14, EMA 9(RSI), WMA 45(RSI) và độ dốc WMA 45.
- Tăng: RSI và EMA 9 nằm phía trên WMA 45; WMA 45 dốc lên; ba đường không chụm quá mức.
- Giảm: RSI và EMA 9 nằm phía dưới WMA 45; WMA 45 dốc xuống; ba đường không chụm quá mức.
- `strict_htf = False` là mặc định khuyến nghị trong hồ sơ thiết kế: H4 phải thỏa điều kiện đầy đủ; H1 có EMA 9 đúng phía WMA 45, WMA 45 dốc cùng hướng và spread đủ rộng; RSI H1 chỉ bắt buộc cùng phía khi bật strict mode.
- Ngưỡng tham chiếu trong snapshot Stage 4: `min_slp = 0.05`, `tangle_sp = 2.5`. Đây là ngưỡng khởi tạo cần kiểm thử trên Exness, không phải ngưỡng sinh lời đã được chứng minh.

### M15: vùng chờ pullback

- Bối cảnh tăng: RSI M15 hồi về 40–50 hoặc nằm trong dung sai của WMA 45.
- Bối cảnh giảm: RSI M15 hồi về 50–60 hoặc nằm trong dung sai của WMA 45.
- `w45_tol = 2.0` là giá trị mặc định của snapshot Stage 4.
- Không được hiểu việc vào vùng chờ M15 là setup hoàn tất; đây chỉ là điều kiện bối cảnh.

### M5: cấu trúc và momentum trigger

- Tìm phân kỳ Regular/Hidden và mô hình RSI Double Bottom/Double Top.
- Với đáy: ghép RSI Pivot Low với Price Low; với đỉnh: ghép RSI Pivot High với Price High.
- Khoảng cách 2 pivot: 3 đến `d_max` thanh M5; mặc định `d_max = 24`.
- Double Bottom/Top dùng `db_tol = 3.0` và độ nổi bật trung gian tối thiểu `db_prom = 4.0` trong snapshot Stage 4.
- Xác nhận momentum bằng giao cắt RSI qua EMA 9 theo hướng cần thiết trên nến M5 đã đóng.
- Không sử dụng pivot chưa xác nhận làm tín hiệu lịch sử mà không ghi rõ độ trễ/điều kiện xác nhận.

## 5. Quy tắc nến đóng và MTF

- Mọi trigger M5 phải dựa trên nến M5 đã đóng.
- Giá trị HTF phải đọc từ nến HTF đã đóng theo đúng ngữ cảnh HTF, không lấy `[1]` của chuỗi đã ánh xạ xuống M5 rồi diễn giải nhầm thành nến H1/H4 đã đóng.
- `@sec_context` + `Context.calc_on()` phải được khởi tạo trong `__init__` theo tài liệu Indie hiện hành.
- Snapshot Stage 4 trả RSI/EMA/WMA và slope từ bên trong `HtfPulse` bằng `[1]`/`[2]`. Đây là cấu trúc dự kiến; vẫn phải thử quanh ranh giới đóng nến và sau reload trước khi tuyên bố non-repainting.
- Nghiệm thu phải phân biệt: (a) kiểm tra cú pháp; (b) kiểm tra API tĩnh; (c) biên dịch thật; (d) kiểm tra trực quan; (e) kiểm tra ổn định sau khi tải lại. Không gộp các trạng thái này làm một.

## 6. Giới hạn mã và đồng bộ tham số

- Mỗi script không vượt quá **128 dòng vật lý**, bao gồm header ngôn ngữ và dòng trống.
- Khi đếm dòng, lưu đúng tệp mã cuối cùng sẽ dán vào Exness; không đếm bản rút gọn khác với bản bàn giao.
- Snapshot Stage 4 trích trực tiếp từ báo cáo có 116 dòng vật lý cho Script 1 và 83 dòng cho Script 2 (đếm trên tệp trích xuất ở bộ hồ sơ này). Báo cáo Stage 4 ghi 113/81; số trong báo cáo không khớp với snapshot trích được. Cả hai snapshot vẫn dưới 128 dòng nhưng phải đếm lại mỗi lần thay đổi.
- Các tham số động lượng sau phải giữ giống hệt nhau ở cả hai script: `strict_htf`, `min_slp`, `tangle_sp`, `w45_tol`, `d_max`, `db_tol`, `db_prom`.
- Tham số riêng Script 1: `use_e200`, `trig_mode`, `rnd_step`.

## 7. Giá trị khởi tạo hiện tại

| Tham số | Mặc định | Phạm vi/ý nghĩa |
|---|---:|---|
| `strict_htf` | `False` | Khóa chặt đồng thuận RSI cả H1 khi bật |
| `min_slp` | `0.05` | Độ dốc WMA45 RSI trên H4/H1 |
| `tangle_sp` | `2.5` | Spread tối thiểu giữa RSI/EMA9/WMA45 |
| `w45_tol` | `2.0` | Dung sai khi RSI M15 chạm WMA45 |
| `d_max` | `24` | Lookback tối đa cho cặp pivot M5 (param max 50) |
| `db_tol` | `3.0` | Sai lệch tối đa giữa hai pivot RSI DB/DT |
| `db_prom` | `4.0` | Độ nổi bật tối thiểu của cực trị trung gian RSI |
| `use_e200` | `False` | EMA200 tham khảo, không lọc cứng mặc định |
| `trig_mode` | `0` | 0 = Bounce, 1 = Swing Breakout |
| `rnd_step` | `10.0` | Bước giá tròn |

Các ngưỡng trên là cấu hình ban đầu để quan sát và kiểm định, không được quảng bá như thông số tối ưu hoặc bằng chứng lợi nhuận.

## 8. Nguyên tắc UX/hiển thị

- Ưu tiên nến giá; các đường Dragon/EMA/Swing/round level phải đủ rõ nhưng không lấn át nến.
- Marker càng nhỏ càng tốt nhưng phải nhìn thấy được trong giao diện thật.
- Không vẽ nhiều nhãn chữ; không BUY/SELL; không tô nền đậm hoặc che kín giá.
- Marker chỉ xuất hiện ở thanh thỏa điều kiện; các thanh khác trả giá trị rỗng/NaN theo cách API phù hợp.
- Marker offset và dữ liệu `[1]` phải được kiểm tra trực quan: không mặc định rằng dùng cả `value` từ `[1]` và `offset=-1` tự động cho đúng thanh nến.

## 9. Chất lượng và tiêu chí hoàn thành

Hệ thống chỉ được xem là hoàn tất khi:

1. Hai script đúng cấu trúc và phạm vi.
2. Mỗi script ≤128 dòng vật lý.
3. Không có mismatch API theo tài liệu Indie hiện hành.
4. Biên dịch trực tiếp thành công trong Exness Terminal.
5. Các điều kiện setup và trạng thái vùng chờ được xác minh trên biểu đồ XAUUSD M5.
6. Marker nằm đúng nến và không che nến quá mức.
7. Các trường hợp sideway, breakout giả, pullback thất bại và thiếu dữ liệu không tạo tín hiệu sai theo đặc tả.
8. Reload/F5 và ranh giới nến M5/M15/H1/H4 không làm dịch chuyển hoặc biến mất marker đã chốt; nếu có hành vi nào không thể đảm bảo, phải mô tả chính xác giới hạn.
9. Mọi thay đổi đều truy vết được tới yêu cầu cụ thể và có test tái hiện.

**Lưu ý:** không có chỉ báo nào được bảo đảm sinh lời. Bộ chỉ báo chỉ cung cấp thông tin trực quan; quyết định cuối cùng thuộc người dùng.

---

# SỔ VẤN ĐỀ — EVIDENCE & DECISION REGISTER

Quy ước trạng thái:
- **LOCKED**: yêu cầu sản phẩm đã khóa.
- **CONFIRMED FACT**: quan sát trực tiếp trong hồ sơ/mã hoặc tài liệu chính thức.
- **POTENTIAL DEFECT**: có dấu hiệu rủi ro nhưng cần chứng minh theo hành vi mong muốn.
- **DESIGN DECISION**: có nhiều cách triển khai hợp lý; không thể gọi là bug nếu chưa chọn tiêu chí.
- **TEST REQUIRED**: chỉ đóng sau kiểm thử thực tế.
- **NOT VERIFIED**: chưa có bằng chứng.

## P0 — Cần giữ/có thể chặn nghiệm thu

### ISS-01 — Vai trò marker Script 2 không khớp ý định ban đầu
- **Phân loại:** Specification mismatch, mức P0.
- **Ý định gốc:** Script 1 báo setup giá tổng hợp; Script 2 báo xác nhận momentum M5. Hai marker không bắt buộc xuất hiện trên cùng một nến.
- **Quan sát ở snapshot Stage 4:** `fire_u/fire_d` trong Script 2 yêu cầu đồng thời `b4`, `b1`, `m15` và `m5_bull/bear`; vì vậy marker Script 2 cũng đang bị khóa bởi toàn bộ ngữ cảnh setup.
- **Hành động:** Agent phải đề xuất diff tối thiểu để Script 2 marker diễn tả đúng vai trò xác nhận M5, trong khi vẫn giữ đường/vạch bối cảnh H4/H1/M15 trên pane. Không đổi điều kiện marker nếu chưa mô tả rõ expected behavior và được quản lý duyệt.

### ISS-02 — Đếm dòng trong báo cáo Stage 4 không khớp snapshot mã
- **Phân loại:** Confirmed fact / bookkeeping discrepancy, mức P1.
- **Bằng chứng:** Tệp trích xuất từ báo cáo Stage 4 có 116 dòng vật lý ở Script 1 và 83 ở Script 2; báo cáo ghi 113/81.
- **Hành động:** Dùng số đếm từ file bàn giao thực tế, tự động đếm lại sau mỗi patch. Không cần sửa logic chỉ để khớp con số báo cáo cũ.

### ISS-03 — Chưa có bằng chứng compile/runtime trên Exness
- **Phân loại:** Test required, mức P0.
- **Bằng chứng:** Stage 3/4 đều ghi Compiled on Exness = PENDING; chưa có log hoặc ảnh xác nhận.
- **Hành động:** Không ghi PASS cho compile, visual QA hoặc repaint cho tới khi có bằng chứng từ môi trường thật.

### ISS-04 — Cần xác nhận vị trí marker khi kết hợp `[1]` với `offset=-1`
- **Phân loại:** Test required / potential defect, mức P0.
- **Quan sát:** Snapshot trả `plot.Marker` có giá trị lấy từ thanh `[1]` và đồng thời `offset=-1`.
- **Rủi ro:** Có thể đặt marker lệch thanh so với ý định; chỉ runtime/chart inspection mới xác định được hành vi hiển thị chính xác.
- **Hành động:** Thử trên chart, ghi rõ timestamp/nến mục tiêu và nến marker thực tế. Chỉ sửa sau khi có ví dụ tái hiện lệch vị trí.

## P1 — Rà soát logic có kiểm soát

### ISS-05 — Swing HL/LH: pivot được xác nhận hay cực trị của pullback?
- **Phân loại:** Design decision / potential defect.
- **Mục tiêu:** Nhận diện wave L→H→HL / H→L→LH; hồ sơ Stage 1/2 nhấn mạnh swing/pivot đã xác nhận.
- **Quan sát:** Snapshot dùng pivot price `is_ph/is_pl` với điều kiện bất đẳng thức bất đối xứng; đồng thời `p_hl/p_lh` được cập nhật bằng cực trị trong vòng quét, không phải mọi lần cập nhật đều là pivot đã xác nhận.
- **Hành động:** Định nghĩa trong code review: (a) swing gốc L/H cần pivot xác nhận nào; (b) pullback HL/LH có cần pivot xác nhận hay chỉ cần cực trị vùng hồi; (c) tối thiểu bao nhiêu thanh sau điểm cực trị mới được xem là đã xác nhận. Không tự thay thuật toán chỉ vì có phương án khác.

### ISS-06 — Touch/Bounce/Break cần giữ tách biệt
- **Phân loại:** Design decision có baseline trong Stage 4.
- **Baseline hiện tại:** Touch là điều kiện tiền đề; Bounce yêu cầu đóng nến trở lại bên ngoài Dragon theo hướng dự kiến; Swing Breakout dùng đóng cửa vượt swing level. `trig_mode=0` Bounce, `1` Break.
- **Cần kiểm tra:** Tình huống chỉ Touch không phát marker; Bounce ở nến sau Touch có thể phát nếu cấu trúc và MTF khác đạt; breakout giả trước khi có cấu trúc không được phát marker.
- **Hành động:** Không chuyển các định nghĩa này thành trigger đơn giản hơn; không gộp Touch với Bounce.

### ISS-07 — Reset/re-arm hai cơ chế khóa
- **Phân loại:** Test required / design boundary.
- **Baseline Stage 4:** Script 1 khóa chu kỳ theo sóng giá (`lock_u_bar/lock_ph`, đối xứng cho giảm); Script 2 khóa theo chu kỳ momentum (`latch_up/latch_dn` và bar lock).
- **Giới hạn được thừa nhận trong Stage 4:** Ở Script 1, đỉnh H mới thấp hơn `lock_ph` có thể tiếp tục bị chặn trong cùng xu hướng giá dài; cần vượt mức đã khóa hoặc reset khi Dragon Close cắt qua EMA89. Đây có thể là cách bảo vệ one-shot nhưng phải chấp nhận rõ là hành vi có chủ đích.
- **Hành động:** Dùng test lặp lại trong `03_QA_ACCEPTANCE.md`; không thay ngưỡng reset hoặc latch nếu chưa có ca thất bại tái hiện.

### ISS-08 — Ghép RSI pivot với cửa sổ giá `[k, k+1]`
- **Phân loại:** Design choice, không phải bug đã chứng minh.
- **Baseline Stage 4:** RSI pivot low ghép `min(low[k], low[k+1])`; RSI pivot high ghép `max(high[k], high[k+1])`. Khoảng cách pivot tối thiểu 3 giúp cửa sổ hai nến không chồng lấn.
- **Hành động:** Giữ nguyên trong patch trừ khi có phản ví dụ cho thấy sai loại phân kỳ hoặc gán sai điểm giá. Không đổi chỉ vì một mapping khác cũng có thể hợp lý.

### ISS-09 — RSI pane cần các mốc 30/40/50/60/70 rõ ràng
- **Phân loại:** Specification conformance / visual test.
- **Quan sát:** Snapshot có level 50 và band 40–60, 30–70; đường biên của band có thể hiển thị nhưng chưa chứng minh đáp ứng đầy đủ yêu cầu về từng mốc tham chiếu.
- **Hành động:** Kiểm tra ảnh thực tế. Nếu các mốc 30/40/60/70 không rõ như yêu cầu, patch hiển thị nhỏ nhất để làm chúng nhìn thấy được mà vẫn trong 128 dòng.

### ISS-10 — Latch reset theo ngưỡng RSI phải có chu kỳ tái kích hoạt nhất quán
- **Phân loại:** Potential defect / test required.
- **Quan sát:** Script 2 reset latch theo đối hướng HTF hoặc ngưỡng RSI M15/M5 (ví dụ nhịp đẩy tăng M15 ≥55 và M5 ≥60 mở lại khóa tăng). Đây là quy tắc chu kỳ cụ thể, không phải quy tắc phổ quát của RSI Trend Pulse.
- **Hành động:** Chạy test một chu kỳ có một cross, nhiều cross, pullback sâu, HTF đảo chiều tạm thời và chu kỳ mới độc lập. Kiểm tra có phát trùng trong cùng một nhịp hoặc chặn sai chu kỳ mới hay không.

## P2 — Hạng mục xác nhận môi trường

### ISS-11 — Warm-up và guard dữ liệu thiếu
- **Phân loại:** Test required.
- **Quan sát:** Script 1 đợi `e200[1]` không NaN ngay cả khi `use_e200=False`; Script 2 đợi đủ dữ liệu RSI và HTF. Đây có thể khiến marker bị trì hoãn ở phần dữ liệu đầu, chưa được chứng minh là bug.
- **Hành động:** Kiểm tra chart ít dữ liệu và chart đủ dữ liệu; không được runtime error. Ghi nhận hành vi guard trước khi tối ưu.

### ISS-12 — Tương thích API Indie và giới hạn dòng
- **Phân loại:** Static API evidence + test required.
- **Đã đối chiếu tài liệu hiện hành:** `@plot.line` có tham số `id` trước `title`; `@plot.marker` nhận `title`, `color`, `text`, `style`, `position`, `size`; `size` là số nguyên; `plot.Marker` nhận `value`, `color`, `text`, `offset`; marker style hiện có `NONE/CIRCLE/LABEL/CROSS`, position có `ABOVE/BELOW/LEFT/RIGHT/CENTER`. `calc_on()` phải gọi trong `__init__`.
- **Chưa xác minh:** biên dịch được trên phiên bản Exness Terminal đang dùng và hình tam giác Unicode hiển thị hợp lý.
- **Hành động:** Tham chiếu nguồn chính thức trong README và kiểm thử thực tế.

## Nguyên tắc xử lý phát hiện

Mỗi thay đổi đề xuất phải ghi đủ: `ISS-ID`; requirement bị vi phạm; vị trí trong bản mã; đầu vào tái hiện; hành vi hiện tại; hành vi mong đợi; patch tối thiểu; test trước/sau; tác động số dòng; tình trạng compile/visual/repaint. Nếu thiếu một trong các yếu tố chứng minh, giữ trạng thái chưa xác nhận và không gộp vào patch logic.

---

# KẾ HOẠCH QA & NGHIỆM THU

## A. Phân cấp bằng chứng

| Cấp kiểm chứng | Bằng chứng tối thiểu | Không được kết luận thay thế |
|---|---|---|
| Static review | diff, vị trí dòng, truy vết requirement | Không chứng minh runtime |
| Syntax/static API | kiểm tra cú pháp Python-like và đối chiếu tài liệu Indie | Không tương đương compile trên Exness |
| Compile on Exness | kết quả Compile/Add to Chart của từng script hoặc ảnh/log rõ | Không chứng minh logic đúng |
| Visual QA | ảnh chart XAUUSD M5 có đủ hai script, các đường và marker | Không chứng minh non-repaint |
| Behavioral tests | các kịch bản có input/time/expected/actual | Không thay thế kiểm thử ranh giới MTF |
| Reload/repaint | ảnh trước/sau F5 hoặc log timestamp qua ranh giới nến | Không tuyên bố tuyệt đối nếu chưa thử đủ |

## B. Checklist triển khai trên Exness

1. Mở Exness Terminal **Web**, chọn XAUUSD, đặt khung M5.
2. Tạo script mới và dán nguyên văn `SonicR_Setup_Overlay`; lưu/compile; thêm vào chart.
3. Tạo script mới và dán nguyên văn `RSI_Trend_Pulse_Pane`; lưu/compile; thêm vào chart phụ.
4. Xác nhận cả hai dùng cùng giá trị cho 7 tham số động lượng dùng chung: `strict_htf`, `min_slp`, `tangle_sp`, `w45_tol`, `d_max`, `db_tol`, `db_prom`.
5. Lưu ảnh toàn chart (giá + pane RSI) cùng thông báo compiler và thông số đầu vào.

## C. Bộ test bắt buộc

### T01 — Compile & kiểu hiển thị
- **Setup:** Hai script gắn lên XAUUSD M5.
- **Đạt:** Cả hai biên dịch; tất cả đường và pane hiển thị; không có runtime error.
- **Bằng chứng:** Ảnh/log compile riêng từng script.

### T02 — Marker nằm đúng nến đã đóng
- **Setup:** Ghi timestamp của nến M5 vừa đóng khi marker phát.
- **Đạt:** Marker nằm tại nến xác nhận dự kiến, không lệch 1 hay 2 nến.
- **Bắt buộc kiểm tra:** Tác động kết hợp giá trị `[1]` với `offset=-1`.

### T03 — Bullish setup hoàn chỉnh
- **Setup:** H4/H1 tăng hợp lệ; M15 hồi về vùng 40–50 hoặc WMA45; giá có L→H→HL hợp lệ và touch/bounce hoặc swing breakout theo `trig_mode`; M5 có Regular/Hidden bullish divergence hoặc RSI Double Bottom hợp lệ, RSI cắt lên EMA9.
- **Đạt:** Script 1 có ▲ ở nến setup; Script 2 phản ánh xác nhận M5 theo vai trò đã khóa.

### T04 — Bearish setup hoàn chỉnh
- Đối xứng T03: H4/H1 giảm; M15 vùng 50–60 hoặc WMA45; H→L→LH; phân kỳ/mô hình đỉnh; RSI cắt xuống EMA9; kỳ vọng ▼.

### T05 — Sideway / ba đường chụm
- **Setup:** Spread RSI/EMA9/WMA45 trên H4 hoặc H1 dưới ngưỡng `tangle_sp`, hoặc WMA45 phẳng/độ dốc không đạt.
- **Đạt:** Không hiển thị trạng thái bối cảnh xu hướng đủ điều kiện và không có marker setup mới do thiên hướng này.

### T06 — Touch nhưng chưa Bounce
- **Setup:** Giá chạm Dragon nhưng đóng cửa chưa bật ra ngoài dải.
- **Đạt:** Touch một mình không phát ▲/▼.

### T07 — Bounce sau Touch
- **Setup:** Sau Touch có nến M5 đóng cửa bật ra ngoài Dragon theo hướng đúng, trong khi cấu trúc/MTF/M5 cũng hợp lệ.
- **Đạt:** Có thể phát marker theo đúng định nghĩa; marker đúng nến.

### T08 — Swing breakout và breakout giả
- **Setup:** Chế độ `trig_mode=1`, kiểm thử đóng cửa vượt H/L; thêm đối chứng giá đột biến đâm qua Dragon nhưng chưa có cấu trúc wave hoặc M15 không trong vùng chờ.
- **Đạt:** Breakout hợp lệ chỉ xuất hiện khi cấu trúc đầy đủ; cú xuyên đơn lẻ không tạo setup.

### T09 — Pullback thất bại / phá EMA89 hoặc gốc sóng
- **Setup:** Giá xuyên qua EMA89 hoặc HL phá đáy gốc L (đối xứng LH vượt đỉnh gốc H).
- **Đạt:** Setup vô hiệu, không phát marker.

### T10 — Phân kỳ và Double Bottom/Top
- **Setup:** Dữ liệu mô phỏng/đánh dấu trên chart cho 4 dạng RegBull, HidBull, RegBear, HidBear và DB/DT hợp lệ/không hợp lệ.
- **Đạt:** Đáy chỉ ghép với RSI low + price low; đỉnh chỉ ghép RSI high + price high; khoảng cách trong [3, d_max]; DB/DT không đạt `db_tol` hoặc `db_prom` thì không trigger.

### T11 — Không phát trùng cùng chu kỳ
- **Setup:** RSI cắt EMA9 nhiều lần trong cùng một nhịp pullback, không tạo pivot/wave mới thỏa điều kiện re-arm.
- **Đạt:** Không lặp marker trong cùng chu kỳ.

### T12 — Chu kỳ mới độc lập
- **Setup:** Một setup đã phát; hình thành swing mới đủ điều kiện sau đó. Bao gồm tình huống đỉnh mới thấp hơn, cao hơn hoặc bằng đỉnh đã khóa.
- **Đạt:** Hành vi phải khớp quy tắc reset khóa đã ghi trong đặc tả; nếu quy tắc chặn đỉnh thấp hơn gây bỏ lỡ một swing độc lập, phải được báo cáo như design trade-off, không tự đổi.

### T13 — Thiếu dữ liệu/warm-up
- **Setup:** Chart ngắn hoặc scroll về giai đoạn chưa đủ dữ liệu HTF/EMA200/RSI.
- **Đạt:** Không runtime error; guard trả NaN an toàn; ghi nhận khoảng thời gian đầu không đủ dữ liệu.

### T14 — Ranh giới HTF
- **Setup:** Theo dõi qua thời điểm đóng đồng thời hoặc riêng của M5/M15/H1/H4.
- **Đạt:** Điều kiện HTF dùng nến HTF đã đóng và không dựa vào giá trị đang chạy của nến HTF để đóng dấu lịch sử.
- **Bằng chứng:** Ghi thời gian nến M5, thời gian đóng nến HTF liên quan và ảnh/log.

### T15 — Reload/F5
- **Setup:** Ghi lại ít nhất 3–5 marker vừa xuất hiện; nhấn F5/reload.
- **Đạt:** Marker lịch sử vẫn ở đúng nến đã xác nhận; mọi khác biệt phải ghi lại và truy nguyên.
- **Cảnh báo:** Trước khi test này hoàn thành, trạng thái repaint luôn là `PENDING`.

### T16 — RSI pane markers độc lập với overlay
- **Setup:** Tìm trường hợp M5 momentum đã xác nhận nhưng setup giá chưa đủ điều kiện hoặc hình thành ở thanh khác.
- **Đạt:** Script 2 vẫn thể hiện đúng sự kiện momentum theo vai trò đã khóa; Script 1 chỉ xuất marker khi điều kiện setup giá tổng hợp đạt. Không bắt buộc hai marker cùng nến.

## D. Biểu mẫu kết quả từng test

Với mỗi test, agent/kiểm thử viên ghi:

- ID test / build hash hoặc ngày giờ phiên bản.
- Chart/instrument/timeframe và thông số hai script.
- Dữ liệu/điều kiện tiền đề, timestamp nến liên quan.
- Expected behavior.
- Actual behavior.
- PASS / FAIL / BLOCKED (không dùng PASS khi chưa thực sự thử).
- Ảnh/log đi kèm và issue liên quan.

## E. Cổng phát hành

Không gắn nhãn “hoàn tất” khi bất kỳ mục P0 nào còn mở. Phải báo riêng ít nhất 5 trạng thái: `CODE REVIEWED`, `STATIC API CHECKED`, `COMPILED ON EXNESS`, `VISUAL QA PASSED`, `REPAINT TEST PASSED`. Chỉ hai trạng thái đầu có thể được xác nhận trong kiểm tra tĩnh; ba trạng thái sau cần bằng chứng môi trường thật.

---

# LỆNH CÔNG VIỆC GỬI AGENT — ĐỌC TRƯỚC KHI SỬA CODE

Bạn là agent triển khai kỹ thuật cho bộ chỉ báo Sonic R. + RSI Trend Pulse XAUUSD trên Exness Terminal Web / TakeProfit Indie v5. Làm việc theo bộ hồ sơ này, đặc biệt `01_SPEC_LOCK.md`, `02_ISSUE_REGISTER.md` và `03_QA_ACCEPTANCE.md`.

## Mục tiêu bắt buộc

Giữ chính xác 2 script độc lập:

1. `SonicR_Setup_Overlay` — overlay giá, cấu trúc Sonic R., các mức tham chiếu và marker setup tổng hợp.
2. `RSI_Trend_Pulse_Pane` — RSI14/EMA9(RSI)/WMA45(RSI), mốc tham chiếu và marker xác nhận momentum M5.

Không bổ sung bất cứ logic giao dịch hoặc quản lý vị thế nào: không lệnh, SL/TP, TP1/TP2, exit, BUY/SELL, R:R hoặc chiến lược tự động. Mỗi script ≤128 dòng vật lý.

## Quy trình làm việc được yêu cầu

### Pha 1 — Audit trước, chưa rewrite

1. Đọc toàn bộ hồ sơ, đọc hai mã tham chiếu Stage 4.
2. Tạo ma trận truy vết requirement → code location → status.
3. Phân loại từng phát hiện là một trong: `CONFIRMED DEFECT`, `SPECIFICATION MISMATCH`, `DESIGN CHOICE`, `TEST REQUIRED`, `NOT A DEFECT`.
4. Với mỗi phát hiện, ghi đoạn mã/dòng, vì sao vi phạm yêu cầu, ví dụ đầu vào tái hiện, expected/actual và test sẽ chứng minh lỗi.
5. Không được tự gọi design choice là bug. Không được coi mô phỏng bằng tay là runtime test.
6. Chú ý ISS-01 đến ISS-12 trong sổ vấn đề, đặc biệt vai trò marker Script 2 và nguy cơ offset/dữ liệu `[1]`.

### Pha 2 — Patch plan tối thiểu

Trước khi sửa, cung cấp bảng:

`Issue ID | requirement bị vi phạm | bằng chứng | patch tối thiểu | test trước/sau | tác động dòng | rủi ro`.

Không thay đổi nhiều hạng mục logic trong cùng một patch nếu chúng có thể kiểm thử riêng. Không refactor vì sở thích, không đổi tên/kiến trúc, không cắt logic cốt lõi để đạt số dòng nếu chưa được duyệt. Bảo toàn hai script và tên hiện có.

### Pha 3 — Triển khai và kiểm toán patch

Khi patch plan được chấp nhận:

1. Sửa từng lỗi có bằng chứng hoặc xử lý đúng specification mismatch được phê duyệt.
2. Giữ thay đổi nhỏ nhất có thể và phát hành diff trước/sau.
3. Đếm số dòng vật lý trực tiếp từ đúng file bàn giao; ghi cả physical lines và non-empty lines, nhưng giới hạn 128 áp dụng cho physical lines.
4. Chạy kiểm tra syntax ở mức có thể trong môi trường agent; nói rõ đây không phải compile Indie trên Exness.
5. Đối chiếu API với tài liệu chính thức hiện hành; lưu URL/đoạn liên quan.
6. Thực thi các test mô phỏng được cung cấp, ghi input và output. Không tự tuyên bố rằng một bảng mô phỏng là test live.
7. Liệt kê test cần người dùng chạy trên Exness, không bịa ảnh/log/compile result.

### Pha 4 — Gói bàn giao mỗi iteration

Mỗi lần trả kết quả, gửi:

- Hai file `.indie` hoàn chỉnh, bản độc lập có thể copy/paste.
- Bản diff hoặc changelog theo issue ID.
- Ma trận requirement status.
- Số dòng chính xác từng file.
- Kết quả từng test có input/expected/actual.
- Bảng trạng thái 5 cấp: CODE REVIEWED / STATIC API CHECKED / COMPILED ON EXNESS / VISUAL QA PASSED / REPAINT TEST PASSED.
- Các vấn đề chưa đóng và vì sao.

## Kỷ luật kỹ thuật

- Không tự đổi mục tiêu, kiến trúc 2 script, hoặc vai trò marker.
- Không sửa mã chỉ vì “có vẻ sạch hơn”, “cách khác cũng được”, hay để mọi marker trùng nhau.
- Không xóa đường/mức tham chiếu chỉ để rút gọn dòng khi chưa đánh giá tác động.
- Không thay `plot.marker_style` bằng enum kiểu Pine Script nếu không có chứng cứ Indie hỗ trợ.
- Không tuyên bố non-repainting chỉ vì dùng `[1]`; cần kiểm thử ranh giới HTF và reload.
- Nếu spec và snapshot Stage 4 khác nhau, ưu tiên spec đã khóa và báo rõ mọi thay đổi hành vi.
- Nếu không chứng minh được lỗi, để nguyên và gắn `TEST REQUIRED` hoặc `DESIGN CHOICE`.

## Điều kiện kết thúc của agent

Không được ghi “hoàn tất” cho đến khi: hai script ≤128 dòng; mọi phát hiện P0 được xử lý hoặc có quyết định rõ; static API review hoàn tất; test evidence được phân tách đúng; compile/visual/repaint chỉ được đánh PASS khi có bằng chứng Exness tương ứng.

Bắt đầu bằng **audit + patch plan**, không bắt đầu bằng việc viết lại toàn bộ code từ đầu.

---

# SOURCE REGISTER — NGUỒN HỒ SƠ & ĐỐI CHIẾU API

## Hồ sơ lịch sử được lưu trong `source_archive/`

- `stage1_research_and_knowledge_lock.md`: nghiên cứu nền và khung kiến thức Sonic R./RSI 101, công thức, giới hạn 128 dòng.
- `stage2_specification_architecture.txt`: thiết kế kiến trúc, các cổng quyết định và các xung đột phạm vi giai đoạn đầu.
- `stage2_reset_scope_lock.txt`: tái khóa phạm vi thuần quan sát, cấu trúc 2 script và logic nhận diện setup.
- `stage2_qa_patch.txt`: chi tiết các patch và cảnh báo API/MFT.
- `stage3_code_audit_repair_order.txt`: audit mã, các phát hiện và trạng thái kiểm thử.
- `stage3_implementation_handoff.txt`: bản triển khai đã được bàn giao kèm hướng dẫn nghiệm thu.
- `stage3_targeted_qa_rework.txt`: tái kiểm toán/điều chỉnh có mục tiêu.
- `stage4_rsi_pivot_cycle_latch_validation.txt`: báo cáo Stage 4 về thứ tự RSI pivot, latch chu kỳ, mô phỏng 8 ca và mã tham chiếu.

## Snapshot mã tham chiếu hiện hành

Hai tệp trong `reference/` được trích từ phần mã nguồn trong báo cáo Stage 4 ngày 29-10-2026. Đây là snapshot để review; chúng chưa được xác nhận biên dịch trong Exness Terminal. Tệp trích xuất Script 1 có 116 dòng vật lý và Script 2 có 83 dòng vật lý (theo phép đếm trực tiếp trên tệp trong gói này). Báo cáo gốc ghi 113/81 dòng, một chênh lệch phải được ghi nhận, không được che giấu.

## Tài liệu chính thức đã đối chiếu trực tuyến ngày 29-10-2026

1. Exness Help Center — Custom indicators in Exness Terminal:  
   https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal
2. TakeProfit Indie — Package `indie.plot`, gồm chữ ký `@plot.line`, `@plot.marker`, `plot.Marker` và enum marker:  
   https://takeprofit.com/docs/indie/Library-reference/package-indie-plot
3. TakeProfit Indie — Request additional instruments, `@sec_context`, `Context.calc_on()` và quy định gọi `calc_on` từ `__init__`:  
   https://takeprofit.com/docs/indie/Request-additional-instruments
4. TakeProfit Indie — Library reference package `indie`, `@sec_context`/`calc_on` và mô tả merge/lookahead:  
   https://takeprofit.com/docs/indie/Library-reference/package-indie

## Những gì nguồn/API đã xác nhận được

- `@plot.line` có tham số `id` trước `title`.
- `@plot.marker` bắt đầu với `title`, không có `id` positional ở đầu như `@plot.line`.
- `size` của marker là số nguyên; enum marker style ghi trong docs gồm `NONE`, `CIRCLE`, `LABEL`, `CROSS`; vị trí gồm `ABOVE`, `BELOW`, `LEFT`, `RIGHT`, `CENTER`.
- `plot.Marker` có `value`, `color`, `text`, `offset`.
- `@sec_context` là secondary context; `calc_on` nối secondary context với Main và phải được gọi từ `__init__`.

Các điểm này chỉ xác nhận chữ ký/API theo tài liệu. Chúng **không** chứng minh mã biên dịch trên phiên bản Exness đang dùng, marker Unicode hiển thị đúng, logic cho kết quả đúng hoặc không repaint.

---

# PHỤ LỤC PHIÊN BẢN 1.1 — MỞ RỘNG SMC + TPO (CÓ HIỆU LỰC CHO PHẠM VI MỚI)

## Trạng thái quản lý

Bản 1.0 giữ nguyên như hồ sơ lịch sử của hai script lõi. Bản 1.1 không tuyên bố rằng mã hiện tại đã được thay đổi hay đã nghiệm thu. Nó đề xuất thêm hai module độc lập — SMC Market Structure và TPO Session Profile — trong khi giữ `SonicR_Setup_Overlay` và `RSI_Trend_Pulse_Pane` tách riêng.

Tệp SMC mới nhận là EX5 đã biên dịch. ZIP TPO chỉ gồm EX5 và hướng dẫn cấu hình, không có mã nguồn MQL5. Vì vậy chưa thể xác minh đủ logic bên trong hay port nguyên trạng sang Indie v5. Giả định target vẫn là Exness Terminal Web + Indie v5, và source/behavioral spec là cổng bắt buộc trước khi code.

Đọc các tài liệu v1.1 trong cùng thư mục:

- `06_SMC_TPO_INTEGRATION_SPEC.md` — kiến trúc bốn lớp, vai trò, quy tắc không trùng chức năng, bố cục và change control.
- `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` — kiểm tra chính xác hai file, hai hướng nền tảng và artefact còn thiếu.
- `08_AGENT_PROMPT_SMC_TPO_V1_1.md` — prompt dành cho agent ở vòng đầu.
- `09_SMC_TPO_QA_ACCEPTANCE.md` — test nghiệm thu bổ sung cho SMC/TPO.

## Kiến trúc bốn lớp

1. `SonicR_Setup_Overlay` — hình thái giá và marker setup tiềm năng.
2. `RSI_Trend_Pulse_Pane` — động lượng đa khung và marker xác nhận M5.
3. `SMC_MarketStructure_Overlay` — chỉ các tính năng SMC đã xác nhận từ source/tài liệu/behavioral observation.
4. `TPO_Session_Profile` — các output TPO thật sự có trong indicator gốc, với row size và session clock đã kiểm định.

Giai đoạn đầu chỉ là **composition of independent context layers**. Không tạo confluence score, không đưa SMC/TPO thành hard filter cho setup, không sửa logic lõi và không tự suy ra tính năng SMC/TPO từ tên file.

## Nền tảng — vấn đề đã xác minh

Exness mô tả custom indicators trong Exness Terminal Web sử dụng ngôn ngữ Indie. MetaTrader 5 mô tả EX5 là executable được biên dịch, trong đó thuật toán nguồn bị che giấu. Do đó EX5 không phải mã Indie có thể dán vào editor; muốn giữ target hiện tại phải có source MQL5 để port hoặc một đặc tả hành vi đủ chi tiết để tái triển khai. Nguồn:

- https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal
- https://takeprofit.com/docs/indie/Overview
- https://www.metatrader5.com/en/metaeditor/help/development/compile

Chi tiết đầu vào, lịch phiên TPO, timezone/row sizing, tiêu chí QA và danh mục file cần bổ sung nằm trong các phụ lục nêu trên.
