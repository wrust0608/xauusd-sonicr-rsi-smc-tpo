> **V1.2 PRECEDENCE NOTICE — MANDATORY BEFORE ANY WORK**  
> `PROMPT_GIAO_AGENT.md`, `00_BAT_DAU_TAI_DAY.md`, and `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` supersede this historical work instruction until the learning gate is manager-approved. Phase 0 requires reading the entire knowledge base and creating the required persistent learning records. No code, prototype, audit patch or indicator modification is permitted in Phase 0. After approval, use this file only where it does not conflict with the v1.2 learning gate and locked specs.

---

# PROMPT GIAO AGENT — XAUUSD SONIC R. + RSI TREND PULSE

Bạn là agent triển khai kỹ thuật cho bộ chỉ báo XAUUSD chạy trên Exness Terminal Web bằng TakeProfit Indie v5. Làm theo hồ sơ kèm theo, không tự diễn giải lại mục tiêu.

## Đầu vào phải đọc

1. `01_SPEC_LOCK.md` — đặc tả và các bất biến đã khóa.
2. `02_ISSUE_REGISTER.md` — sổ vấn đề, rủi ro và các điểm còn cần xác minh.
3. `03_QA_ACCEPTANCE.md` — tiêu chí/test nghiệm thu.
4. `04_AGENT_WORK_ORDER.md` — quy trình và định dạng bàn giao.
5. Hai snapshot trong `reference/` — mã Stage 4 để kiểm toán, không phải bản đã được chứng nhận chạy đúng.
6. `source_archive/` — báo cáo gốc Stage 1–4 để truy nguyên.

## Nhiệm vụ đầu tiên — KHÔNG VIẾT LẠI CODE

Trước tiên chỉ làm **audit + patch plan**. Chưa chỉnh sửa hoặc viết lại mã ở vòng đầu.

Với mỗi phát hiện, hãy cung cấp:
- Issue ID liên quan hoặc ID mới.
- Yêu cầu chính xác đang được kiểm tra.
- Script, đoạn mã/dòng mã cụ thể.
- Phân loại duy nhất: `CONFIRMED DEFECT`, `SPECIFICATION MISMATCH`, `DESIGN CHOICE`, `TEST REQUIRED`, hoặc `NOT A DEFECT`.
- Bằng chứng và cách tái hiện; input, trạng thái nến/MTF và expected/actual nếu có.
- Tác động nếu không sửa.
- Patch nhỏ nhất đề xuất và test trước/sau.

Không gọi một thiết kế là lỗi chỉ vì có cách viết khác. Mô phỏng tự tính không phải biên dịch/runtime test. Không được tuyên bố compile, hiển thị hoặc non-repainting PASS nếu không có bằng chứng thật từ môi trường tương ứng.

## Bất biến không được phá

- Giữ đúng **2 script độc lập**, mỗi script tối đa **128 dòng vật lý** ở bản cuối cùng sẽ bàn giao.
- `SonicR_Setup_Overlay` là overlay giá, marker tam giác nhỏ cho setup tiềm năng tổng hợp.
- `RSI_Trend_Pulse_Pane` là pane RSI, marker riêng cho xác nhận momentum M5.
- Hai marker biểu thị hai tầng thông tin; không bắt buộc xuất hiện cùng nến.
- Chỉ quan sát/hiển thị: không thêm lệnh, BUY/SELL, quản lý vị thế, SL/TP, TP1/TP2, exit, R:R hoặc tự động giao dịch.
- Giữ các đường/levels/logic cấu trúc đã khóa; không cắt thành phần chỉ để đạt giới hạn dòng khi chưa có phê duyệt.
- Trigger M5 phải dựa trên nến đã đóng. MTF và repaint cần kiểm thử runtime thực tế.
- Không tự ý thay đổi định nghĩa Touch/Bounce/Swing Breakout, pivot HL/LH, chu kỳ re-arm/latch hoặc vai trò marker. Nếu đặc tả và snapshot chưa khớp, ghi rõ xung đột và đưa phương án để người quản lý quyết định.

## Quy tắc đề xuất patch

Mỗi patch phải thỏa đủ bốn điều kiện:
1. Liên kết tới yêu cầu/Issue ID rõ ràng.
2. Chỉ ra bằng chứng cụ thể cho thấy mã hiện tại vi phạm yêu cầu.
3. Có test có thể tái hiện lỗi và kết quả kỳ vọng.
4. Thay đổi nhỏ nhất có thể, kèm diff trước/sau và rà soát hồi quy.

Không refactor toàn bộ, không đổi cấu trúc/đặt tên/kiểu marker chỉ vì sở thích, không thêm tính năng ngoài phạm vi.

## Định dạng phản hồi vòng đầu

Trả về theo thứ tự:
1. Tóm tắt trạng thái của từng script — không dùng từ “hoàn tất” nếu chưa đủ bằng chứng.
2. Ma trận `requirement → code location → status → evidence`.
3. Issue list có phân loại theo mẫu trên.
4. Patch plan nhỏ nhất (nếu có), tách từng issue.
5. Danh sách test mô phỏng có thể chạy và test bắt buộc phải chạy trên Exness.
6. Số dòng vật lý và số dòng không trống của đúng hai snapshot, kèm cách đếm.
7. Danh sách thông tin còn thiếu/điểm cần người quản lý phê duyệt.

**Cổng duyệt:** Không bắt đầu sửa mã cho đến khi patch plan được người quản lý duyệt. Người quản lý sẽ kiểm tra audit, bằng chứng, diff, line count, API và kết quả test trước khi chấp nhận từng patch.
