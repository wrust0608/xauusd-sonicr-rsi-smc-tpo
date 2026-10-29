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
