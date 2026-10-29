# XAUUSD Quantitative Visualizer Suite (MT5 Unleashed v2.50)
### Sonic R Setup Overlay + RSI Trend Pulse Pane + SMC Market Structure Overlay + TPO Session Profile

**Target Environment:** MetaTrader 5 (MQL5 64-bit Native)  
**System Version:** v2.50 Unleashed  
**Quality Status:** `100% COMPILED (0 ERRORS, 0 WARNINGS)` | `100% NON-REPAINTING (CLOSED BAR [1])`  

---

## 📌 Hướng dẫn dành cho Người Quản lý & Hội đồng Thẩm định Dự án

Hệ thống chỉ báo định lượng XAUUSD M5 đã hoàn tất quá trình chuyển đổi chiến lược từ Exness sang **MetaTrader 5 Native**. Toàn bộ 4 module đã được loại bỏ hoàn toàn giới hạn 128 dòng, phát huy tối đa khả năng phân tích đa khung thời gian, cấu trúc Smart Money, phân phối phiên TPO và quản trị rủi ro thực chiến.

### 📑 Báo cáo Thẩm định & Tài liệu Chính thức:
* 📊 [**BÁO CÁO TOÀN DIỆN KẾT QUẢ CHUYỂN ĐỔI MT5 & ĐỐI CHIẾU KỸ THUẬT - LÝ THUYẾT THỰC TẾ**](./MANAGEMENT_REVIEW_AND_TECHNICAL_RECONCILIATION_REPORT.md)
* 🚀 [**HƯỚNG DẪN TRIỂN KHAI & VẬN HÀNH BỘ CHỈ BÁO XAUUSD SUITE TRÊN METATRADER 5**](./MT5_XAUUSD_Suite_Deployment_Guide.md)
* 📕 [**HỒ SƠ GỠ LỖI BIÊN DỊCH EXNESS INDIE (E1 – E8)**](./XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/XAUUSD_SonicR_RSI_SMC_TPO_Handoff_v1_2/KNOWLEDGE_BASE/17_INDIE_V5_COMPILER_ERROR_LEDGER.md)

---

## 📦 Danh mục Bản dựng MQL5 & Template 1-Click

Tất cả các tệp nguồn `.mq5` và file nhị phân `.ex5` đã được cài đặt trực tiếp vào MetaTrader 5 của người dùng và lưu trữ tại kho mã nguồn:

### 1. Thư mục Chỉ báo: `MQL5/Indicators/XAUUSD_Suite/`
1. **`SonicR_Setup_Overlay.mq5` / `.ex5`**: Dải Rồng Dragon (EMA 34 High/Close/Low), Trend EMA 89, Macro 200, Swings, Lưới số tròn $10/oz, Bảng HUD On-chart & Cảnh báo Đa kênh (Popup/Sound/Push/Email).
2. **`RSI_Trend_Pulse_Pane.mq5` / `.ex5`**: Wilder RSI 14, EMA 9, WMA 45, Vùng chờ M15 (Level 45/55), Bối cảnh MTF (H4/H1), Tự động vẽ Đường Xu Hướng Phân Kỳ trên Pane & HUD MTF.
3. **`SMC_MarketStructure_Overlay.mq5` / `.ex5`**: Cấu trúc Major & Internal (BOS/CHoCH/iBOS/iCHoCH), Bể thanh khoản EQH/EQL ($$$ BSL/SSL), Quét thanh khoản SFP, Order Blocks, FVGs (Mitigation Tracking), Vùng Premium/Discount (50% Equilibrium) & HUD Cấu trúc.
4. **`TPO_Session_Profile.mq5` / `.ex5`**: Lịch phiên Việt Nam (S1 Á 06:00-14:59, S2 Âu 15:00-19:59, S3 Mỹ 20:00-05:59 VN), Mở rộng 70% Value Area chuẩn xác từ Knowledge Base, Point of Control (POC), Initial Balance (IB 1st hour), Nhận diện Poor Highs/Lows, Biểu đồ mật độ TPO Histogram & HUD Phiên.

### 2. Thư mục Mẫu Biểu đồ (Template): `MQL5/Profiles/Templates/`
* **`XAUUSD_SonicR_System.tpl`**: Nạp đồng thời cả 4 chỉ báo lên biểu đồ XAUUSD M5 chỉ với **1 cú nhấp chuột (1-Click)**, phân bổ tỷ lệ 70% Main Window và 30% Subwindow, Dark Theme sang trọng.

---

## 🔒 Bảng Mã băm Toàn vẹn Cryptographic Hashes (SHA-256)

| Tên Tệp | Kích thước | Trạng thái Biên dịch | Mã băm SHA-256 |
|---|:---:|:---:|---|
| `SonicR_Setup_Overlay.ex5` | 33,848 bytes | 0 errors, 0 warnings | `C0B975D5E85845D7FF56204A3A1530388F4D1B7F7769D3F8D92E11B1D35DF617` |
| `SonicR_Setup_Overlay.mq5` | 21,398 bytes | Mã nguồn C++ v2.50 | `E6A213FA13BBBF20B2F2A1ED969EC02DB0E4BD96A449C650DB74797FE25F2E23` |
| `RSI_Trend_Pulse_Pane.ex5` | 31,846 bytes | 0 errors, 0 warnings | `751F6B3F7AA09D92B138A0D681F785483C485F266BD2D645189A6BCF45607806` |
| `RSI_Trend_Pulse_Pane.mq5` | 19,054 bytes | Mã nguồn C++ v2.50 | `DB3CC8F75C2D416A8E9C5E6F49C2472E289E8C75410DC08D0843DD6401F0E139` |
| `SMC_MarketStructure_Overlay.ex5` | 40,562 bytes | 0 errors, 0 warnings | `972B1D066EAB0B941D6F91B4635188AF379D7B42E7C8F346F4714E485B12C10C` |
| `SMC_MarketStructure_Overlay.mq5` | 27,018 bytes | Mã nguồn C++ v2.50 | `8DA4202FBAE10B324C92A1045E7CB490013FC514B28B445DB372A9DE406EA387` |
| `TPO_Session_Profile.ex5` | 32,040 bytes | 0 errors, 0 warnings | `452C220E2252E58EBA859BCBA1D6D42ABE838B844888BF9B3F5F89184A21FF7A` |
| `TPO_Session_Profile.mq5` | 24,471 bytes | Mã nguồn C++ v2.50 | `878B769E8B8BA7F99B295205DFC2B52F7A280ADF8F425CFFC5251C8DBE33918A` |
| `XAUUSD_SonicR_System.tpl` | 1,480 bytes | Template 1-Click | `DB38C61BE29DA87A193433CBD559DB46635D0A1E44BDD6D0073BCC347E94B16A` |

---

## ⚡ Hướng dẫn Sử dụng Nhanh trên MetaTrader 5
1. Khởi chạy **MetaTrader 5**.
2. Mở biểu đồ **XAUUSD khung M5**.
3. Nhấp **chuột phải vào biểu đồ** $\rightarrow$ chọn **Templates** $\rightarrow$ chọn **`XAUUSD_SonicR_System`**.
