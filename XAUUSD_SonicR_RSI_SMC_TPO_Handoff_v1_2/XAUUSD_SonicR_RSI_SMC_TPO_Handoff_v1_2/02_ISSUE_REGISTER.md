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
