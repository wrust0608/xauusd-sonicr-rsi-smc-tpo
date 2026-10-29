# ĐẶC TẢ BỔ SUNG V1.1 — TÍCH HỢP SMC + TPO VÀO BỨC TRANH THỊ TRƯỜNG

**Trạng thái:** Đề xuất kiến trúc được chấp thuận làm cơ sở audit; chưa phải giấy phép viết lại mã.  
**Ngày lập:** 29-10-2026.  
**Phạm vi:** Mở rộng hồ sơ Sonic R. + RSI Trend Pulse thành một hệ thống quan sát thị trường nhiều lớp, không thay thế hoặc âm thầm sửa đặc tả lõi v1.0.

## 1. Mục tiêu hệ thống sau mở rộng

Bộ chỉ báo phải giúp người dùng đọc bốn chiều thông tin, không gộp chúng thành một tín hiệu mua/bán duy nhất:

1. **Cấu trúc và trạng thái giá:** SMC cho biết cấu trúc thị trường và các sự kiện/mức cấu trúc mà phiên bản gốc thực sự hỗ trợ.
2. **Phân bố hoạt động theo phiên:** TPO/Market Profile cho biết cách hoạt động giá được phân bố theo thời gian và mức giá trong từng phiên, theo đúng các phép tính mà indicator TPO gốc đang thực hiện.
3. **Thiên hướng và động lượng đa khung:** RSI Trend Pulse cung cấp bối cảnh H4/H1, vùng chờ M15 và xác nhận M5.
4. **Hình thái setup giá:** Sonic R. xác định cấu trúc L→H→HL/H→L→LH và điều kiện trigger theo đặc tả lõi hiện hành.

Mục tiêu không phải tăng số marker. Mục tiêu là làm rõ bối cảnh: *giá đang ở đâu trong cấu trúc, phiên đã chấp nhận/phân bố giá thế nào, động lượng đa khung ra sao, và setup giá có xuất hiện không*.

## 2. Kiến trúc đề xuất — bốn module độc lập

| Module | Vai trò duy nhất | Vị trí | Trạng thái |
|---|---|---|---|
| `SonicR_Setup_Overlay` | Dragon EMA34, EMA89, EMA200 tham khảo, swing levels, round levels, tam giác setup tiềm năng | Overlay giá | Lõi v1.0; giữ nguyên cho đến khi audit chứng minh lỗi |
| `RSI_Trend_Pulse_Pane` | RSI14, EMA9(RSI), WMA45(RSI), bối cảnh H4/H1/M15 và marker momentum M5 | Pane RSI | Lõi v1.0; giữ nguyên cho đến khi audit chứng minh lỗi |
| `SMC_MarketStructure_Overlay` | Tái hiện các tính năng SMC thực sự có trong `SC_MarketStructure` sau khi audit được mã nguồn hoặc đặc tả hành vi | Overlay giá | Chưa thể xác nhận tính năng từ EX5 đơn lẻ |
| `TPO_Session_Profile` | Tái hiện TPO/Market Profile theo phiên, row size và quy tắc thời gian của bản gốc | Overlay/profile trên biểu đồ giá, tùy khả năng nền tảng | Chỉ có EX5 + hướng dẫn cấu hình; chưa có mã nguồn |

**Quy tắc giữ cấu trúc:** Hai script lõi v1.0 vẫn là hai script riêng, giới hạn 128 dòng vật lý áp dụng cho từng script lõi như đã khóa. Không nhét SMC/TPO vào hai script lõi để “tiết kiệm module”. Hai module mở rộng là indicator độc lập. Giới hạn 128 dòng cho hai module mới chưa được quy định; không được tự ý nén logic để đạt giới hạn này nếu chưa có quyết định riêng.

**Lưu ý về tích hợp:** “Bốn module” hiện có nghĩa là bốn lớp hiển thị độc lập trên cùng workspace/chart nếu nền tảng đích hỗ trợ. Chưa giả định rằng một script có thể đọc trực tiếp giá trị nội bộ của indicator khác. Không làm cho marker setup Sonic R. phụ thuộc SMC/TPO theo kiểu hard filter nếu chưa có thiết kế được duyệt và kiểm chứng API/runtime.

