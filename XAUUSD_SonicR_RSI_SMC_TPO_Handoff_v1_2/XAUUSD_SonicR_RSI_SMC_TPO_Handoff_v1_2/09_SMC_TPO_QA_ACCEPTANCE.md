# QA NGHIỆM THU BỔ SUNG — SMC + TPO

Không chạy test thuật toán SMC/TPO trước khi feature inventory có định nghĩa cụ thể từ source hoặc quan sát được lặp lại. Mọi test phải gắn với feature thực tế được xác nhận, không mặc định rằng mọi khái niệm SMC/TPO phổ biến đều tồn tại trong indicator gốc.

## A. Nghiệm thu đầu vào và tương thích

| ID | Kiểm tra | Điều kiện PASS |
|---|---|---|
| ST-01 | Source inventory | Có source `.mq5/.mqh` hoặc behavioral specification được ghi rõ; không suy diễn từ EX5 |
| ST-02 | Target platform | Target đã được người quản lý xác nhận; Indie code và MQL5 binary không bị coi là tương thích trực tiếp |
| ST-03 | Feature inventory SMC | Mỗi tính năng/plot có định nghĩa, tham số, lifecycle, evidence và trạng thái repaint |
| ST-04 | Feature inventory TPO | Outputs, row sizing, session boundaries, timezone/DST và rollover đã được xác minh |

## B. SMC — chỉ thực hiện với tính năng thực sự có trong bản gốc

| ID | Kiểm tra | Điều kiện PASS |
|---|---|---|
| SM-01 | Đối chiếu chart | Cùng symbol, timeframe, history và inputs thì các mức/nhãn quan trọng của port khớp bản gốc theo tolerance đã định |
| SM-02 | Xác nhận swing/pivot | Không dịch pivot đã xác nhận sau reload; độ trễ xác nhận được ghi rõ |
| SM-03 | Lifecycle của zone/level | Tạo mới, kéo dài, vô hiệu hóa/xóa hoặc đổi màu đúng định nghĩa bản gốc |
| SM-04 | Tình huống đối nghịch | Trend, sideway, false breakout, đảo chiều và thiếu dữ liệu không tạo trạng thái ngoài định nghĩa |
| SM-05 | Repaint/reload | Đối chiếu nến đang chạy so với nến đóng; reload không tự ý dịch lịch sử đã xác nhận nếu bản gốc không có hành vi đó |
| SM-06 | Tầng hiển thị | SMC có thể bật/tắt độc lập; không che nến và không làm thay đổi logic/marker của hai script lõi |

Nếu tính năng gốc là BOS/CHoCH, OB, FVG, equal highs/lows hay liquidity sweep, phải có test riêng cho chính định nghĩa của feature đó. Không thêm test/feature chỉ dựa trên kỳ vọng phổ biến của SMC.

## C. TPO — phiên, thời gian, row và profile

| ID | Kiểm tra | Điều kiện PASS |
|---|---|---|
| TP-01 | Row size XAUUSD | `InpTickSize=0.1`, `InpTicksPerRow=12` tạo row 1.2 giá như hướng dẫn; các bucket rơi đúng biên |
| TP-02 | Symbol tick/row override | Chế độ tick size theo symbol và row height trực tiếp hoạt động đúng như định nghĩa đã xác nhận |
| TP-03 | Ranh giới S1/S2/S3 | Bar ở trước, đúng tại và sau ranh giới được gán đúng phiên theo lịch đã duyệt |
| TP-04 | Phiên qua nửa đêm | S3 được nhóm đúng qua ngày mới; không mất hoặc gán kép bar |
| TP-05 | Server clock | Auto/fixed/server shift tạo ranh giới phiên đúng trên server/tài khoản đích |
| TP-06 | DST | Các tuần chuyển giờ Mỹ/Châu Âu và quy tắc user muốn giữ không làm dịch phiên ngoài mong đợi |
| TP-07 | Lịch sử và reload | Profile trên dữ liệu lịch sử giống với profile sau reload và tính tiếp realtime, theo kỳ vọng đã chốt |
| TP-08 | Output parity | Từng output đã xác nhận trong inventory khớp bản gốc MT5 theo tolerance rõ ràng |
| TP-09 | Dữ liệu thiếu/market closure | Không crash, không gán dữ liệu giả, xử lý cuối tuần/đứt đoạn theo định nghĩa |
| TP-10 | Visual clutter | Các lớp TPO/SMC/Dragon/Swing vẫn đọc được; có thể tắt riêng từng module nếu nền tảng hỗ trợ |

## D. Hồi quy toàn hệ thống

| ID | Kiểm tra | Điều kiện PASS |
|---|---|---|
| RG-01 | Core isolation | Khi chỉ bật/tắt SMC hoặc TPO, outputs và marker của `SonicR_Setup_Overlay` và `RSI_Trend_Pulse_Pane` không đổi |
| RG-02 | No hard filter | Nếu chưa được duyệt, SMC/TPO không tự chặn hoặc tạo marker Sonic R. |
| RG-03 | No trading actions | Không có order, position management, SL/TP, exit hoặc BUY/SELL labels |
| RG-04 | Platform-native test | Chỉ PASS compile/runtime khi đã chạy trên đúng target platform; không dùng kiểm tra Python syntax thay thế |
| RG-05 | Artifact exactness | Đúng bản script bàn giao được đếm dòng vật lý và test; không dùng bản rút gọn khác |

## Phân cấp bằng chứng

- `SOURCE REVIEWED`: đọc được source, xác định chính xác logic.
- `BEHAVIOR OBSERVED`: hành vi đã tái hiện bằng chart/input cụ thể nhưng source không có.
- `STATIC CHECK`: cấu trúc, tên/giá trị, hoặc API đã kiểm tra tĩnh.
- `RUNTIME PASS`: chạy trên nền tảng đích và có log/ảnh/input đủ tái hiện.
- `NOT VERIFIED`: chưa có dữ liệu để kết luận.

Không được nâng trạng thái từ `NOT VERIFIED` lên `PASS` chỉ nhờ mô phỏng tự tính hoặc vì file EX5 tải được.
