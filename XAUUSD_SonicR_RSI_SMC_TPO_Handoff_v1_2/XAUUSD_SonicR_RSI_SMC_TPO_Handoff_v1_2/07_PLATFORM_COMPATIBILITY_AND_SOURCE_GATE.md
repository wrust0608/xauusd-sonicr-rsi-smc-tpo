# CỔNG TƯƠNG THÍCH NỀN TẢNG VÀ MÃ NGUỒN

## 1. Kết quả kiểm tra hai tệp mới gửi

### `SC_MarketStructure.ex5`

- Tệp là dạng dữ liệu nhị phân EX5, khoảng 138 KB trong môi trường được kiểm tra.
- Không có `.mq5`, `.mqh`, hướng dẫn cài đặt, preset `.set` hoặc ảnh chart đi kèm trong lần giao tệp này.
- Từ file này chưa thể xác minh thuật toán, tham số, định nghĩa cấu trúc, đầu ra, repaint hay điều kiện xoá vùng.
- Tên `SC_MarketStructure` không đủ chứng minh những tính năng SMC cụ thể nào đang được cài đặt.

### `TPO_Session_v1.01.zip`

- Gồm `TPO Session.ex5` và `HUONG_DAN.txt`; không có `.mq5` hoặc `.mqh`.
- Có thể trích xuất yêu cầu cấu hình row height và giờ phiên từ tài liệu kèm theo; xem `06_SMC_TPO_INTEGRATION_SPEC.md`.
- Tài liệu không mô tả hết đầu ra và thuật toán xây dựng profile; cần xem indicator chạy thật hoặc source để tạo bản port có độ tương đương.

Tài liệu chính thức MetaTrader 5 giải thích rằng EX5 là dạng executable đã biên dịch che giấu thuật toán nguồn, và không thể debug khi không có source. Vì vậy không được tuyên bố có thể chuyển chính xác logic từ hai file EX5 sang Indie chỉ bằng cách đọc file nhị phân.

## 2. Cổng tương thích

**Giả định làm việc hiện tại:** tiếp tục mục tiêu ban đầu — Exness Terminal Web, chỉ báo tự viết bằng TakeProfit Indie v5.

Tệp `.ex5` là indicator đã biên dịch cho MetaTrader 5; nó không phải mã Indie. Việc một tài khoản Exness có kết nối MT5 không làm cho mã EX5 trở thành script Indie. Exness mô tả custom indicators trong Exness Terminal Web được viết bằng Indie. Do đó có hai hướng, phải chọn rõ trước khi triển khai:

### Hướng A — Giữ Exness Terminal Web + Indie v5 (hướng mặc định)

1. Xin mã nguồn `.mq5` và toàn bộ `.mqh` phụ thuộc của SMC.
2. Xin mã nguồn `.mq5` và toàn bộ `.mqh` phụ thuộc của TPO, preset `.set` nếu có, và hướng dẫn/ảnh tất cả đầu ra.
3. Audit source, xây dựng inventory feature/parameter/formula/plot/reset/repaint.
4. Port sang Indie v5; nếu không còn source, chỉ được **tái triển khai theo đặc tả hành vi** đã đối chiếu, không gọi đó là bản chuyển mã nguyên bản.
5. So sánh chart theo cùng symbol, timeframe, lịch sử và input giữa MT5 gốc và Indie port; đánh dấu các sai khác không thể loại bỏ.

### Hướng B — Chuyển mục tiêu sang MT5 desktop

- Có thể dùng các EX5 như indicator độc lập trên MetaTrader 5 nếu tương thích với terminal/build và được cài đúng.
- Tuy nhiên, hai script Sonic R./RSI đang ở ngôn ngữ Indie không tự chạy thành indicator MT5. Muốn tất cả nằm trong cùng một môi trường MT5 phải có kế hoạch port riêng hai script lõi sang MQL5 hoặc dùng hai môi trường song song.
- Hướng này thay đổi target platform của dự án và không được agent tự quyết định.

## 3. Những gì agent phải xin/ghi nhận trước khi viết code

### SMC

- `SC_MarketStructure.mq5` và mọi `.mqh` liên quan.
- File `.set` hoặc ảnh đầy đủ phần Inputs.
- 3–5 ảnh chart đại diện các trường hợp: trend rõ, đảo chiều/CHoCH, breakout, sideway, dữ liệu thiếu/reload — tùy các tính năng thật có trong bản gốc.
- Danh mục từng plot/label/zone và định nghĩa xác nhận.
- Hành vi khi giá xuyên qua zone/level; có xóa, đổi màu hay kéo dài không.

### TPO

- `TPO Session.mq5` và mọi `.mqh` liên quan.
- File `.set`, ảnh tab Inputs và ảnh chart có nhãn các output đang hiển thị.
- Xác nhận cách indicator tính POC/value area nếu có, số TPO/row, cách xử lý bar giao nhau ranh giới phiên, DST, chart history/reload và ngày giao dịch qua đêm.
- Xác nhận `InpServerClock`, `InpTimeShiftHours`, `InpTickSize`, `InpTicksPerRow`, `InpRowHeight` và lịch phiên có còn là mặc định người dùng muốn giữ hay không.

Nếu không thể chia sẻ source, agent phải dừng trước bước port và cung cấp bảng thông tin còn thiếu. Có thể thay bằng behavioral specification chi tiết, ảnh và các ca input/output được ghi lại, nhưng phải hạ trạng thái tương đương xuống `REIMPLEMENTATION — behaviorally tested`, không ghi `SOURCE PORT`.

## 4. Không được làm

- Không disassemble/decompile EX5 rồi giả định đã khôi phục đúng thuật toán.
- Không suy ra danh sách tính năng từ tên file.
- Không bỏ qua giờ server/DST và tuyên bố TPO chính xác theo phiên chỉ vì mã chạy không lỗi.
- Không gộp logic SMC/TPO vào hai script lõi ngay trong vòng đầu.
- Không bật các lớp SMC/TPO thành hard filter của setup trước khi định nghĩa và kiểm thử.
- Không báo compile/visual/non-repaint PASS nếu chưa có bằng chứng từ nền tảng đích.

## 5. Nguồn tham chiếu nền tảng đã kiểm tra ngày 29-10-2026

- Exness Help Center, *Custom indicators in Exness Terminal*: https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal
- TakeProfit Indie Overview: https://takeprofit.com/docs/indie/Overview
- MetaTrader 5 MetaEditor Help, *Compilation*: https://www.metatrader5.com/en/metaeditor/help/development/compile

Các nguồn trên xác nhận sự khác nhau giữa custom indicator bằng Indie và executable EX5 đã biên dịch. Chúng không xác nhận thuật toán nội bộ của hai file người dùng gửi.
