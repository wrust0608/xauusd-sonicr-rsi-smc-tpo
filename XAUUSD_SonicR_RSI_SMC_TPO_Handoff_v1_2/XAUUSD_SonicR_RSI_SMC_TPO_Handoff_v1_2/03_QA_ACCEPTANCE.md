# KẾ HOẠCH QA & NGHIỆM THU

**Phạm vi phiên bản:** Các test trong tài liệu này áp dụng cho hai script lõi Sonic R./RSI. Kiểm thử SMC/TPO được bổ sung riêng trong `09_SMC_TPO_QA_ACCEPTANCE.md`; kết quả hai nhóm test phải báo cáo tách biệt.

## A. Phân cấp bằng chứng

| Cấp kiểm chứng | Bằng chứng tối thiểu | Không được kết luận thay thế |
|---|---|---|
| Static review | diff, vị trí dòng, truy vết requirement | Không chứng minh runtime |
| Syntax/static API | kiểm tra cú pháp Python-like và đối chiếu tài liệu Indie | Không tương đương compile trên Exness |
| Compile on Exness | kết quả Compile/Add to Chart của từng script hoặc ảnh/log rõ | Không chứng minh logic đúng |
| Visual QA | ảnh chart XAUUSD M5 có đủ hai script, các đường và marker | Không chứng minh non-repaint |
| Behavioral tests | các kịch bản có input/time/expected/actual | Không thay thế kiểm thử ranh giới MTF |
| Reload/repaint | ảnh trước/sau F5 hoặc log timestamp qua ranh giới nến | Không tuyên bố tuyệt đối nếu chưa thử đủ |

## B. Checklist triển khai trên Exness

1. Mở Exness Terminal **Web**, chọn XAUUSD, đặt khung M5.
2. Tạo script mới và dán nguyên văn `SonicR_Setup_Overlay`; lưu/compile; thêm vào chart.
3. Tạo script mới và dán nguyên văn `RSI_Trend_Pulse_Pane`; lưu/compile; thêm vào chart phụ.
4. Xác nhận cả hai dùng cùng giá trị cho 7 tham số động lượng dùng chung: `strict_htf`, `min_slp`, `tangle_sp`, `w45_tol`, `d_max`, `db_tol`, `db_prom`.
5. Lưu ảnh toàn chart (giá + pane RSI) cùng thông báo compiler và thông số đầu vào.

## C. Bộ test bắt buộc

### T01 — Compile & kiểu hiển thị
- **Setup:** Hai script gắn lên XAUUSD M5.
- **Đạt:** Cả hai biên dịch; tất cả đường và pane hiển thị; không có runtime error.
- **Bằng chứng:** Ảnh/log compile riêng từng script.

### T02 — Marker nằm đúng nến đã đóng
- **Setup:** Ghi timestamp của nến M5 vừa đóng khi marker phát.
- **Đạt:** Marker nằm tại nến xác nhận dự kiến, không lệch 1 hay 2 nến.
- **Bắt buộc kiểm tra:** Tác động kết hợp giá trị `[1]` với `offset=-1`.

### T03 — Bullish setup hoàn chỉnh
- **Setup:** H4/H1 tăng hợp lệ; M15 hồi về vùng 40–50 hoặc WMA45; giá có L→H→HL hợp lệ và touch/bounce hoặc swing breakout theo `trig_mode`; M5 có Regular/Hidden bullish divergence hoặc RSI Double Bottom hợp lệ, RSI cắt lên EMA9.
- **Đạt:** Script 1 có ▲ ở nến setup; Script 2 phản ánh xác nhận M5 theo vai trò đã khóa.

### T04 — Bearish setup hoàn chỉnh
- Đối xứng T03: H4/H1 giảm; M15 vùng 50–60 hoặc WMA45; H→L→LH; phân kỳ/mô hình đỉnh; RSI cắt xuống EMA9; kỳ vọng ▼.

### T05 — Sideway / ba đường chụm
- **Setup:** Spread RSI/EMA9/WMA45 trên H4 hoặc H1 dưới ngưỡng `tangle_sp`, hoặc WMA45 phẳng/độ dốc không đạt.
- **Đạt:** Không hiển thị trạng thái bối cảnh xu hướng đủ điều kiện và không có marker setup mới do thiên hướng này.

### T06 — Touch nhưng chưa Bounce
- **Setup:** Giá chạm Dragon nhưng đóng cửa chưa bật ra ngoài dải.
- **Đạt:** Touch một mình không phát ▲/▼.

### T07 — Bounce sau Touch
- **Setup:** Sau Touch có nến M5 đóng cửa bật ra ngoài Dragon theo hướng đúng, trong khi cấu trúc/MTF/M5 cũng hợp lệ.
- **Đạt:** Có thể phát marker theo đúng định nghĩa; marker đúng nến.