## 3. Phân công vai trò — không trùng lặp chức năng

### 3.1 SMC — cấu trúc thị trường, không phải tín hiệu vào lệnh

Tên file `SC_MarketStructure.ex5` chỉ cho biết tên file và định dạng; không đủ bằng chứng để khẳng định bản gốc có BOS, CHoCH, order block, FVG, equal highs/lows, liquidity sweep, premium/discount hoặc bất kỳ tính năng cụ thể nào. Agent phải kiểm kê đúng tính năng bản gốc từ `.mq5/.mqh`, tài liệu hoặc quan sát có thể tái hiện.

Bảng audit SMC bắt buộc phải ghi từng tính năng:

| Trường cần ghi | Yêu cầu |
|---|---|
| Tên chính xác trên indicator gốc | Giữ thuật ngữ của mã/hướng dẫn gốc; không đổi tên tuỳ ý |
| Định nghĩa | Điều kiện xác nhận, lookback, giá sử dụng, swing/pivot và độ trễ |
| Hình thức hiển thị | Đường, vùng, ký hiệu, nhãn, màu sắc, độ dài kéo dài |
| Điều kiện vô hiệu/xóa | Khi nào vùng/mức bị xóa, bị phá hoặc không còn hợp lệ |
| Nến đang chạy hay nến đóng | Ghi rõ hành vi repaint/độ trễ và điều kiện xác nhận |
| Tham số | Tên, mặc định, giới hạn và tác động |
| Tình trạng bằng chứng | Source-reviewed / observed / inferred / unknown |

Các nhóm như HH/HL/LH/LL, BOS/CHoCH, vùng cung-cầu/order block, FVG, equal highs/lows và liquidity sweep chỉ là **danh mục để kiểm tra**, không phải yêu cầu rằng tất cả phải có trong bản gốc. Chỉ module nào được xác nhận từ source hoặc tài liệu mới được đưa vào đặc tả triển khai.

### 3.2 TPO — phân bố theo phiên, không phải trigger độc lập

Hướng dẫn đi kèm `TPO_Session_v1.01.zip` xác nhận indicator có tên **TPO Session v1.01 — Market Profile / TPO theo phiên cho MetaTrader 5**. Hướng dẫn ghi:

- Mặc định cấu hình XAUUSD: `InpTickSize = 0.1`, `InpTicksPerRow = 12`, tương đương một row bằng `1.2` đơn vị giá.
- Có thể đặt `InpTickSize = 0` để dùng tick size của symbol và chỉnh `InpTicksPerRow`, hoặc đặt trực tiếp `InpRowHeight`.
- Đồng hồ server có chế độ tự nhận; hướng dẫn ghi server UTC+0 (ví dụ Exness) không cần chỉnh tay. Các chế độ khác gồm cố định, đổi giờ theo Mỹ và đổi giờ theo châu Âu; các giả định này vẫn phải kiểm thử với dữ liệu/server thực tế đang dùng.
- Lịch phiên theo giờ Việt Nam trong hướng dẫn (theo quy ước mùa đông, tự điều chỉnh mùa hè):
  - **S1 A:** 06:00–14:59; mùa hè 06:00–13:59.
  - **S2 Au:** 15:00–19:59; mùa hè 14:00–18:59.
  - **S3 My:** 20:00–05:59; mùa hè 19:00–05:59.

Hướng dẫn không liệt kê đầy đủ các đầu ra/level đang được vẽ. Vì thế không được tuyên bố indicator có POC, VAH/VAL, Initial Balance, single prints hoặc các statistic cụ thể cho đến khi nhìn thấy trong bản gốc hoặc kiểm tra source.

Vai trò phân tích được đề xuất cho TPO là giúp người dùng nhìn vị trí hoạt động giá trong phân bố của phiên. Các khái niệm như POC/value area chỉ được đưa vào bản port nếu phiên bản gốc có chúng hoặc người dùng duyệt đặc tả mới rõ ràng.

