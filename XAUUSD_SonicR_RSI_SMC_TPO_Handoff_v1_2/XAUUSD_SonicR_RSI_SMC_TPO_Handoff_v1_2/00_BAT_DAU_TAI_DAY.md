# BẮT ĐẦU TẠI ĐÂY — XAUUSD SUITE V1.2

## TRẠNG THÁI HIỆN TẠI: PHASE 0 — HỌC KIẾN THỨC, CHƯA ĐƯỢC VIẾT/SỬA CODE

**Lệnh ưu tiên cao nhất cho agent:** Đọc `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` trước tất cả các prompt cũ. Hoàn thành toàn bộ chương trình học, bài đánh giá và bộ nhớ dự án có thể truy xuất được. Không tạo, sửa, refactor, tối ưu hoặc thử nghiệm code chỉ báo cho tới khi người quản lý duyệt học tập và duyệt riêng kế hoạch thực hiện.

## Thứ tự bắt buộc

1. `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md`.
2. Toàn bộ `KNOWLEDGE_BASE/01_...` đến `KNOWLEDGE_BASE/15_...` theo số thứ tự.
3. `01_SPEC_LOCK.md`, `06_SMC_TPO_INTEGRATION_SPEC.md`, `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md`, `02_ISSUE_REGISTER.md`, `03_QA_ACCEPTANCE.md`, `09_SMC_TPO_QA_ACCEPTANCE.md`.
4. Hai snapshot trong `reference/` và toàn bộ báo cáo lịch sử trong `source_archive/`.
5. Tệp gốc trong `user_inputs/`, gồm `TPO_HUONG_DAN.txt`, và kiểm tra checksum.
6. Điền sáu hồ sơ trong `learning_records/` và trả lời đánh giá kiến thức.

## Bộ nhớ bắt buộc

Thông tin hội thoại không được coi là nơi lưu kiến thức duy nhất. Agent phải ghi thông tin đã học, nguồn, các giới hạn và câu hỏi còn mở vào `learning_records/PROJECT_MEMORY.md`, `CLAIM_LEDGER.md`, `KNOWLEDGE_GAPS.md`, `ASSESSMENT_ANSWERS.md`, `LEARNING_REPORT.md` và `SESSION_START_CHECKLIST.md`. Các tệp này phải được đọc lại khi mở phiên mới. Hồ sơ hiện tại **không tuyên bố agent đã học xong**; trạng thái mặc định là `PENDING`.

## Các điểm không được quên

- Mục tiêu là bộ công cụ quan sát XAUUSD bằng bốn lớp độc lập: Sonic R., RSI Trend Pulse, SMC và TPO.
- Hai script lõi Sonic R./RSI giữ nguyên nhiệm vụ; mỗi script tối đa 128 dòng vật lý.
- Không có đặt lệnh, quản lý vị thế, SL/TP, TP1/TP2, exit, R:R, BUY/SELL hoặc tự động giao dịch.
- Marker setup giá và marker momentum RSI là hai sự kiện độc lập.
- Không suy ra thuật toán SMC/TPO từ file EX5. Tệp EX5 là binary đã biên dịch, không phải source Indie.
- Tài liệu TakeProfit liệt kê `BlockProfile`, nhưng hỗ trợ thực tế trong Exness chưa xác nhận; lớp này không tự tính TPO.
- Không chỉnh sửa code trước khi vượt qua learning gate và được duyệt kế hoạch riêng.

## Sau khi gate được duyệt

Chỉ khi người quản lý xác nhận `LEARNING GATE: APPROVED` mới được chuyển sang audit. Audit cũng phải hoàn tất trước khi lập patch/port plan; patch/port plan phải được duyệt trước khi code. Xem `04_AGENT_WORK_ORDER.md` và `PROMPT_GIAO_AGENT.md`.
