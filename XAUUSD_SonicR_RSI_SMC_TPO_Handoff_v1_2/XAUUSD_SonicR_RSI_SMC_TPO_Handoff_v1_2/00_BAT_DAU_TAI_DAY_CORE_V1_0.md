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