### 3.3 Sonic R. + RSI Trend Pulse — giữ nguyên nhiệm vụ gốc

- Sonic R. tiếp tục hiển thị cấu trúc giá và marker setup tiềm năng; không trở thành một hệ thống phát lệnh.
- RSI pane tiếp tục mô tả động lượng đa khung; marker RSI là xác nhận momentum M5, không đồng nhất với marker setup giá.
- SMC/TPO ở giai đoạn tích hợp đầu tiên chỉ cung cấp **context layer độc lập**. Không thay đổi ngưỡng, thứ tự trigger, điều kiện reset/re-arm hoặc vai trò marker của hai script lõi.

## 4. Cách đọc toàn cảnh thị trường — không tạo điểm số tổng hợp ở phiên bản đầu

| Câu hỏi phân tích | Lớp tham chiếu | Điều không được suy diễn |
|---|---|---|
| Cấu trúc nào đang tồn tại và sự kiện cấu trúc gần nhất là gì? | SMC — chỉ các tính năng đã xác thực | Không tự coi mọi BOS/CHoCH là tín hiệu giao dịch |
| Giá phân bố ở đâu trong phiên hiện tại/các phiên trước? | TPO — các đầu ra bản gốc thực sự hỗ trợ | Không coi một profile/level đơn lẻ là hướng đi chắc chắn |
| H4/H1 đang thiên hướng thế nào; M15 có pullback; M5 có momentum? | RSI Trend Pulse | Không xem RSI thay thế cấu trúc giá |
| Hình thái Sonic R. có trigger theo định nghĩa đã khóa không? | Sonic R. overlay | Không phát marker chỉ vì SMC/TPO trông hợp lý |

Ở bản đầu, người dùng đối chiếu các lớp bằng mắt. Không thêm “confluence score”, không tô xanh/đỏ toàn bộ chart, không làm ẩn marker, và không gắn điều kiện SMC/TPO mới vào trigger lõi nếu không có ca test và phê duyệt.

## 5. Nguyên tắc bố cục và chống quá tải thông tin

1. Nến giá luôn là lớp có ưu tiên thị giác cao nhất.
2. SMC chỉ hiển thị các mức/sự kiện đã xác nhận, tránh lặp nhãn ở mọi nến.
3. TPO phải phân biệt phiên và ranh giới phiên; profile không được che phần lớn nến hay làm các mức cấu trúc mất khả năng đọc.
4. Dragon/EMA/Swing/round levels vẫn dùng nét/độ tương phản dịu hơn dữ liệu giá.
5. RSI nằm ở pane riêng, không đặt thêm đường RSI lên chart giá.
6. Mỗi lớp nên có tham số bật/tắt riêng nếu nền tảng cho phép; mặc định hiển thị tiết chế.
7. Không dùng nhãn BUY/SELL; không thêm giao dịch, SL/TP, TP1/TP2, quản lý vị thế, exit hoặc cảnh báo thoát lệnh.

## 6. Tiêu chí kiểm soát thay đổi

Một đề xuất liên kết SMC/TPO với marker Sonic R. chỉ được xem xét khi đáp ứng đủ:

1. Tính năng SMC/TPO có bằng chứng xác thực và định nghĩa rõ.
2. Có lý do nghiệp vụ cho thấy liên kết đó giúp trả lời một câu hỏi mà bốn lớp chưa thể hiện được trực quan.
3. Xác định rõ đó là **thông tin hiển thị**, **bộ lọc setup** hay **điều kiện trigger**; ba vai trò này không được nhập làm một.
4. Có ca test minh họa hành vi trước/sau và kiểm tra hồi quy đối xứng tăng/giảm.
5. Người quản lý duyệt trước khi viết code.

Nếu một tính năng chưa có source/tài liệu, ghi `UNKNOWN — source required`, không tự tái dựng dựa vào tên file hoặc suy đoán từ khái niệm SMC/TPO chung.
