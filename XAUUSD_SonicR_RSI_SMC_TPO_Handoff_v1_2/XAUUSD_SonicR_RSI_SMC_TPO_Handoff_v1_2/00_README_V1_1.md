# BẮT ĐẦU TẠI ĐÂY — HỒ SƠ XAUUSD V1.1

Bộ hồ sơ này mở rộng hệ thống Sonic R. + RSI Trend Pulse thành bốn lớp phân tích độc lập: Sonic R. setup, RSI Trend Pulse, SMC Market Structure và TPO Session Profile.

## Đọc theo thứ tự

1. `01_SPEC_LOCK.md` — đặc tả lõi v1.0 vẫn khóa.
2. `06_SMC_TPO_INTEGRATION_SPEC.md` — kiến trúc mở rộng và vai trò SMC/TPO.
3. `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` — giới hạn quan trọng về hai file EX5.
4. `02_ISSUE_REGISTER.md` + `03_QA_ACCEPTANCE.md` — vấn đề tồn tại và tiêu chí QA của hai script lõi.
5. `04_AGENT_WORK_ORDER.md` và `08_AGENT_PROMPT_SMC_TPO_V1_1.md` — chỉ thị agent.
6. `reference/` và `source_archive/` — mã tham chiếu và lịch sử gốc.
7. `user_inputs/` — bản sao tệp người dùng cung cấp để lưu dấu vết.

## Trạng thái hiện tại

- Hai script lõi chưa bị thay đổi bởi yêu cầu SMC/TPO.
- Tệp `SC_MarketStructure.ex5` là bản đã biên dịch, chưa có source MQL5.
- ZIP TPO có `TPO Session.ex5` và `HUONG_DAN.txt`, không có source MQL5.
- Giả định target vẫn là Exness Terminal Web + Indie v5. Hai EX5 không chạy trực tiếp như mã Indie; phải có source để port hoặc một đặc tả hành vi đủ chi tiết để tái triển khai.
- Vòng đầu với agent chỉ làm audit và kế hoạch, không viết lại code.

## Nguyên tắc quản trị

Không sửa bất cứ logic nào chỉ vì có cách code khác. Mọi thay đổi cần chứng cứ, tái hiện, expected/actual, test hồi quy, và được người quản lý duyệt trước khi agent triển khai.