### T08 — Swing breakout và breakout giả
- **Setup:** Chế độ `trig_mode=1`, kiểm thử đóng cửa vượt H/L; thêm đối chứng giá đột biến đâm qua Dragon nhưng chưa có cấu trúc wave hoặc M15 không trong vùng chờ.
- **Đạt:** Breakout hợp lệ chỉ xuất hiện khi cấu trúc đầy đủ; cú xuyên đơn lẻ không tạo setup.

### T09 — Pullback thất bại / phá EMA89 hoặc gốc sóng
- **Setup:** Giá xuyên qua EMA89 hoặc HL phá đáy gốc L (đối xứng LH vượt đỉnh gốc H).
- **Đạt:** Setup vô hiệu, không phát marker.

### T10 — Phân kỳ và Double Bottom/Top
- **Setup:** Dữ liệu mô phỏng/đánh dấu trên chart cho 4 dạng RegBull, HidBull, RegBear, HidBear và DB/DT hợp lệ/không hợp lệ.
- **Đạt:** Đáy chỉ ghép với RSI low + price low; đỉnh chỉ ghép RSI high + price high; khoảng cách trong [3, d_max]; DB/DT không đạt `db_tol` hoặc `db_prom` thì không trigger.

### T11 — Không phát trùng cùng chu kỳ
- **Setup:** RSI cắt EMA9 nhiều lần trong cùng một nhịp pullback, không tạo pivot/wave mới thỏa điều kiện re-arm.
- **Đạt:** Không lặp marker trong cùng chu kỳ.

### T12 — Chu kỳ mới độc lập
- **Setup:** Một setup đã phát; hình thành swing mới đủ điều kiện sau đó. Bao gồm tình huống đỉnh mới thấp hơn, cao hơn hoặc bằng đỉnh đã khóa.
- **Đạt:** Hành vi phải khớp quy tắc reset khóa đã ghi trong đặc tả; nếu quy tắc chặn đỉnh thấp hơn gây bỏ lỡ một swing độc lập, phải được báo cáo như design trade-off, không tự đổi.

### T13 — Thiếu dữ liệu/warm-up
- **Setup:** Chart ngắn hoặc scroll về giai đoạn chưa đủ dữ liệu HTF/EMA200/RSI.
- **Đạt:** Không runtime error; guard trả NaN an toàn; ghi nhận khoảng thời gian đầu không đủ dữ liệu.

### T14 — Ranh giới HTF
- **Setup:** Theo dõi qua thời điểm đóng đồng thời hoặc riêng của M5/M15/H1/H4.
- **Đạt:** Điều kiện HTF dùng nến HTF đã đóng và không dựa vào giá trị đang chạy của nến HTF để đóng dấu lịch sử.
- **Bằng chứng:** Ghi thời gian nến M5, thời gian đóng nến HTF liên quan và ảnh/log.

### T15 — Reload/F5
- **Setup:** Ghi lại ít nhất 3–5 marker vừa xuất hiện; nhấn F5/reload.
- **Đạt:** Marker lịch sử vẫn ở đúng nến đã xác nhận; mọi khác biệt phải ghi lại và truy nguyên.
- **Cảnh báo:** Trước khi test này hoàn thành, trạng thái repaint luôn là `PENDING`.

### T16 — RSI pane markers độc lập với overlay
- **Setup:** Tìm trường hợp M5 momentum đã xác nhận nhưng setup giá chưa đủ điều kiện hoặc hình thành ở thanh khác.
- **Đạt:** Script 2 vẫn thể hiện đúng sự kiện momentum theo vai trò đã khóa; Script 1 chỉ xuất marker khi điều kiện setup giá tổng hợp đạt. Không bắt buộc hai marker cùng nến.

## D. Biểu mẫu kết quả từng test

Với mỗi test, agent/kiểm thử viên ghi:

- ID test / build hash hoặc ngày giờ phiên bản.
- Chart/instrument/timeframe và thông số hai script.
- Dữ liệu/điều kiện tiền đề, timestamp nến liên quan.
- Expected behavior.
- Actual behavior.
- PASS / FAIL / BLOCKED (không dùng PASS khi chưa thực sự thử).
- Ảnh/log đi kèm và issue liên quan.

## E. Cổng phát hành

Không gắn nhãn “hoàn tất” khi bất kỳ mục P0 nào còn mở. Phải báo riêng ít nhất 5 trạng thái: `CODE REVIEWED`, `STATIC API CHECKED`, `COMPILED ON EXNESS`, `VISUAL QA PASSED`, `REPAINT TEST PASSED`. Chỉ hai trạng thái đầu có thể được xác nhận trong kiểm tra tĩnh; ba trạng thái sau cần bằng chứng môi trường thật.
