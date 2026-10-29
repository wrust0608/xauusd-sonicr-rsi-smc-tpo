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

## Bổ sung v1.1 — SMC/TPO

Tệp người dùng cung cấp ngày 29-10-2026:
- `user_inputs/SC_MarketStructure.ex5`: binary EX5; không có source MQL5 đi kèm. Không xác minh thuật toán hoặc feature inventory từ file đơn lẻ.
- `user_inputs/TPO_Session_v1.01.zip`: archive chứa `TPO Session.ex5` và `HUONG_DAN.txt`, không có `.mq5/.mqh`. Bản `user_inputs/TPO_HUONG_DAN.txt` được trích từ archive để đối chiếu nhanh.

Các tài liệu bổ sung xác minh định dạng/nền tảng:
- Exness Help Center, Custom indicators in Exness Terminal: https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal — custom scripts trong Exness Terminal Web dùng Indie.
- TakeProfit Indie Overview: https://takeprofit.com/docs/indie/Overview — Indie là ngôn ngữ script chỉ báo của TakeProfit.
- MetaTrader 5 MetaEditor Help, Compilation: https://www.metatrader5.com/en/metaeditor/help/development/compile — EX5 là executable đã biên dịch; thuật toán nguồn được che giấu và debugging không khả dụng nếu thiếu source.

Phạm vi xác minh TPO từ tài liệu đính kèm chỉ gồm: loại indicator TPO Session v1.01 cho MT5; tham số tick/row height; chế độ đồng hồ server; các lịch S1/S2/S3 trong hướng dẫn. Không có đủ bằng chứng trong tài liệu để xác nhận danh sách output như POC/VAH/VAL, công thức phân vùng value area hoặc các thống kê profile khác.
