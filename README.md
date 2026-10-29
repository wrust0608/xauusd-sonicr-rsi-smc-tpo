# XAUUSD Visual Analysis Indicator Suite
### Sonic R. Setup Overlay + RSI Trend Pulse Pane + SMC Market Structure Overlay + TPO Session Profile

**Target Environment:** Exness Terminal Web (TakeProfit Indie v5)  
**Current Gate:** Phase 0 — Learning Gate  
**Gate Status:** `PENDING` (Submitted for Manager Review)  
**Code Authority:** `NOT GRANTED` (Strict Phase 0 discipline — Zero indicator code created or modified)  
**Knowledge Base Version:** v1.2.2 (C17 Algorithmic Correction Complete)  

---

## 📌 Hướng dẫn dành cho Người quản lý (Manager Quick Review Links)

Hồ sơ bàn giao và các tài liệu học tập của Phase 0 đã được tổ chức hoàn chỉnh để Người quản lý tiện thẩm định trực tiếp trên GitHub:

### 📦 Hồ sơ bàn giao chính thức (Deliverables Bundle)
- **Tệp nén bàn giao:** [`Phase0_Deliverables_Bundle.zip`](./Phase0_Deliverables_Bundle.zip)  
  *Kích thước:* `52,985 bytes` | *SHA-256:* `52AF3D273DC6B1EA6547AE5E9C99DE98F7C22082DE69A92D1150832DF1A306C7`
- **Kê khai mã băm bàn giao:** [`MANIFEST_CHECKSUMS.txt`](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/MANIFEST_CHECKSUMS.txt)

### 📑 Bộ hồ sơ lưu trữ bền vững (Persistent Learning Records)
1. 📋 [**Báo cáo học tập toàn diện (LEARNING_REPORT.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/LEARNING_REPORT.md): Tổng hợp 8 chủ đề kiến thức, xác thực nguồn chính thức và cam kết kỷ luật.
2. 📝 [**Bài đánh giá 35 câu & Ma trận chấm điểm (ASSESSMENT_ANSWERS.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/ASSESSMENT_ANSWERS.md): Trả lời chi tiết 17 câu Critical (C1–C17) và 18 câu General (Q17–Q34). C17 được sửa đổi chuẩn xác theo thuật toán mở rộng 1 hàng và quy tắc tie-break chính thức. Điểm số chuẩn hóa: **100/100** (52/52 điểm thô, 100% Critical Pass).
3. 📖 [**Sổ theo dõi khẳng định (CLAIM_LEDGER.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/CLAIM_LEDGER.md): Đăng ký và phân loại 24 khẳng định kỹ thuật (CLM-01 đến CLM-24) với nhãn bằng chứng rõ ràng.
4. 🔍 [**Khoảng trống kiến thức & Source Blockers (KNOWLEDGE_GAPS.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/KNOWLEDGE_GAPS.md): 5 blocker P0 (thiếu source SMC/TPO, kiểm thử runtime Exness, feature inventory SMC, grid origin) và 5 gap P1.
5. 🧠 [**Bộ nhớ dự án chuẩn (PROJECT_MEMORY.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/PROJECT_MEMORY.md): Bản ghi nhớ trung tâm về bất biến, ranh giới kiến trúc và trạng thái `PENDING`.
6. 🚀 [**Quy trình mở phiên (SESSION_START_CHECKLIST.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/learning_records/SESSION_START_CHECKLIST.md): Quy trình 7 bước an toàn bắt buộc trước mỗi phiên làm việc.
7. 📜 [**Nhật ký tri thức (CHANGELOG_KNOWLEDGE.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/CHANGELOG_KNOWLEDGE.md): Nhật ký cập nhật Knowledge Base v1.2.2 ghi nhận hiệu chỉnh thuật toán câu C17 và dựng Release Candidate 2.

### 📚 Tài liệu đặc tả và cơ sở tri thức gốc
- 🎯 [**Bắt đầu tại đây (00_BAT_DAU_TAI_DAY.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/00_BAT_DAU_TAI_DAY.md)
- 📖 [**Cổng học tập & Chỉ mục Knowledge Base (00_INDEX_AND_LEARNING_GATE.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/KNOWLEDGE_BASE/00_INDEX_AND_LEARNING_GATE.md)
- 🔒 [**Đặc tả đã khóa v1.0 (01_SPEC_LOCK.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/01_SPEC_LOCK.md)
- 🧩 [**Đặc tả tích hợp SMC & TPO v1.1 (06_SMC_TPO_INTEGRATION_SPEC.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/06_SMC_TPO_INTEGRATION_SPEC.md)
- 🛡️ [**Cổng tương thích nền tảng (07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md)

---

## 🔒 Kiểm tra tính toàn vẹn của mã tham chiếu & Baseline (100% Unchanged)

Tất cả 8 tệp gốc được kiểm tra mã băm SHA-256 đối chiếu với `SHA256SUMS_ALL.txt`:

| Tệp kiểm tra | Mã băm SHA-256 hiện tại | Trạng thái đối chiếu |
|---|---|:---:|
| `reference/SonicR_Setup_Overlay_stage4_reference.indie` | `ADDE4C77B45EA90D45EC21526E2B7EB9F5E11A5CADE77618EABECE4244F44E3B` | ✅ Khớp 100% |
| `reference/RSI_Trend_Pulse_Pane_stage4_reference.indie` | `6DC9A286B3AEFFFB40845000603CEF4E4DAFB8E058D91FAC9E894441FDC64169` | ✅ Khớp 100% |
| `01_SPEC_LOCK.md` | `D30B4BB4B6B6117D48629399ABEC413851788039AAD6BECD16901D885C9B2B79` | ✅ Khớp 100% |
| `06_SMC_TPO_INTEGRATION_SPEC.md` | `F100830EE42189BCF969E4379E5BA07A0A4E5BF6EBB35F6F070CB3B2C928B9EF` | ✅ Khớp 100% |
| `07_PLATFORM_COMPATIBILITY_AND_SOURCE_GATE.md` | `9EB389CF8A1ACFBFEDC61883211B7DCB5068B79D0DE4C937419FD84DE6EA985C` | ✅ Khớp 100% |
| `user_inputs/SC_MarketStructure.ex5` | `AC4B9B87B1BB3A1A588E5ED4103720AEBE494279C6A353D30487634E806415FC` | ✅ Khớp 100% |
| `user_inputs/TPO_Session_v1.01.zip` | `3039F1E9DDB7FB296A8FF16E74290A7C87C2D827BEF2B325EFAE2957EA8B3634` | ✅ Khớp 100% |
| `user_inputs/TPO_HUONG_DAN.txt` | `EFB80CE8EA7814975A3443F9C967523E847BFA62458DCA166904B9CF6A62CBA4` | ✅ Khớp 100% |

---

## ⚡ Bản quyền và Cam kết Kỷ luật Phase 0

> **TUYỆT ĐỐI KHÔNG TẠO MỚI, CHỈNH SỬA, REFACTOR HOẶC THỬ NGHIỆM CODE CHỈ BÁO.**  
> Trạng thái hiện tại là **`PENDING`**. Agent tuyệt đối không có quyền tự phê duyệt để chuyển sang giai đoạn audit hoặc triển khai mã nguồn khi chưa có văn bản chấp thuận chính thức từ Người quản lý.

