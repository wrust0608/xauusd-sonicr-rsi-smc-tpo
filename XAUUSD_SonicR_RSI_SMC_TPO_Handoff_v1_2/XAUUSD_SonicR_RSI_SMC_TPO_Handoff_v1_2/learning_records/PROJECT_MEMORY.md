# PROJECT MEMORY — CANONICAL STATE & SOURCE OF TRUTH

**Project Name:** XAUUSD visual-analysis indicator suite — Sonic R. + RSI Trend Pulse + SMC + TPO  
**Knowledge Base Version:** 1.2.5  
**Current Gate Status:** `PENDING` (Independent Manager Review Required; agent self-score is not manager approval)  
**Implementation / Code Permission:** `NOT GRANTED` (Strict Phase 0 discipline)  
**Target Environment Assumption:** Exness Terminal Web / TakeProfit Indie v5  
**Review Date:** 2026-10-29  

---

## 1. Mục tiêu và Bản chất Dự án
- Xây dựng bộ công cụ hỗ trợ người dùng **quan sát trực quan cấu trúc thị trường XAUUSD** gồm 4 lớp độc lập:
  1. `SonicR_Setup_Overlay`: Kênh hành động giá Dragon EMA 34, Trend Line EMA 89, EMA 200 tham khảo, mức swing tham chiếu, mức giá tròn động và tam giác setup tiềm năng.
  2. `RSI_Trend_Pulse_Pane`: RSI 14 (Wilder), EMA 9(RSI), WMA 45(RSI), bối cảnh xu hướng H4/H1, vùng chờ M15 và marker xác nhận động lượng M5.
  3. `SMC_MarketStructure_Overlay`: Tái hiện cấu trúc thị trường thực sự có trong công cụ gốc sau khi có mã nguồn hoặc đặc tả hành vi.
  4. `TPO_Session_Profile`: Phân bố giá theo lát cắt thời gian phiên (Time Price Opportunity) theo đúng quy tắc của công cụ gốc.
- **Ranh giới bất biến:** Sản phẩm thuần quan sát trực quan; TUYỆT ĐỐI KHÔNG có lệnh BUY/SELL, đặt/sửa/hủy lệnh, SL/TP, TP1/TP2, quản lý vị thế hay giao dịch tự động. Không có cam kết tỷ lệ thắng hay sinh lời.

---

## 2. Kiến trúc và Ràng buộc Kỹ thuật Đã Khóa (`PROJECT_LOCK`)
- **Giới hạn số dòng:** Mỗi script trong 2 script lõi (`SonicR_Setup_Overlay` và `RSI_Trend_Pulse_Pane`) phải $\le 128$ dòng vật lý (tính cả dòng trống và header `# indie:lang_version = 5`). Không áp dụng tự động cho module SMC/TPO mới; không được nén hay nhét SMC/TPO vào script lõi.
- **Tính độc lập của Marker:** Marker trên biểu đồ giá (setup tổng hợp) và marker trong pane RSI (xác nhận momentum M5) là 2 sự kiện độc lập, không bắt buộc cùng xuất hiện trên một nến.
- **Quy tắc nến đóng & MTF:** Trigger M5 bắt buộc dùng nến M5 đã đóng. Bối cảnh HTF (H4/H1) bắt buộc dùng nến HTF đã đóng, gọi `calc_on` bên trong `__init__` qua `@sec_context`.
- **Nhân quả thời gian & Repaint:** Phân biệt rõ `Anchor time` (thời điểm xảy ra đỉnh/đáy trong quá khứ) và `Confirmation time` (thời điểm đủ số nến bên phải để xác nhận). Việc vẽ lại quá khứ sau xác nhận (`PIVOT_BACKFILL`) là hành vi trực quan hợp lệ nhưng không được coi là tín hiệu có sẵn tại thời điểm anchor.

---

