# SESSION START CHECKLIST — MANDATORY SAFETY & GOVERNANCE GATES

**Dành cho Agent ở mọi phiên làm việc tiếp theo:**
Trước khi thực hiện bất kỳ hành động nào trong phiên làm việc mới, Agent **BẮT BUỘC** phải đọc và xác nhận lần lượt từng mục trong danh sách kiểm tra dưới đây.

---

## 1. Trình tự kiểm tra đầu phiên (Pre-flight Execution Order)

- [ ] **Bước 1: Đọc tài liệu chỉ dẫn khởi động:**  
  Đọc `00_BAT_DAU_TAI_DAY.md` và `KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md` để nắm rõ thứ tự ưu tiên và tình trạng cổng phê duyệt hiện tại.
- [ ] **Bước 2: Nạp bộ nhớ dự án bền vững:**  
  Đọc `learning_records/PROJECT_MEMORY.md`, `learning_records/SESSION_START_CHECKLIST.md` và `learning_records/KNOWLEDGE_GAPS.md` để nắm các ràng buộc bất biến và các blocker đang mở. Tuyệt đối không chỉ dựa vào ngữ cảnh hội thoại (chat context).
- [ ] **Bước 3: Xác nhận trạng thái Learning Gate:**  
  Kiểm tra trạng thái phê duyệt của Người quản lý (Project Manager).  
  *Nếu trạng thái vẫn là `PENDING` hoặc `FAILED`:* **TUYỆT ĐỐI KHÔNG TẠO HOẶC SỬA MÃ NGUỒN CHỈ BÁO.** Chỉ được tiếp tục nghiên cứu hoặc bổ sung hồ sơ theo yêu cầu của Quản lý.
- [ ] **Bước 4: Kiểm tra thứ bậc thẩm quyền:**  
  Tuân thủ thứ bậc: Quyết định trong `DECISION_LOG.md` > Đặc tả đã khóa `01_SPEC_LOCK.md` & `06_SMC_TPO_INTEGRATION_SPEC.md` > Mã nguồn/tài liệu gốc của người dùng > API Doc chính thức của nền tảng > Tài liệu phương pháp gốc > Báo cáo lịch sử trong `source_archive/` > Suy luận của Agent.
- [ ] **Bước 5: Kiểm tra các giới hạn bất biến (Core Invariants):**  
  - Sản phẩm là bộ chỉ báo thuần quan sát trực quan thị trường.
  - Tuyệt đối KHÔNG có lệnh BUY/SELL, đặt/sửa/hủy lệnh, SL/TP, TP1/TP2, quản lý vị thế hay auto-trade.
  - Hai script lõi `SonicR_Setup_Overlay` và `RSI_Trend_Pulse_Pane` phải độc lập, mỗi script $\le 128$ dòng vật lý (tính cả dòng trống và header).
  - Marker trên biểu đồ giá (setup tổng hợp) và marker trong pane RSI (xác nhận momentum M5) là hai sự kiện độc lập, không bắt buộc cùng xuất hiện trên một nến.
- [ ] **Bước 6: Kỷ luật phân loại bằng chứng (Evidence Discipline):**  
  Mọi phát biểu kỹ thuật phải được phân loại rõ ràng (`PROJECT_LOCK`, `PRIMARY_SOURCE`, `OFFICIAL_API_DOC`, `SECONDARY_SOURCE`, `USER_ARTIFACT`, `INFERENCE`, `DESIGN_CHOICE`, `RUNTIME_REQUIRED`, `UNKNOWN`).  
  - Không suy diễn thuật toán SMC từ tên file `SC_MarketStructure.ex5`.
  - Không khẳng định TPO có POC/VAH/VAL khi chưa có bằng chứng xác nhận.
  - Không khẳng định `BlockProfile` chạy được trên Exness chỉ vì TakeProfit có tài liệu.
  - Không coi mô phỏng thủ công/kiểm tra cú pháp là đã compile thành công hay pass kiểm thử repaint trên Exness.
- [ ] **Bước 7: Cập nhật vết thay đổi (Audit Trail):**  
  Khi phát hiện sự thật mới, cập nhật `CLAIM_LEDGER.md`, `KNOWLEDGE_GAPS.md` và `CHANGELOG_KNOWLEDGE.md`. Chỉ cập nhật `DECISION_LOG.md` khi người quản lý phê duyệt quyết định mới.
