> **V1.2 PRECEDENCE NOTICE — MANDATORY BEFORE ANY WORK**  
> `PROMPT_GIAO_AGENT.md`, `00_BAT_DAU_TAI_DAY.md`, and `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` supersede this historical work instruction until the learning gate is manager-approved. Phase 0 requires reading the entire knowledge base and creating the required persistent learning records. No code, prototype, audit patch or indicator modification is permitted in Phase 0. After approval, use this file only where it does not conflict with the v1.2 learning gate and locked specs.

---

# LỆNH CÔNG VIỆC GỬI AGENT — ĐỌC TRƯỚC KHI SỬA CODE

**Ranh giới phiên bản:** Tài liệu này quản lý hai script lõi v1.0. Khi xử lý phần mở rộng SMC/TPO, dùng `06_SMC_TPO_INTEGRATION_SPEC.md`, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` và `08_AGENT_PROMPT_SMC_TPO_V1_1.md`; không diễn giải câu “2 script” trong hồ sơ lõi thành cấm thêm module độc lập ở v1.1. Hai script lõi vẫn giữ nguyên vai trò và giới hạn dòng.

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