## 3. Hiện trạng Hiện vật và Mã nguồn (Artifact & Source Status)
- `reference/SonicR_Setup_Overlay_stage4_reference.indie`: Snapshot Stage 4, 116 dòng vật lý, trạng thái compile/visual trên Exness là `PENDING`.
- `reference/RSI_Trend_Pulse_Pane_stage4_reference.indie`: Snapshot Stage 4, 83 dòng vật lý, trạng thái compile/visual trên Exness là `PENDING`. Có vấn đề không khớp đặc tả (ISS-01: gộp điều kiện H4/H1/M15 vào marker M5).
- `user_inputs/SC_MarketStructure.ex5`: File nhị phân MT5, che giấu mã nguồn. Tính năng SMC thực tế là `UNKNOWN`.
- `user_inputs/TPO_Session_v1.01.zip`: File nhị phân MT5 kèm hướng dẫn `TPO_HUONG_DAN.txt`. Xác nhận `row_height = 0.1 * 12 = 1.2` và lịch phiên S1/S2/S3; các đầu ra POC, VAH/VAL, IB hiện là `UNKNOWN`.
- **TPO APIs trong Indie v5 & Ranh giới Exness (`RUNTIME_REQUIRED`):**
  - Đối tượng đồ họa `indie.drawings.BlockProfile`: cung cấp các phương thức vẽ `add_column`, `add_cell`, `add_level` nhưng không tự động tính toán dữ liệu TPO.
  - Nguồn dữ liệu native `sources.Tpo()` và đối tượng `TpoProfile` (`indie.data`): cung cấp `point_of_control` (giá POC, không có `point_of_control_index`, quy trình quét chính thức khởi tạo `poc_index = 0` và cập nhật khi TPO strictly lớn hơn; không dùng suy đoán đối chiếu giá), `initial_balance_high`, `initial_balance_low`, `row_size` và metadata hàng giá. Tuy nhiên, `TpoProfile` **không** có sẵn VAH/VAL; thuật toán chính thức phải mở rộng đúng 1 hàng mỗi bước (chọn hàng duy nhất nếu chỉ có 1 biên; so sánh chọn hàng có TPO cao hơn nếu có 2 biên; tie-break theo khoảng cách POC rồi ưu tiên hàng trên; VAH upper edge = `rows[high_index].price + row_size`) đến khi đạt $\ge 70\%$. Nguồn này mặc định gộp các phiên thành một profile cho mỗi timeframe được yêu cầu (ví dụ 1D tạo profile ngày, xung đột với lịch 3 phiên S1/S2/S3 của người dùng).
  - Cả hai cơ chế đều chưa được xác thực có hoạt động trên runtime Exness Terminal Web hay không (`RUNTIME_REQUIRED`).

---

## 4. Các Source Blockers & Knowledge Gaps còn mở (P0)
1. **GAP-01:** Thiếu mã nguồn `SC_MarketStructure.mq5/.mqh` hoặc đặc tả hành vi chi tiết.
2. **GAP-02:** Thiếu mã nguồn `TPO Session.mq5/.mqh`, preset hoặc ảnh chụp các đầu ra thực tế.
3. **GAP-03:** Cần kiểm chứng khả năng hỗ trợ `BlockProfile` và native TPO API (`sources.Tpo()`) cùng phiên bản Indie trên runtime Exness qua smoke test tối thiểu độc lập sau khi được phê duyệt; giải quyết xung đột cấu hình phiên S1/S2/S3.
4. **GAP-04:** Thiếu bảng kiểm kê tính năng chi tiết của SMC (độ dài pivot, close vs wick break, lifecycle zone).
5. **GAP-05:** Cần xác nhận điểm neo gốc lưới (`grid origin`) và quy tắc gán nến ranh giới phiên của TPO.

---

## 5. Quy trình Phiên làm việc (Session Discipline)
- Mọi phiên làm việc bắt buộc phải bắt đầu bằng việc đọc `learning_records/SESSION_START_CHECKLIST.md`.
- Trạng thái cổng học tập: **`PENDING`** — Chờ người quản lý trực tiếp xem xét và phê duyệt.
- Tuyệt đối KHÔNG can thiệp mã nguồn khi chưa có văn bản phê duyệt chuyển sang Phase Audit và Implementation Plan từ người quản lý.
