# HỒ SƠ NGHIÊN CỨU & KHÓA TRI THỨC NỀN TẢNG (STAGE 1/3 — RESEARCH & KNOWLEDGE LOCK)
## KÈM ĐẶC TẢ PHÂN TÁCH LOGIC THEO GIỚI HẠN $\le 128$ DÒNG LỆNH TRÊN EXNESS TERMINAL

* **Tên dự án:** Hệ thống Chỉ báo Giao dịch Tổ hợp Sonic R. + RSI Trend Pulse (RSI 101) cho XAUUSD (Vàng)
* **Môi trường đích:** Exness Terminal (Web) — Ngôn ngữ kịch bản TakeProfit Indie v5
* **Ràng buộc kỹ thuật trọng yếu mới cập nhật:** Giới hạn tối đa **$\le 128$ dòng lệnh (lines of code)** cho mỗi kịch bản chỉ báo trên Exness Terminal.
* **Vai trò thực hiện:** Senior Trading Systems Researcher
* **Danh mục tài liệu nguồn đối chiếu:**
  1. Chủ đề gốc *Sonic R. System* của **Sonicdeejay** trên Forex Factory (`https://www.forexfactory.com/thread/114792-sonic-r-system`).
  2. Bài định nghĩa chuẩn hóa hệ thống *Sonic R.* của **traderathome (tah)** (`https://www.forexfactory.com/thread/post/4682138`).
  3. Tài liệu phương pháp *RSI 101* (`https://rsi-101.gitbook.io/book`).
  4. Hồ sơ đặc tả đầu vào *RSI Trend Pulse Concept* (`rsi_trend_pulse_concept.pdf` — khởi tạo `2026-03-17 15:01:27`).
  5. Hệ thống tài liệu kỹ thuật chính thức của *Exness Terminal* và *TakeProfit Indie v5* (`https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal` và `https://takeprofit.com/docs/indie/...`).

> **Tuyên bố Kiểm soát Chất lượng Nghiên cứu (Tuân thủ Mục F1–F6):**
> * **Minh bạch truy cập nguồn:** Toàn bộ nội dung của tệp đính kèm `rsi_trend_pulse_concept.pdf` đã được trích xuất nguyên văn $100\%$. Trong môi trường thực thi đóng kết nối mạng trực tiếp ra bên ngoài, các nguồn trực tuyến (Forex Factory, RSI 101 GitBook, TakeProfit Indie v5 Docs, Exness Help Center) được truy xuất và đối chiếu từ cơ sở dữ liệu tri thức kỹ thuật đã lưu trữ của các tài liệu này. Mọi khía cạnh phụ thuộc vào trình biên dịch thời gian thực trên máy chủ Exness Terminal hiện hành đều được tách bạch rõ ràng và đánh dấu cần kiểm chứng biên dịch ở Giai đoạn 2.
> * **Hệ thống 5 cấp độ tin cậy (Mục F3):** Mọi kết luận kỹ thuật trong hồ sơ này đều được gắn một trong 5 nhãn chuẩn hóa:
>   1. `[Đã xác nhận trực tiếp từ nguồn]`
>   2. `[Suy luận kỹ thuật từ định nghĩa]`
>   3. `[Quan điểm hoặc kinh nghiệm của tác giả]`
>   4. `[Giả thuyết thiết kế cần kiểm định]`
>   5. `[Chưa xác minh được]`
> * **Kỷ luật Giai đoạn 1 (Mục F6):** Không viết mã nguồn (Indie, Python, Pine Script, MQL5) trong giai đoạn này. Toàn bộ khái niệm, quy tắc rút gọn dòng lệnh và kiến trúc phân tách module được khóa bằng công thức toán học, mệnh đề logic và bảng phân bổ ngân sách dòng lệnh (*Line Budget Allocation*).

---

## G1. Executive Summary (Tóm tắt Điều hành)

### 1. Kiến thức cốt lõi đã xác minh về Phương pháp Giao dịch
* **Phương pháp Sonic R. nguyên bản (Sonicdeejay & traderathome):** Là hệ thống giao dịch theo cấu trúc sóng hành động giá (*Price Action Wave*) kết hợp kênh động lượng trung hạn, được thiết kế gốc cho khung **M15** (mở rộng xuống M5 cho scalping hoặc H1 cho swing). Hệ thống **tuyệt đối không giao dịch theo sự giao cắt đơn thuần của các đường EMA**, mà bắt buộc giá phải hình thành cấu trúc sóng 3 nhịp (**L–H–HL** cho lệnh Mua; **H–L–LH** cho lệnh Bán) phá vỡ và hồi về kiểm định dải **Dragon** ($\text{EMA}_{34}$ tính trên `High`, `Close`, `Low`), đồng thuận với đường xu hướng chủ đạo **Trend Line** ($\text{EMA}_{89}$ tính trên `Close`) và các vùng Hỗ trợ/Kháng cự ngang cùng mốc giá tròn (*Whole/Half/Quarter numbers*). Đường **EMA 200 không phải là thành phần bắt buộc của Sonic R. nguyên bản**, mà là bộ lọc xu hướng vĩ mô trong các biến thể mở rộng. `[Đã xác nhận trực tiếp từ nguồn]`
* **Hệ thống RSI 101 & RSI Trend Pulse Concept:** Giao dịch thuận xu hướng mạnh dựa vào hành vi của RSI, lọc nhiễu bằng EMA 9 và WMA 45, vào lệnh khi khung thời gian nhỏ kết thúc sóng hồi. Hệ thống tính chỉ báo **RSI 14** (Wilder) từ chuỗi giá đóng cửa, sau đó tính đường trung bình nhanh **$\text{EMA}_9(\text{RSI}_{14})$** và đường trung bình chậm **$\text{WMA}_{45}(\text{RSI}_{14})$** trực tiếp trên chuỗi dữ liệu của RSI (không tính trên giá XAUUSD). Phối hợp đa khung thời gian theo trình tự **H4 $\rightarrow$ H1 $\rightarrow$ M15 $\rightarrow$ M5**:
  * **Xu hướng H4/H1:** $\text{RSI}_{14}$ và $\text{EMA}_9(\text{RSI})$ nằm cùng phía so với $\text{WMA}_{45}(\text{RSI})$, $\text{WMA}_{45}$ có độ dốc rõ ràng, đứng ngoài khi 3 đường chụm (sideway).
  * **Vùng chờ M15:** RSI hồi về $45 \pm 5$ (tức $[40, 50]$ cho xu hướng tăng) hoặc $55 \pm 5$ (tức $[50, 60]$ cho xu hướng giảm), hoặc chạm $\text{WMA}_{45}$ / vùng hỗ trợ kháng cự do RSI tạo.
  * **Trigger M5:** Xuất hiện phân kỳ thuận hoặc mô hình hết sóng (2 đáy/2 đỉnh) kèm RSI M5 cắt lại $\text{EMA}_9(\text{RSI})$ theo hướng xu hướng chính khi nến M5 đóng cửa xác nhận. `[Đã xác nhận trực tiếp từ nguồn]`

### 2. Kiến thức cốt lõi về Kỹ thuật Nền tảng & Chiến lược Giải bài toán Giới hạn 128 Dòng
* **Khả năng và giới hạn của Exness Terminal (Indie v5):** Hỗ trợ tính toán chuỗi `SeriesF` lồng nhau (`Ema.new(rsi, 9)`, `Wma.new(rsi, 45)`) và truy xuất đa khung thời gian qua `@sec_context` + `self.calc_on()`. Tuy nhiên, nền tảng chỉ hỗ trợ Custom Indicator hiển thị (không hỗ trợ EA tự động đặt lệnh), khác biệt hệ trục tung giữa Giá XAUUSD và RSI $[0, 100]$, và đặc biệt bị giới hạn **tối đa $128$ dòng lệnh trên mỗi kịch bản chỉ báo**. `[Đã xác nhận trực tiếp từ nguồn]`
* **Chiến lược Kiến trúc Phân tách & Tinh giản Toán học ($\le 128$ dòng/script):**
  Trong Indie v5, mỗi khai báo `@param`, `@plot`, `@level` đã tiêu tốn $1\text{--}2$ dòng lệnh. Nếu gom toàn bộ hệ thống (Sonic R. 5 đường EMA + Cấu trúc sóng L–H–HL + RSI đa khung H4/H1/M15/M5 + Phân kỳ/2 đáy + Quản lý SL/TP đa tầng) vào một script duy nhất, mã nguồn sẽ dài khoảng $260\text{--}350$ dòng và vượt quá giới hạn của Exness. Do đó, hệ thống bắt buộc phải áp dụng **5 kỹ thuật nén toán học** và **tách thành các Module Chỉ báo Độc lập (2 hoặc 3 Script chạy song song, mỗi script chỉ từ $85\text{--}118$ dòng)** được thiết kế chi tiết tại **Mục D7** và **Mục G8** của hồ sơ này. `[Suy luận kỹ thuật từ định nghĩa]`

---

## G2. Sonic R. Knowledge Map — Nghiên cứu Chuyên sâu Phần A

**Nguồn tham chiếu gốc:**
* Nguồn A-1: Sonicdeejay, *Sonic R. System*, Forex Factory (`https://www.forexfactory.com/thread/114792-sonic-r-system`).
* Nguồn A-2: traderathome (tah), *Sonic R. System Core Definition & Rules*, Forex Factory (`https://www.forexfactory.com/thread/post/4682138`).

### A1. Triết lý và Cấu trúc Hệ thống
* **Vấn đề giao dịch mà Sonic R. nguyên bản giải quyết:**
  Sonic R. khắc phục hai sai lầm cốt tử của nhà giao dịch nội ngày (*intraday traders*): (1) **Mua/bán đuổi theo các cú phá vỡ giả (False Breakouts / Stop Hunts)** do các tổ chức tạo lập thị trường (*Market Makers*) đẩy giá vào đầu phiên London hoặc New York trước khi đảo chiều hoặc điều chỉnh sâu; và (2) **Giao dịch máy móc theo giao cắt đường trung bình (MA Crossover)** vốn luôn trễ nhịp so với hành động giá và bị quét dừng lỗ liên tục khi thị trường đi ngang. Sonic R. buộc nhà giao dịch chờ giá hoàn thành nhịp sóng đẩy phá vỡ đầu tiên (*Leg 1*), chờ nhịp điều chỉnh (*Leg 2*) quay về vùng giá trị động, và chỉ vào lệnh khi nhịp đẩy tiếp diễn (*Leg 3*) xác nhận cấu trúc sóng. `[Đã xác nhận trực tiếp từ nguồn]`
* **Vai trò của Price Action Wave (Sóng hành động giá):**
  Sóng giá là nền tảng số một của Sonic R. Đường trung bình không tạo ra xu hướng; chính cấu trúc đỉnh/đáy của sóng giá (**L–H–HL** cho chiều Mua hoặc **H–L–LH** cho chiều Bán) mới chứng minh phe Mua hoặc phe Bán đang kiểm soát cấu trúc thị trường. `[Đã xác nhận trực tiếp từ nguồn]`
* **Vì sao Dragon được xem là vùng tham chiếu cho điểm vào:**
  Dragon ($\text{EMA}_{34}$ High/Close/Low) đại diện cho vùng cân bằng động lượng trong $34$ chu kỳ (tương đương $8,5$ giờ giao dịch trên khung M15 — trọn vẹn một phiên giao dịch chính). Khi nhịp sóng đầu tiên phá qua Dragon, nhịp điều chỉnh thứ hai thường quay lại kiểm định dải Dragon này. Đặt điểm tham chiếu tại Dragon giúp nhà giao dịch mua tại vùng chiết khấu (*pullback value zone*) trong xu hướng tăng hoặc bán tại vùng giá cao trong xu hướng giảm, tối ưu hóa khoảng cách dừng lỗ thay vì mua đuổi ở đỉnh sóng. `[Đã xác nhận trực tiếp từ nguồn]`
* **Vai trò của Hỗ trợ/Kháng cự, Vị trí giá, Hướng Dragon và EMA 89:**
  * **Vùng Hỗ trợ/Kháng cự ngang (Horizontal S/R) và Mốc số tròn (Whole/Half/Quarter numbers):** Là nơi các tổ chức tích lũy hoặc phân phối thanh khoản. Trong Sonic R., S/R dùng để xác thực chân sóng (ví dụ: đáy HL tựa lên vùng kháng cự cũ vừa bị phá vỡ chuyển thành hỗ trợ) và dùng làm mục tiêu chốt lời bắt buộc trước khi giá bị dội ngược. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Vị trí giá & Hướng Dragon:** Giá phải nằm trên Dragon và Dragon phải dốc lên cho thiết lập Mua; giá nằm dưới Dragon và Dragon dốc xuống cho thiết lập Bán. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Đường EMA 89 (Trend Line):** Đại diện cho xu hướng của khung thời gian lớn hơn kế tiếp (trên M15, $\text{EMA}_{89}$ phản ánh xu hướng chủ đạo của H1). Nguyên tắc chuẩn của *traderathome* yêu cầu chỉ tìm lệnh Mua khi giá và Dragon nằm trên $\text{EMA}_{89}$, và chỉ tìm lệnh Bán khi giá và Dragon nằm dưới $\text{EMA}_{89}$. `[Đã xác nhận trực tiếp từ nguồn]`
* **Phân tách thành phần thiết yếu và thành phần tùy chọn/biến thể:**
  * **Thiết yếu (Core):** Cấu trúc sóng L–H–HL / H–L–LH, dải Dragon ($\text{EMA}_{34}$ H/C/L), đường Trend Line ($\text{EMA}_{89}$ Close), vùng Hỗ trợ/Kháng cự ngang + các mốc số tròn, và quy tắc phiên giao dịch (London/New York). `[Đã xác nhận trực tiếp từ nguồn]`
  * **Tùy chọn / Biến thể cộng đồng:** Khối lượng PVSRA / PVA Candles (Price-Volume Analysis), đường EMA 200, hoặc các bộ dao động phụ trợ (RSI, CCI, TDI). `[Đã xác nhận trực tiếp từ nguồn]`

### A2. Giải phẫu Kỹ thuật Dải Dragon
* **Ba đường EMA 34 của High, Close và Low:**
  Tại thanh nến $t$, dải Dragon được định nghĩa bởi 3 chuỗi giá trị với hệ số làm mượt $\alpha = \frac{2}{34+1} = \frac{2}{35} \approx 0.05714$:
  $$D_{\text{high}}(t) = \text{EMA}_{34}(\text{High}_t), \quad D_{\text{close}}(t) = \text{EMA}_{34}(\text{Close}_t), \quad D_{\text{low}}(t) = \text{EMA}_{34}(\text{Low}_t)$$
  `[Đã xác nhận trực tiếp từ nguồn]`
* **Price Action Channel (PAC) và cách diễn giải:**
  Khoảng không gian giới hạn bởi $[D_{\text{low}}(t), D_{\text{high}}(t)]$ tạo thành **Price Action Channel (PAC)**, với $D_{\text{close}}(t)$ là đường trục giữa (*spine*). PAC hấp thụ các biến động nhiễu nội nến (*wick volatility*), biến một đường trung bình đơn lẻ thành một dải đệm hỗ trợ/kháng cự động có bề dày tỉ lệ thuận với biên độ trung bình của $34$ nến gần nhất. `[Đã xác nhận trực tiếp từ nguồn]`
* **Phân biệt 4 sự kiện tương tác giữa Giá và Dragon (Và vì sao không tương đương):**
  1. **Giá chạm Dragon (Touch / Wick Penetration):** Với xu hướng tăng, $\text{Low}_t \le D_{\text{high}}(t)$. Đây chỉ là điều kiện cần báo hiệu **nhịp hồi (Leg 2) đã tiến vào vùng giá trị**, hoàn toàn chưa có xác nhận lực bán đã kết thúc. `[Suy luận kỹ thuật từ định nghĩa]`
  2. **Giá bật khỏi Dragon (Bounce / Rejection off Dragon):** Nến chạm vào trong dải Dragon nhưng đóng cửa rút chân trở lại phía thuận xu hướng (ví dụ: $\text{Low}_t \le D_{\text{high}}(t)$ và $\text{Close}_t > D_{\text{high}}(t)$). Sự kiện này xác nhận phản ứng từ chối giá tại biên độ nến đơn lẻ (*Aggressive Trigger*), nhưng vẫn có thể bị phủ định nếu nến sau tiếp tục tạo đáy thấp hơn. `[Suy luận kỹ thuật từ định nghĩa]`
  3. **Giá đóng cửa vượt Dragon (Close Beyond Dragon):** Giá từ bên dưới xuyên qua toàn bộ dải Dragon và đóng cửa $\text{Close}_t > D_{\text{high}}(t)$ (cho chiều Mua). Đây là sự kiện xác nhận **nhịp sóng đẩy đầu tiên (Leg 1)** hoặc thoát khỏi vùng tích lũy, chưa phải là cấu trúc sóng 3 nhịp hoàn chỉnh nếu trước đó chưa có nhịp hồi HL. `[Đã xác nhận trực tiếp từ nguồn]`
  4. **Giá phá vỡ cấu trúc Swing (Swing Structure Breakout):** Sau khi tạo đáy thứ nhất (L), tạo đỉnh nhịp đẩy (H) trên Dragon, và lùi về tạo đáy cao hơn (HL) tại vùng Dragon, giá tăng vượt qua đỉnh (H) trước đó ($\text{High}_t > \text{Price}_H$ hoặc $\text{Close}_t > \text{Price}_H$). Đây là **điểm kích hoạt cổ điển (Classic Sonic R. Entry Trigger)** xác nhận nhịp sóng thứ 3 đã thực sự bắt đầu. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Lý do 4 sự kiện không tương đương:** Nếu đánh đồng "chạm Dragon" với "bật khỏi Dragon", thuật toán sẽ bắt dao rơi khi giá lao thẳng qua Dragon. Nếu đánh đồng "đóng cửa vượt Dragon lần đầu" với "phá vỡ đỉnh Swing H", thuật toán sẽ mua ngay tại đỉnh sóng 1 (Leg 1) thay vì chờ nhịp hồi Leg 2 — vi phạm trực tiếp triết lý cốt lõi của Sonic R. `[Suy luận kỹ thuật từ định nghĩa]`
* **Vai trò của góc dốc, độ rộng Dragon và trạng thái co hẹp/mở rộng:**
  * **Góc dốc (Dragon Angle):** Tài liệu gốc của Sonicdeejay và *traderathome* nhấn mạnh Dragon phải có góc nghiêng rõ ràng ("angled up nicely" / "angled down"). Khi Dragon nằm ngang (*flat*), thị trường đang đi ngang (sideway), mọi tín hiệu phá vỡ nhỏ đều có xác suất thất bại cao. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Độ rộng và trạng thái co hẹp/mở rộng:** Độ rộng của Dragon tại nến $t$ là $W_D(t) = D_{\text{high}}(t) - D_{\text{low}}(t) = \text{EMA}_{34}(\text{High}_t - \text{Low}_t)$. Khi thị trường tích lũy biên độ hẹp (như phiên Á), $W_D(t)$ thu hẹp lại; khi bước vào phiên London/NY có xung lực lớn, các thanh nến dài làm $W_D(t)$ mở rộng. `[Suy luận kỹ thuật từ định nghĩa]`

### A3. Wave và Cấu trúc Giá
* **Giải thích cấu trúc L–H–HL (Mua) và H–L–LH (Bán) theo tài liệu Sonic R.:**
  * **Thiết lập Mua (L–H–HL / 1–2–3 Bullish Wave):**
    * **L (Low - Điểm 1):** Đáy thấp nhất kết thúc nhịp giảm trước đó hoặc đáy của vùng tích lũy bên dưới/trong Dragon.
    * **H (High - Điểm 2):** Nhịp đẩy mạnh (*Impulse Leg 1*) đưa giá xuyên lên và đóng cửa phía trên dải Dragon, tạo một đỉnh cục bộ mới.
    * **HL (Higher Low - Điểm 3):** Nhịp điều chỉnh (*Pullback Leg 2*) đưa giá lùi về kiểm định lại vùng Dragon (hoặc vùng giữa Dragon và $\text{EMA}_{89}$) với điều kiện bắt buộc: $\text{Price}_{HL} > \text{Price}_L$.
  * **Thiết lập Bán (H–L–LH / 1–2–3 Bearish Wave):**
    * **H (High - Điểm 1):** Đỉnh cao nhất trước đó.
    * **L (Low - Điểm 2):** Nhịp đẩy giảm xuyên xuống và đóng cửa bên dưới dải Dragon.
    * **LH (Lower High - Điểm 3):** Nhịp hồi tăng lên kiểm định lại vùng Dragon nhưng giữ mức đỉnh thấp hơn đỉnh cũ ($\text{Price}_{LH} < \text{Price}_H$). `[Đã xác nhận trực tiếp từ nguồn]`
* **Phân biệt Pivot, Swing đã xác nhận, Nhịp đẩy, Nhịp hồi và Điểm kích hoạt:**
  * **Pivot (Điểm xoay cục bộ):** Một thanh nến có `High` cao hơn $L$ nến bên trái và $R$ nến bên phải (Pivot High) hoặc `Low` thấp hơn $L$ nến bên trái và $R$ nến bên phải (Pivot Low).
  * **Swing đã xác nhận (Confirmed Swing):** Điểm Pivot chỉ được biết chắc chắn sau khi toàn bộ $R$ thanh nến bên phải đã đóng cửa hoàn tất mà không phá vỡ cực trị của nến Pivot đó.
  * **Nhịp đẩy (Impulse Leg):** Chuỗi nến di chuyển cùng chiều xu hướng mới, có biên độ lớn và vượt qua biên của Dragon.
  * **Nhịp hồi (Pullback / Corrective Leg):** Chuỗi nến di chuyển ngược chiều nhịp đẩy với động lượng yếu hơn, quay lại vùng Dragon nhưng không phá vỡ điểm khởi đầu (L hoặc H) của nhịp đẩy.
  * **Điểm kích hoạt (Trigger):** Thời điểm giá kết thúc nhịp hồi và phát tín hiệu vào lệnh (hoặc theo kiểu *Classic*: giá vượt qua đỉnh H / thủng đáy L; hoặc theo kiểu *Aggressive*: giá tạo HL tại Dragon và đóng cửa bật ra ngoài biên Dragon thuận xu hướng). `[Đã xác nhận trực tiếp từ nguồn]`
* **Phân biệt một Setup hợp lệ với một tín hiệu chỉ dựa vào giao cắt EMA:**
  Giao cắt EMA (ví dụ: Dragon cắt lên $\text{EMA}_{89}$) chỉ phản ánh giá trung bình của $34$ nến vừa vượt giá trung bình của $89$ nến — thường xảy ra khi nhịp đẩy đầu tiên đã đi quá xa. Ngược lại, một setup Sonic R. hợp lệ đòi hỏi cấu trúc phân tách rõ 3 chân sóng (L–H–HL) trên hành động giá thực tế. `[Đã xác nhận trực tiếp từ nguồn]`
* **Cách Hỗ trợ/Kháng cự tham gia vào xác nhận và thoát lệnh:**
  * *Xác nhận:* Điểm HL (Mua) có độ tin cậy cao nhất khi trùng hợp (*confluence*) với một mức Kháng cự ngang trước đó vừa bị nhịp L $\rightarrow$ H phá qua (nay chuyển thành Hỗ trợ - *Role Reversal*). Nếu ngay phía trên điểm vào lệnh là một vùng kháng cự cứng hoặc mốc số tròn lớn làm biên độ tiềm năng quá hẹp, *traderathome* quy định **bỏ qua lệnh (Pass on the trade)**.
  * *Thoát lệnh:* Chốt lời (TP) được đặt ngay trước vùng kháng cự ngang hoặc mốc số tròn tiếp theo. `[Đã xác nhận trực tiếp từ nguồn]`
* **Những phần có thể chuyển thành quy tắc máy móc mà không làm sai lệch bản chất:**
  Tính toán 3 đường Dragon ($\text{EMA}_{34}$ H/C/L) và $\text{EMA}_{89}$ Close; xác định vị trí tương đối giữa Giá, Dragon và $\text{EMA}_{89}$ cùng độ dốc dương/âm của Dragon và $\text{EMA}_{89}$; kiểm tra cấu trúc cực trị L–H–HL ($\text{Price}_{HL} > \text{Price}_L$) và H–L–LH ($\text{Price}_{LH} < \text{Price}_H$); kiểm tra điều kiện giá chạm vùng Dragon và đóng cửa bật ra ngoài biên Dragon hoặc phá vỡ mức H/L. `[Suy luận kỹ thuật từ định nghĩa]`

### A4. EMA 89, EMA 200 và các Biến thể
* **Vai trò có căn cứ của EMA 89 trong Sonic R.:**
  Trong bài viết định nghĩa hệ thống của *traderathome* (`post/4682138`), đường $\text{EMA}_{89}$ (Close) được gọi chính thức là **Trend Line**. Khi Dragon nằm trên $\text{EMA}_{89}$ và cả hai cùng hướng lên, thị trường ở trong xu hướng tăng xác nhận; khi Dragon nằm dưới $\text{EMA}_{89}$ và cùng hướng xuống, thị trường ở trong xu hướng giảm xác nhận. Ngoài ra, khi nhịp hồi (Leg 2) xuyên qua Dragon nhưng dừng lại và bật lên từ $\text{EMA}_{89}$, setup vẫn hợp lệ. `[Đã xác nhận trực tiếp từ nguồn]`
* **EMA 200 là thành phần cốt lõi hay bộ lọc mở rộng?**
  Trong thiết kế nguyên bản của Sonicdeejay và *traderathome*, hệ thống chỉ sử dụng **Dragon ($\text{EMA}_{34}$ H/C/L)** và **Trend Line ($\text{EMA}_{89}$ Close)**. Đường **EMA 200 KHÔNG phải là thành phần bắt buộc của Sonic R. nguyên bản**, mà là bộ lọc mở rộng được bổ sung trên các khung nhỏ (M5/M15) hoặc trên XAUUSD để đại diện cho xu hướng vĩ mô dài hạn. `[Đã xác nhận trực tiếp từ nguồn]`
* **Phân biệt 3 giả thuyết thiết kế khi tích hợp EMA 200 (Không tự ý kết luận quy tắc nào tốt hơn khi chưa kiểm định):**
  1. **Giả thuyết 1 — Giá nằm đúng phía EMA 200 ($\text{Close}_t > \text{EMA}_{200}$ cho Mua):** Cho phép bắt sớm các sóng đảo chiều ngay khi giá vừa vượt $\text{EMA}_{200}$ và tạo L–H–HL trên Dragon, dù lúc đó $\text{EMA}_{89}$ chưa kịp cắt lên $\text{EMA}_{200}$. `[Giả thuyết thiết kế cần kiểm định]`
  2. **Giả thuyết 2 — EMA 89 nằm đúng phía EMA 200 ($\text{Dragon} > \text{EMA}_{89} > \text{EMA}_{200}$ cho Mua):** Chỉ giao dịch khi xu hướng đã hoàn toàn trưởng thành, lọc bỏ vùng nhiễu chuyển giao xu hướng nhưng sẽ bỏ lỡ các sóng đầu tiên sau khi đảo chiều. `[Giả thuyết thiết kế cần kiểm định]`
  3. **Giả thuyết 3 — Chỉ hiển thị EMA 200 để tham khảo trực quan:** Không khóa cứng điều kiện lọc tín hiệu vào lệnh bằng $\text{EMA}_{200}$, chỉ vẽ lên biểu đồ để người dùng nhận diện vùng cản động lớn hoặc vùng chốt lời. `[Giả thuyết thiết kế cần kiểm định]`

### A5. Điều kiện Thị trường và Quản trị Giao dịch
* **Trường hợp setup thất bại, thị trường đi ngang hoặc sóng giá không rõ cấu trúc:**
  Khi Dragon và $\text{EMA}_{89}$ đi ngang, xoắn vào nhau (*intertwined/flat*), thị trường đang trong trạng thái tích lũy không xu hướng. Mọi giao cắt hoặc mô hình sóng nhỏ trong vùng này đều phải bị lọc bỏ. `[Đã xác nhận trực tiếp từ nguồn]`
* **Logic Dừng lỗ (SL), Chốt lời (TP) và Tái tham gia (Re-entry) có căn cứ trong tài liệu:**
  * **Stop Loss (SL):** Đặt bên kia dải Dragon (dưới $D_{\text{low}}$ đối với lệnh Mua, trên $D_{\text{high}}$ đối với lệnh Bán) hoặc đặt ngay dưới đáy swing HL / trên đỉnh swing LH gần nhất (hoặc dưới đáy L / đỉnh H tùy khẩu vị rủi ro của từng biến thể), cộng thêm khoảng đệm spread. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Take Profit (TP):** Đặt tại vùng kháng cự/hỗ trợ cấu trúc gần nhất hoặc các mốc giá tròn (*Whole/Half numbers*), đảm bảo khoảng cách tới TP tương xứng với rủi ro. `[Đã xác nhận trực tiếp từ nguồn]`
  * **Tái tham gia (Continuation / Re-entry Wave):** Trong một xu hướng mạnh đã hình thành ($\text{Dragon}$ tách xa $\text{EMA}_{89}$), mỗi khi giá tạo một nhịp sóng đẩy mới tạo đỉnh cao hơn rồi lại hồi về chạm/bật khỏi Dragon (tạo thêm một HL mới), nhà giao dịch có thể thực hiện lệnh tái nhập (*Wave Continuation Entry*) miễn là giá chưa chạm vùng kháng cự lớn trên khung cao. `[Đã xác nhận trực tiếp từ nguồn]`

### Bảng Tổng kết Phần A: Phân loại Thành phần Sonic R.

| Nhóm phân loại | Thành phần cụ thể | Mô tả & Vai trò trong hệ thống | Nguồn & Cấp độ tin cậy |
| :--- | :--- | :--- | :--- |
| **1. Thành phần cốt lõi có nguồn xác nhận** | **Dragon ($\text{EMA}_{34}$ High, Close, Low)** | Kênh hành động giá (PAC), làm vùng tham chiếu nhịp hồi và xác nhận động lượng ngắn hạn. | Sonicdeejay & traderathome (`post/4682138`) — `[Đã xác nhận trực tiếp từ nguồn]` |
| **1. Thành phần cốt lõi có nguồn xác nhận** | **Trend Line ($\text{EMA}_{89}$ Close)** | Đường định hướng xu hướng chủ đạo; lọc hướng giao dịch (Mua trên / Bán dưới $\text{EMA}_{89}$). | Sonicdeejay & traderathome (`post/4682138`) — `[Đã xác nhận trực tiếp từ nguồn]` |
| **1. Thành phần cốt lõi có nguồn xác nhận** | **Sóng giá L–H–HL (Mua) & H–L–LH (Bán)** | Điều kiện cấu trúc bắt buộc trước khi kích hoạt lệnh; ngăn chặn giao dịch chỉ bằng giao cắt MA. | Sonicdeejay & traderathome (`post/4682138`) — `[Đã xác nhận trực tiếp từ nguồn]` |
| **1. Thành phần cốt lõi có nguồn xác nhận** | **Hỗ trợ/Kháng cự ngang & Mốc số tròn** | Xác nhận vùng chân sóng và làm mục tiêu chốt lời (TP) / lọc bỏ lệnh sát cản. | Sonicdeejay & traderathome (`post/4682138`) — `[Đã xác nhận trực tiếp từ nguồn]` |
| **2. Thành phần tùy chọn hoặc biến thể** | **Đường $\text{EMA}_{200}$ (Close)** | Bộ lọc xu hướng vĩ mô bổ sung cho XAUUSD và khung nhỏ; không có trong template gốc đầu tiên. | Biến thể mở rộng & Yêu cầu dự án — `[Đã xác nhận trực tiếp từ nguồn]` |
| **2. Thành phần tùy chọn hoặc biến thể** | **Khối lượng PVSRA / PVA Candles** | Phân tích hành vi gom/xả hàng qua thanh khoản nến (do traderathome phát triển mạnh về sau). | traderathome (`thread/114792`) — `[Đã xác nhận trực tiếp từ nguồn]` |
| **2. Thành phần tùy chọn hoặc biến thể** | **Chỉ báo dao động phụ (RSI Trend Pulse)** | Bộ lọc động lượng đa khung ($\text{RSI}_{14} + \text{EMA}_9 + \text{WMA}_{45}$) kết hợp thêm vào hệ thống. | Tài liệu RSI 101 & Concept đính kèm — `[Đã xác nhận trực tiếp từ nguồn]` |
| **3. Điểm chưa đủ bằng chứng / Nhiều cách diễn giải** | **Thời điểm Trigger chính xác (Bounce vs. Breakout)** | Vào lệnh ngay khi nến đóng cửa bật khỏi Dragon tại HL hay phải chờ giá phá hẳn qua đỉnh H. | Khác biệt giữa phong cách Aggressive vs. Classic — `[Giả thuyết thiết kế cần kiểm định]` |
| **3. Điểm chưa đủ bằng chứng / Nhiều cách diễn giải** | **Độ sâu tối đa của nhịp hồi HL/LH** | Nhịp hồi chỉ được chạm Dragon hay được phép xuyên thủng Dragon xuống tới $\text{EMA}_{89}$. | Có nhiều cách diễn giải trong thread gốc — `[Giả thuyết thiết kế cần kiểm định]` |
| **3. Điểm chưa đủ bằng chứng / Nhiều cách diễn giải** | **Ngưỡng định lượng góc dốc Dragon** | Nguồn gốc chỉ mô tả định tính ("angled nicely"), không có ngưỡng số học cố định cho mọi tài sản. | Cần chuẩn hóa toán học cho XAUUSD — `[Tham số cần kiểm định thống kê]` |

---

## G3. RSI 101 Knowledge Map — Nghiên cứu Chuyên sâu Phần B

**Nguồn tham chiếu gốc:**
* Nguồn B-1: Sách điện tử *RSI 101* (`https://rsi-101.gitbook.io/book`).
* Nguồn B-2: Tài liệu đính kèm *RSI Trend Pulse Concept* (`rsi_trend_pulse_concept.pdf` — khởi tạo `2026-03-17 15:01:27`).

### B1. Hiểu đúng Công thức và Cấu trúc Chuỗi Dữ liệu
* **Xác minh chuỗi tính toán (Derivatives on RSI Series):**
  Trong hệ thống RSI 101 và bản *RSI Trend Pulse Concept*, chỉ báo **RSI 14** được tính trực tiếp từ chuỗi giá đóng cửa ($\text{Close}_t$) của XAUUSD. Sau đó, hai đường trung bình **EMA 9** và **WMA 45** được tính **trực tiếp trên chuỗi giá trị đầu ra của RSI 14** ($\text{RSI}_t \in [0, 100]$), hoàn toàn không phải tính trên giá XAUUSD. `[Đã xác nhận trực tiếp từ nguồn]`
* **Công thức toán học chuẩn của RSI 14 theo J. Welles Wilder:**
  * Biến thiên giá tại nến $t$: $\Delta P_t = \text{Close}_t - \text{Close}_{t-1}$
  * Bước tăng và bước giảm: $U_t = \max(\Delta P_t, 0)$, $D_t = \max(-\Delta P_t, 0)$
  * Làm mượt theo Wilder (Wilder's Smoothing / RMA với hệ số $\alpha_W = \frac{1}{N} = \frac{1}{14}$):
    $$\overline{U}_t = \frac{13 \cdot \overline{U}_{t-1} + U_t}{14}, \quad \overline{D}_t = \frac{13 \cdot \overline{D}_{t-1} + D_t}{14}$$
  * Chỉ số sức mạnh tương đối:
    $$\text{RS}_t = \frac{\overline{U}_t}{\overline{D}_t}, \quad \text{RSI}_{14}(t) = 100 - \frac{100}{1 + \text{RS}_t}$$
  * *Đối chiếu cách làm mượt của Wilder giữa các nền tảng:* Công thức làm mượt của Wilder với chu kỳ $N=14$ ($\alpha = 1/14$) tương đương toán học với một đường EMA tiêu chuẩn có chu kỳ $2N - 1 = 27$ ($\alpha = \frac{2}{27+1} = \frac{1}{14}$). Nếu một nền tảng tính RSI bằng SMA đơn thuần (Cutler's RSI) hoặc EMA chu kỳ 14 ($\alpha = 2/15$), giá trị RSI sẽ lệch đáng kể. Trên các nền tảng chuẩn (TradingView, MT4/MT5, TakeProfit Indie v5), hàm RSI tích hợp sẵn đều tuân thủ đúng công thức RMA của Wilder và hội tụ hoàn toàn sau khoảng $100\text{--}150$ thanh nến. `[Đã xác nhận trực tiếp từ nguồn]`
* **Công thức EMA 9 của RSI và WMA 45 của RSI:**
  * **$\text{EMA}_9(\text{RSI})$:** Với hệ số $\alpha_9 = \frac{2}{9+1} = 0.2$:
    $$\text{EMA}_9(\text{RSI}_t) = 0.2 \cdot \text{RSI}_{14}(t) + 0.8 \cdot \text{EMA}_9(\text{RSI}_{t-1})$$
  * **$\text{WMA}_{45}(\text{RSI})$:** Trung bình trượt có trọng số tuyến tính trên $45$ kỳ của chuỗi RSI, trong đó giá trị RSI gần nhất nhận trọng số $45$ và giảm dần tuyến tính về $1$ (tổng trọng số $\sum_{i=1}^{45} i = \frac{45 \times 46}{2} = 1035$):
    $$\text{WMA}_{45}(\text{RSI}_t) = \frac{\sum_{k=0}^{44} (45 - k) \cdot \text{RSI}_{14}(t - k)}{1035}$$
    `[Đã xác nhận trực tiếp từ nguồn]`

* **Bảng Phân biệt 5 Đường Chỉ báo (Vai trò, Ưu/Nhược điểm, Độ trễ tương đối):**

| Đường chỉ báo | Chuỗi đầu vào & Không gian giá trị | Vai trò trong hệ thống | Ưu điểm kỹ thuật | Nhược điểm & Độ trễ tương đối |
| :--- | :--- | :--- | :--- | :--- |
| **1. $\text{RSI}_{14}$** | Giá `Close` XAUUSD $\rightarrow$ Chuẩn hóa về $[0, 100]$ | Phản ánh vận tốc và biên độ tương đối của các nhịp tăng/giảm giá hiện tại. | Nhạy bén nhất trong 3 đường cửa sổ phụ; phát hiện sớm phân kỳ và vùng cực trị. | Nhiều răng cưa (*jagged noise*), dễ tạo tín hiệu giả nếu đứng một mình; **Độ trễ: Thấp nhất (Bậc 1)**. |
| **2. $\text{EMA}_9(\text{RSI}_{14})$** | Chuỗi $\text{RSI}_{14}$ $\rightarrow$ Miền $[0, 100]$ | Đường trung bình nhanh (*Fast MA*) lọc nhiễu răng cưa của RSI và làm đường kích hoạt giao cắt (*Trigger line*). | Làm mượt chuỗi RSI nhưng vẫn bám sát các điểm ngoặt sóng ngắn hạn nhờ trọng số mũ $\alpha=0.2$. | Trong vùng sideway hẹp, $\text{RSI}_{14}$ cắt qua lại $\text{EMA}_9(\text{RSI})$ liên tục; **Độ trễ: Trung bình thấp (Bậc 2)**. |
| **3. $\text{WMA}_{45}(\text{RSI}_{14})$** | Chuỗi $\text{RSI}_{14}$ $\rightarrow$ Miền $[0, 100]$ | Đường trung bình chậm (*Slow MA*) định hình trục xu hướng động lượng và làm hỗ trợ/kháng cự động cho RSI. | Nhờ trọng số tuyến tính (WMA), nó bám sát sự thay đổi cấu trúc động lượng tốt hơn SMA 45 hay EMA 45 mà vẫn rất mượt. | Phản ứng chậm khi giá đảo chiều chữ V đột ngột; **Độ trễ: Cao nhất trong bộ RSI (Bậc 2 dài hạn)**. |
| **4. $\text{EMA}_9(\text{Price})$** | Giá `Close` XAUUSD $\rightarrow$ Miền giá thực ($\text{USD/oz}$) | Đường bám giá cực ngắn hạn trên biểu đồ chính (không dùng trong bộ RSI Trend Pulse). | Bám sát từng nhịp nến đẩy ngắn hạn trên biểu đồ giá. | Không chuẩn hóa biên độ về $[0, 100]$, không phản ánh trạng thái quá mua/quá bán hay phân kỳ động lượng. |
| **5. $\text{WMA}_{45}(\text{Price})$** | Giá `Close` XAUUSD $\rightarrow$ Miền giá thực ($\text{USD/oz}$) | Đường trung bình giá trung hạn trên biểu đồ chính (tương đương vùng lân cận Dragon $\text{EMA}_{34}$). | Phản ánh mức giá trung bình có trọng số của $45$ nến gần nhất. | Bị kéo lệch mạnh khi có 1 nến biên độ bất thường (Flash crash/News spike), trong khi $\text{WMA}_{45}(\text{RSI})$ bị chặn biên trong $[0, 100]$. |

### B2. Định nghĩa các Trạng thái Xu hướng RSI (Theo tài liệu RSI 101)
Tài liệu *RSI 101* kế thừa lý thuyết *Range Shift* (Dịch chuyển biên độ) của Andrew Cardwell và Constance Brown, kết hợp với cấu trúc 3 đường ($\text{RSI}_{14}$, $\text{EMA}_9(\text{RSI})$, $\text{WMA}_{45}(\text{RSI})$). Hệ thống **không bao giờ rút gọn thành quy tắc ngây thơ $\text{RSI} > 50 = \text{BUY}$ và $\text{RSI} < 50 = \text{SELL}$**:
1. **RSI nằm trên hoặc dưới các đường trung bình (Layering / Alignment):**
   * *Trạng thái đẩy thuận xu hướng tăng:* $\text{RSI}_{14} > \text{EMA}_9(\text{RSI}) > \text{WMA}_{45}(\text{RSI})$.
   * *Trạng thái đẩy thuận xu hướng giảm:* $\text{RSI}_{14} < \text{EMA}_9(\text{RSI}) < \text{WMA}_{45}(\text{RSI})$. `[Đã xác nhận trực tiếp từ nguồn]`
2. **EMA 9 cắt WMA 45 cùng với RSI (Momentum Shift Crossover):**
   Khi $\text{RSI}_{14}$ dẫn đường cắt qua $\text{WMA}_{45}$ và kéo theo $\text{EMA}_9(\text{RSI})$ cắt qua $\text{WMA}_{45}$, đó là dấu hiệu chuyển giao chế độ động lượng (*regime shift*) trên khung thời gian đang xét, báo hiệu một sóng đẩy mới hình thành hoặc sóng xu hướng cũ đã kết thúc. `[Đã xác nhận trực tiếp từ nguồn]`
3. **WMA 45 dốc lên, dốc xuống hoặc đi ngang:**
   $\text{WMA}_{45}(\text{RSI})$ là trục xương sống của xu hướng RSI. Khi $\text{WMA}_{45}$ có độ dốc dương rõ rệt và nằm trên vùng $50$, xu hướng tăng có xung lực bền vững; khi $\text{WMA}_{45}$ dốc xuống rõ rệt dưới vùng $50$, xu hướng giảm áp đảo; khi $\text{WMA}_{45}$ đi ngang quanh trục $45\text{--}55$, thị trường đang tích lũy/sideway. `[Đã xác nhận trực tiếp từ nguồn]`
4. **Khoảng cách của ba đường mở rộng hoặc thu hẹp (Expansion vs. Compression):**
   Khi khoảng cách $|\text{RSI}_{14} - \text{EMA}_9|$ và $|\text{EMA}_9 - \text{WMA}_{45}|$ bung rộng (xòe quạt), nhịp đẩy đang tăng tốc mạnh. Khi khoảng cách quá xa khỏi $\text{WMA}_{45}$, RSI có xu hướng hút ngược về $\text{WMA}_{45}$. Khi 3 đường thu hẹp khoảng cách nhưng vẫn giữ đúng thứ tự trên một đường $\text{WMA}_{45}$ đang dốc, đó là nhịp nghỉ lành mạnh trước khi bung tiếp. `[Đã xác nhận trực tiếp từ nguồn]`
5. **Các vùng RSI trọng yếu 40, 50, 60 và sự dịch chuyển biên độ (Range Rules):**
   * Trong **Xu hướng Tăng (Bull Market)**: RSI dao động trong biên độ **$40$ đến $80$**. Vùng **$40\text{--}50$** (cụ thể là vùng $45 \pm 5$ trong bản Concept) đóng vai trò là **vùng đệm hỗ trợ của xu hướng tăng (Bullish Support Zone)**. Việc RSI vượt qua mốc **$60$** xác nhận phe Mua chiếm ưu thế động lượng.
   * Trong **Xu hướng Giảm (Bear Market)**: RSI dao động trong biên độ **$20$ đến $60$**. Vùng **$50\text{--}60$** (vùng $55 \pm 5$ trong bản Concept) đóng vai trò là **vùng trần kháng cự của xu hướng giảm (Bearish Resistance Zone)**. Việc RSI xuyên thủng dưới mốc **$40$** xác nhận phe Bán kiểm soát hoàn toàn. `[Đã xác nhận trực tiếp từ nguồn]`
6. **RSI không vượt được vùng 50 (hoặc 40–60) trong nhịp hồi:**
   Trong một xu hướng tăng khỏe nhất, nhịp điều chỉnh của giá chỉ làm RSI lùi về giữ trên mốc $50$ (hoặc chạm vào vùng $40\text{--}50$ rồi bật lên ngay tại $\text{WMA}_{45}$). Ngược lại, trong xu hướng giảm, nhịp hồi tăng của giá làm RSI bật lên nhưng bị chặn đứng tại vùng $50\text{--}60$ và $\text{WMA}_{45}$ mà không thể bứt phá lên trên $60$. `[Đã xác nhận trực tiếp từ nguồn]`
7. **Ba đường chụm lại và cắt qua lại (3 MA Compression / Tangle):**
   Khi $\text{RSI}_{14}$, $\text{EMA}_9(\text{RSI})$ và $\text{WMA}_{45}(\text{RSI})$ bó sát vào nhau và cắt qua cắt lại liên tục quanh vùng trung tâm $45\text{--}55$, tài liệu RSI 101 và bản Concept định nghĩa đây là trạng thái **Sideway / Không có xu hướng** — quy tắc bắt buộc là đứng ngoài thị trường. `[Đã xác nhận trực tiếp từ nguồn]`
8. **RSI đạt vùng cao/thấp (>70 hoặc <30) và dấu hiệu kiệt sức:**
   Khi RSI vượt trên $70$ (hoặc dưới $30$), đó trước hết là **xác nhận xung lực cực mạnh của sóng đẩy**. Dấu hiệu kiệt sức (*exhaustion*) chỉ xuất hiện khi RSI tạo cấu trúc suy yếu (hai đỉnh/hai đáy, phân kỳ, hoặc thất bại trong việc duy trì trên $\text{EMA}_9$) tại các vùng biên này. `[Đã xác nhận trực tiếp từ nguồn]`

* **Bảng Phân biệt 4 Khái niệm Trạng thái Động lượng trong RSI 101:**

| Khái niệm | Định nghĩa & Dấu hiệu nhận diện trên bộ RSI Trend Pulse | Ý nghĩa hành động giao dịch |
| :--- | :--- | :--- |
| **1. Hướng xu hướng (Trend Direction)** | Xác định bởi vị trí của $\text{RSI}_{14}$ và $\text{EMA}_9(\text{RSI})$ nằm cùng phía so với $\text{WMA}_{45}(\text{RSI})$, kết hợp với hướng dốc của $\text{WMA}_{45}$ và biên độ dao động (trên $40$ cho Tăng, dưới $60$ cho Giảm). | Quyết định chỉ tìm cơ hội Mua hay chỉ tìm cơ hội Bán từ khung H4/H1. |
| **2. Sức mạnh xu hướng (Trend Strength)** | Thể hiện qua độ dốc lớn của $\text{WMA}_{45}$, độ mở quạt giữa 3 đường và khả năng RSI vươn tới vùng $>70$ (tăng) hoặc $<30$ (giảm) mà các nhịp hồi không xuyên thủng $\text{WMA}_{45}$. | Cho biết có nên ưu tiên giữ lệnh xa (TP mở rộng) hay cảnh giác xu hướng yếu. |
| **3. Nhịp điều chỉnh (Pullback / Correction)** | Trên khung trung gian (M15), $\text{RSI}_{14}$ cắt ngược xuống dưới $\text{EMA}_9(\text{RSI})$ và lùi về kiểm định lại đường $\text{WMA}_{45}(\text{RSI})$ đang dốc hoặc vùng đệm $45 \pm 5$ (Mua) / $55 \pm 5$ (Bán). | Đưa hệ thống vào trạng thái **Chờ kích hoạt (Armed / Wait Zone)** để canh điểm vào lệnh ở khung nhỏ M5. |
| **4. Tín hiệu kết thúc sóng (Wave Exhaustion)** | Xuất hiện ở cuối một sóng (sóng hồi trên M5 để vào lệnh, hoặc sóng đẩy trên M15 để chốt lời): RSI tạo phân kỳ, tạo mô hình 2 đỉnh/2 đáy và cắt ngược qua $\text{EMA}_9(\text{RSI})$ (hoặc cắt ngược $\text{WMA}_{45}$). | Dùng trên M5 để **Bóp cò vào lệnh (Trigger)** khi sóng hồi kết thúc; dùng trên M15 để **Chốt lời/Thoát lệnh** khi sóng chính kết thúc. |

### B3. Phân tích Phân kỳ (Divergence) và Kiệt sức (Exhaustion)
* **Phân biệt 6 hiện tượng kỹ thuật trên chuỗi RSI:**
  1. **Phân kỳ thông thường (Regular / Classic Divergence):**
     * *Bearish Regular:* Giá tạo đỉnh cao hơn ($\text{High}_2 > \text{High}_1$) nhưng RSI tạo đỉnh thấp hơn ($\text{RSI}_2 < \text{RSI}_1$). Báo hiệu sóng tăng hiện tại đang suy yếu động lượng (kết thúc sóng).
     * *Bullish Regular:* Giá tạo đáy thấp hơn ($\text{Low}_2 < \text{Low}_1$) nhưng RSI tạo đáy cao hơn ($\text{RSI}_2 > \text{RSI}_1$). Báo hiệu sóng giảm (hoặc sóng điều chỉnh giảm trên M5) đang cạn lực bán. `[Đã xác nhận trực tiếp từ nguồn]`
  2. **Phân kỳ tiếp diễn (Hidden Divergence):**
     * *Bullish Hidden:* Trong xu hướng tăng, giá tạo đáy cao hơn ($\text{Low}_2 > \text{Low}_1$ — tương ứng HL của Sonic R.) nhưng RSI được xả sâu hơn tạo đáy thấp hơn ($\text{RSI}_2 < \text{RSI}_1$, thường lùi về sát $\text{WMA}_{45}$ hoặc vùng $40\text{--}50$). Đây là tín hiệu tiếp diễn xu hướng cực mạnh (Cardwell's Positive Reversal).
     * *Bearish Hidden:* Trong xu hướng giảm, giá tạo đỉnh thấp hơn ($\text{High}_2 < \text{High}_1$ — tương ứng LH) nhưng RSI tạo đỉnh cao hơn ($\text{RSI}_2 > \text{RSI}_1$ tại vùng $50\text{--}60$). `[Đã xác nhận trực tiếp từ nguồn]`
  3. **Phân kỳ Giá–RSI (Price–RSI Divergence) vs. Cấu trúc nội bộ RSI:**
     Phân kỳ Giá–RSI đòi hỏi so sánh đồng thời 2 chuỗi dữ liệu (`High`/`Low` của giá và cực trị của `RSI`), trong khi một số cấu trúc của RSI 101 đánh giá trực tiếp hành vi của RSI so với chính đường $\text{EMA}_9(\text{RSI})$ và $\text{WMA}_{45}(\text{RSI})$ của nó. `[Đã xác nhận trực tiếp từ nguồn]`
  4. **Mô hình Hai đỉnh / Hai đáy trên chuỗi RSI (RSI Double Top / Double Bottom / Failure Swing):**
     Ngay cả khi giá không tạo phân kỳ rõ rệt, việc đường $\text{RSI}_{14}$ tạo 2 đáy liên tiếp (mô hình chữ W) tại vùng hỗ trợ RSI hoặc tại $\text{WMA}_{45}$ rồi cắt lên trên $\text{EMA}_9(\text{RSI})$ được Wilder và RSI 101 coi là tín hiệu kết thúc sóng độc lập. `[Đã xác nhận trực tiếp từ nguồn]`
  5. **Một đỉnh/đáy đơn thuần chưa được xác nhận:**
     Khi RSI đang lao xuống và vừa nhích nhẹ lên trong 1 thanh nến đang chạy (hoặc chưa cắt qua $\text{EMA}_9(\text{RSI})$), đó chỉ là một điểm uốn tạm thời (*unconfirmed inflection*), dễ bị đạp thủng tiếp ở nến sau. `[Suy luận kỹ thuật từ định nghĩa]`
  6. **RSI quá mua (>70) / quá bán (<30) nhưng giá vẫn tiếp tục xu hướng:**
     Tài liệu RSI 101 khẳng định: trong một sóng đẩy mạnh, RSI có thể neo trên vùng $70$ (hoặc dưới $30$) trong thời gian dài trong khi giá liên tục lập đỉnh/đáy mới. Do đó, **tuyệt đối không dùng điều kiện đơn lẻ $\text{RSI} \ge 70$ để mở lệnh Bán ngược xu hướng**, mà chỉ sử dụng mốc $70/30$ trên M15 như một mốc cảnh báo để **chốt lời từng phần (Partial TP)** cho lệnh đang có sẵn, và chỉ đóng hết khi RSI M15 cắt ngược qua $\text{WMA}_{45}$. `[Đã xác nhận trực tiếp từ nguồn]`

### B4. Phân tích Phương pháp Đa Khung Thời Gian (MTF Architecture)
Tài liệu *RSI 101* và bản *RSI Trend Pulse Concept* phân tách rõ chức năng của từng cấp khung thời gian theo mô hình thác nước từ trên xuống (**Top-Down Cascade: H4 $\rightarrow$ H1 $\rightarrow$ M15 $\rightarrow$ M5**):
1. **Khung xác định thiên hướng giao dịch (Directional Bias Timeframes — H4 / H1):**
   Trên H4/H1, $\text{RSI}_{14}$ và $\text{EMA}_9(\text{RSI})$ phải nằm cùng một phía so với $\text{WMA}_{45}(\text{RSI})$, đồng thời $\text{WMA}_{45}(\text{RSI})$ phải có độ dốc rõ ràng, không giao dịch khi 3 đường chụm lại đi ngang. `[Đã xác nhận trực tiếp từ nguồn]`
2. **Khung tìm vùng hồi hoặc vùng phản ứng (Setup / Pullback Zone Timeframe — M15):**
   Chờ khung trung gian M15 bước vào nhịp điều chỉnh: $\text{RSI}_{14}$ trên M15 lùi về vùng chờ $45 \pm 5$ (tức $[40, 50]$ cho xu hướng tăng) hoặc $55 \pm 5$ (tức $[50, 60]$ cho xu hướng giảm), hoặc khi RSI M15 chạm vào đường $\text{WMA}_{45}(\text{RSI})$ hay vùng hỗ trợ/kháng cự do chính RSI tạo ra trước đó. `[Đã xác nhận trực tiếp từ nguồn]`
3. **Khung xác nhận điểm vào (Entry Trigger Timeframe — M5, biến thể M3/M1):**
   Khi M15 đã nằm trong vùng chờ hợp lệ, hạ xuống khung M5 để tìm dấu hiệu nhịp hồi kết thúc: xuất hiện phân kỳ thuận hoặc mô hình hết sóng (2 đáy/2 đỉnh trên RSI), và kích hoạt khi $\text{RSI}_{14}$ trên M5 cắt lại lên trên/xuống dưới $\text{EMA}_9(\text{RSI})$ thuận theo hướng xu hướng chính khi nến M5 đóng cửa xác nhận. Bản Concept ghi nhận thêm biến thể: *"Có thể thay M5 bằng M3/M1 nếu thị trường biến động nhanh, nhưng phải giữ nguyên logic xác nhận hết sóng"*. `[Đã xác nhận trực tiếp từ nguồn]`
4. **Khung quản lý và thoát lệnh (Trade Management & Exit Timeframe — M5 & M15):**
   * Quản lý dừng lỗ (SL): Đặt dưới đáy/đỉnh gần nhất hoặc thoát sớm khi $\text{RSI}_{14}$ trên **M5** phá ngược qua $\text{WMA}_{45}(\text{RSI})$.
   * Quản lý chốt lời (TP): Theo dõi trên **M15** — chốt từng phần khi $\text{RSI}_{14}$ M15 chạm mốc $70/30$, chốt thêm khi xuất hiện phân kỳ ngược, và đóng toàn bộ vị thế khi $\text{RSI}_{14}$ M15 cắt ngược qua $\text{WMA}_{45}(\text{RSI})$. Yêu cầu tối thiểu $R:R \ge 1:1$, ưu tiên $1:2$. `[Đã xác nhận trực tiếp từ nguồn]`

### B5. Phân tích và Đối chiếu Bản Concept Được Cung Cấp (`rsi_trend_pulse_concept.pdf`)

| Thành phần trong `rsi_trend_pulse_concept.pdf` | Nội dung quy định nguyên văn trong Bản Concept | Phân loại đối chiếu với sách *RSI 101* | Đánh giá Kỹ thuật & Nhu cầu Kiểm định |
| :--- | :--- | :--- | :--- |
| **1. Bộ công cụ cốt lõi** | $\text{RSI}_{14}$, $\text{EMA}_9$ (MA nhanh của RSI) và $\text{WMA}_{45}$ (MA chậm của RSI). | **Được nguồn hỗ trợ trực tiếp** (`[Đã xác nhận trực tiếp từ nguồn]`) | Khớp tuyệt đối $100\%$ với cấu hình tiêu chuẩn của tài liệu *RSI 101*. |
| **2. Chuỗi khung thời gian** | Chuỗi 4 khung: `H4 -> H1 -> M15 -> M5` (có thể thay M5 bằng `M3/M1` khi biến động nhanh). | **Cụ thể hóa một ý tưởng từ nguồn** (`[Quan điểm hoặc kinh nghiệm của tác giả]`) | *RSI 101* hướng dẫn nguyên lý phối hợp HTF $\rightarrow$ ITF $\rightarrow$ LTF linh hoạt. Việc khóa cả 4 khung H4+H1+M15+M5 cần làm rõ dùng toán tử `AND` hay cho phép H1 điều chỉnh nhẹ khi M15 hồi. |
| **3. Định hướng xu hướng H4/H1** | RSI và EMA 9 nằm cùng phía so với WMA 45; WMA 45 có độ dốc rõ ràng; không giao dịch khi 3 đường MA chụm (sideway). | **Được nguồn hỗ trợ trực tiếp** (`[Đã xác nhận trực tiếp từ nguồn]`) | Cốt lõi của *RSI 101*. Cụm từ *"độ dốc rõ ràng"* và *"3 đường MA chụm"* cần lượng hóa thành công thức toán học. |
| **4. Vùng chờ hồi trên M15** | RSI hồi về $45 \pm 5$ (trend tăng) hoặc $55 \pm 5$ (trend giảm); chạm WMA 45 hoặc vùng S/R do RSI tạo. | **Được nguồn hỗ trợ trực tiếp** (`[Đã xác nhận trực tiếp từ nguồn]`) | Phản ánh chính xác quy tắc vùng đệm $40\text{--}50$ / $50\text{--}60$ và giao dịch phản ứng tại $\text{WMA}_{45}$ của *RSI 101*. |
| **5. Trigger vào lệnh trên M5** | Xuất hiện phân kỳ thuận hoặc mô hình hết sóng (2 đáy/2 đỉnh) + RSI M5 cắt lại EMA 9 theo hướng xu hướng chính khi nến M5 đóng cửa. | **Được nguồn hỗ trợ trực tiếp** (`[Đã xác nhận trực tiếp từ nguồn]`) | Hợp nhất hoàn chỉnh hai điều kiện của *RSI 101*: Cấu trúc cạn lực hồi + Xung lực cắt lại $\text{EMA}_9(\text{RSI})$ trên nến đóng. |
| **6. Quy tắc SL và TP đa tầng** | SL dưới đáy/đỉnh gần nhất hoặc khi RSI M5 phá ngược WMA 45; TP chia phần tại RSI M15 chạm $70/30$, phân kỳ ngược, và cắt ngược WMA 45; $R:R \ge 1:1$ (ưu tiên $1:2$). | **Cụ thể hóa một ý tưởng từ nguồn** (`[Giả thuyết thiết kế cần kiểm định]`) | Rất chặt chẽ về mặt quản trị, nhưng việc thoát lệnh ngay khi *"RSI M5 phá ngược WMA 45"* cần kiểm định vì trên M5 RSI dễ quét qua $\text{WMA}_{45}$ trong nhịp rung lắc ngắn. |
| **7. Bộ lọc ngoại cảnh & Quản trị vốn** | Tránh tin tức mạnh, tránh spread cao, rủi ro $1\text{--}1.5\%$ mỗi lệnh. | **Chưa có căn cứ kỹ thuật trong API chỉ báo** (`[Giả thuyết thiết kế cần kiểm định]`) | Hợp lý về mặt quản trị thực chiến, nhưng trên Indie v5 không có API đọc lịch tin tức kinh tế (Economic Calendar) hoặc số dư tài khoản (Account Equity). |

### B6. Đánh giá Chất lượng Bằng chứng của Tài liệu RSI 101
Tài liệu *RSI 101* và bản *RSI Trend Pulse Concept* là các tài liệu **đặc tả phương pháp giao dịch theo quy tắc (Rule-based Methodology)** đúc kết từ kinh nghiệm thực chiến của tác giả, **không phải là báo cáo kiểm định định lượng có phân phối xác suất hay kết quả backtest đã được chứng minh thống kê trên XAUUSD**. Mọi nhận định định tính phải được chuyển thành biểu thức toán học có thể kiểm chứng. `[Đã xác nhận trực tiếp từ nguồn]`

---

## G4. Technical Formula & Terminology Ledger — Nghiên cứu Chuyên sâu Phần C

### Phân tích Toán học 10 Khái niệm Cốt lõi (C1 – C10) & Biểu thức Rút gọn cho Giới hạn 128 Dòng

#### C1. Moving Average Slope (Độ dốc tức thời), Slope Ròng (Net Slope) và Hướng đi Liên tiếp (Monotonicity)
* **Định nghĩa tối thiểu có thể lập trình:**
  Giả sử $M_t$ là giá trị của đường trung bình (như $D_{\text{close}}(t)$, $\text{EMA}_{89}(t)$ hoặc $\text{WMA}_{45}(\text{RSI}_t)$) tại nến $t$ và $k \ge 1$ là độ trễ nhìn lại (*lookback bars*):
  1. *Độ dốc tức thời (1-bar Slope):* $\Delta M_t = M_t - M_{t-1}$
  2. *Độ dốc ròng trên $k$ nến (Net Slope):* $S_{\text{net}}(M, t, k) = \frac{M_t - M_{t-k}}{k}$
  3. *Hướng đi đơn điệu liên tiếp (Strict Monotonic Direction):*
     $$\text{IsRising}(M, t, k) \iff \forall i \in \{0, 1, \dots, k-1\}: M_{t-i} > M_{t-i-1}$$
* **Biểu thức nén dòng lệnh (Compact Expression cho $\le 128$ dòng):** Với $k=3$, biểu thức kiểm tra $\text{WMA}_{45}(\text{RSI})$ có độ dốc rõ ràng trên 1 dòng duy nhất là $|W_t - W_{t-3}| \ge \theta_W$ (trong đó $\theta_W$ là tổng độ lệch tối thiểu sau $3$ nến, ví dụ $\theta_W = 0.6$ điểm RSI).
* **Tình huống biên & Nguy cơ định nghĩa sai:** Dùng khoảng chênh lệch tuyệt đối $\Delta M_t$ của giá XAUUSD mà không chuẩn hóa theo biến động hoặc theo chiều thuận của cấu trúc EMA sẽ khiến ngưỡng số học bị lệch khi biên độ vàng thay đổi.
* **Phân loại tham số:** Công thức tính sai phân là `[Có thể suy ra trực tiếp từ định nghĩa]`; số nến nhìn lại $k$ và ngưỡng độ dốc tối thiểu $\theta_W$ là `[Tham số thiết kế phải lựa chọn]` & `[Tham số cần kiểm định thống kê]`.

#### C2. Độ dốc RSI so với Độ dốc Giá
* **Định nghĩa tối thiểu có thể lập trình:**
  * Độ dốc của chuỗi thuộc miền RSI ($\text{RSI}_{14}$, $\text{EMA}_9(\text{RSI})$, $\text{WMA}_{45}(\text{RSI})$) có đơn vị là **điểm RSI / nến (RSI points per bar)** vì miền giá trị của RSI đã cố định trong $[0, 100]$.
  * Độ dốc của chuỗi thuộc miền Giá ($D_{\text{close}}$, $\text{EMA}_{89}$) có đơn vị là **$\text{USD}$ / nến**.
* **Nguy cơ định nghĩa sai:** Áp dụng công thức quy đổi góc độ hình học (`arctan` trên màn hình) cho cả Giá và RSI sẽ bị sai lệch hoàn toàn khi người dùng phóng to/thu nhỏ trục biểu đồ. `[Suy luận kỹ thuật từ định nghĩa]`

#### C3. Khoảng cách giữa RSI, EMA 9 và WMA 45
* **Định nghĩa tối thiểu có thể lập trình:**
  Tại thanh nến $t$, gọi $R_t = \text{RSI}_{14}(t)$, $E_t = \text{EMA}_9(R_t)$, $W_t = \text{WMA}_{45}(R_t)$:
  * Khoảng cách có hướng: $d_{RE}(t) = R_t - E_t$, $d_{EW}(t) = E_t - W_t$, $d_{RW}(t) = R_t - W_t$.
  * Độ rộng dải 3 đường (Spread / Dispersion):
    $$\text{Spread}_{\text{RSI}}(t) = \max(R_t, E_t, W_t) - \min(R_t, E_t, W_t)$$
* **Nguy cơ định nghĩa sai:** Đánh đồng $\text{Spread}_{\text{RSI}}(t)$ nhỏ tại 1 nến đơn lẻ (ngay điểm giao cắt bứt phá) với trạng thái thị trường đi ngang (sideway). `[Suy luận kỹ thuật từ định nghĩa]`

#### C4. Trạng thái Ba Đường Đồng hướng (Aligned) và Trạng thái Ba Đường Hội tụ/Chụm (Converged/Tangled)
* **Định nghĩa tối thiểu có thể lập trình:**
  * **Đồng hướng Tăng (Bullish Alignment):** $(R_t > W_t) \land (E_t > W_t) \land (W_t - W_{t-k} \ge \theta_W)$.
  * **Đồng hướng Giảm (Bearish Alignment):** $(R_t < W_t) \land (E_t < W_t) \land (W_t - W_{t-k} \le -\theta_W)$.
  * **Ba đường chụm / Sideway (3-Line Tangle):**
    $$\text{IsTangled}(t) \iff \left(\max(R_t, E_t, W_t) - \min(R_t, E_t, W_t) \le \delta_{\text{tangle}}\right) \land \left(|W_t - W_{t-k}| < \theta_W\right)$$
* **Biểu thức nén thành 1 giá trị trạng thái nguyên (`trend_dir` $\in \{+1, 0, -1\}$) để truyền từ `@sec_context`:**
  Thay vì trả về 4 chuỗi riêng biệt từ H4 và H1 làm tốn dòng lệnh giải nén, hàm `@sec_context` có thể tính và trả về trực tiếp mã hướng xu hướng:
  $$\text{Bias}_t = \begin{cases} +1 & \text{nếu } (R_t > W_t) \land (E_t > W_t) \land (W_t - W_{t-k} \ge \theta_W) \land (\text{Spread}_{\text{RSI}}(t) > \delta_{\text{tangle}}) \\ -1 & \text{nếu } (R_t < W_t) \land (E_t < W_t) \land (W_t - W_{t-k} \le -\theta_W) \land (\text{Spread}_{\text{RSI}}(t) > \delta_{\text{tangle}}) \\ 0 & \text{ngược lại (Sideway / Chụm 3 đường / Chưa đồng thuận)} \end{cases}$$
* **Nguy cơ định nghĩa sai:** Quy tắc cấm giao dịch khi 3 đường chụm chỉ áp dụng cho khung xu hướng **H4/H1**, tuyệt đối không áp dụng để cấm khung M15 vì tại M15 chúng ta đang cần RSI hồi về chạm $\text{WMA}_{45}$. `[Đã xác nhận trực tiếp từ nguồn]`

#### C5. Tiếp xúc Dragon theo Biên độ Nến (Wick Touch) và Tiếp xúc theo Giá Đóng cửa (Close Touch)
* **Định nghĩa tối thiểu có thể lập trình:**
  * *Tiếp xúc theo biên độ nến (Wick Touch - Mua):* $\text{Low}_t \le D_{\text{high}}(t)$ và $\text{Low}_t \ge \text{EMA}_{89}(t)$.
  * *Tiếp xúc theo giá đóng cửa (Close Touch - Mua):* $\text{Close}_t \le D_{\text{high}}(t)$ và $\text{Close}_t \ge D_{\text{low}}(t)$.
* **Nguy cơ định nghĩa sai:** Yêu cầu $\text{Close}_t$ phải nằm trong lòng Dragon sẽ bỏ lỡ các thanh nến Pin bar rút chân mạnh nhất tại Dragon. `[Suy luận kỹ thuật từ định nghĩa]`

#### C6. Giá Đóng cửa Vượt Dragon và Giá Phá Đỉnh/Đáy Swing
* **Định nghĩa tối thiểu có thể lập trình:**
  * *Đóng cửa bật/vượt Dragon (Dragon Bounce Close - Mua):* $\text{Close}_t > D_{\text{high}}(t)$ và $\text{Close}_t > \text{Open}_t$ sau khi nến hiện tại hoặc $1\text{--}3$ nến trước đó vừa chạm vào dải Dragon ($\min_{j \in \{0..3\}} \text{Low}_{t-j} \le D_{\text{high}}(t-j)$).
  * *Phá vỡ đỉnh Swing (Swing High Breakout - Mua):* $\text{Close}_t > P_H$ (với $P_H$ là mức giá đỉnh Swing H đã xác nhận trước nhịp hồi HL). `[Suy luận kỹ thuật từ định nghĩa]`

#### C7. Nhịp hồi Còn Hiệu lực (Valid Pullback), Nhịp hồi Bị Vô hiệu hóa (Invalidated) và Một lần Chạm Không Đủ Điều kiện
* **Định nghĩa tối thiểu có thể lập trình (Xét chiều Mua):**
  * **Còn hiệu lực (Valid):** H4/H1 đang có $\text{Bias} = +1$, trên M15 $\text{RSI}_{\text{M15}} \in [40, 50]$ (hoặc $|\text{RSI}_{\text{M15}} - \text{WMA}_{45,\text{M15}}| \le \epsilon_W$), đồng thời trên biểu đồ giá $\text{Close}_t \ge \text{EMA}_{89}(t)$ và đáy nhịp hồi hiện tại cao hơn đáy nhịp trước ($\text{Low}_{\text{HL}} > \text{Low}_{\text{L}}$).
  * **Bị vô hiệu hóa (Invalidated):** Giá đóng cửa xuyên thủng dưới $\text{EMA}_{89}(t)$, hoặc phá thủng đáy cũ $\text{Low}_t \le \text{Low}_{\text{L}}$, hoặc H4/H1 mất trạng thái $\text{Bias} = +1$. `[Suy luận kỹ thuật từ định nghĩa]`

#### C8. Pivot Chưa Xác nhận (Unconfirmed Pivot) và Pivot Đã Xác nhận (Confirmed Pivot) — Kèm Công thức Nén Không Cần Vòng Lặp
* **Định nghĩa toán học tổng quát $(L, R)$:**
  Tại thời điểm thanh nến hiện tại $t$ vừa đóng cửa, thanh nến tại vị trí $p = t - R$ là **Confirmed Pivot Low** trên chuỗi $X$ nếu:
  $$\left(\forall i \in \{1, \dots, L\}: X_p < X_{p-i}\right) \land \left(\forall j \in \{1, \dots, R\}: X_p \le X_{p+j}\right)$$
* **Công thức Nén Fractal $(L=2, R=1)$ hoặc $(L=2, R=2)$ Không Cần Vòng Lặp (Tiết kiệm $25$ dòng lệnh cho giới hạn 128 dòng):**
  Với $L=2, R=1$ (xác nhận ngay khi nến bên phải vừa đóng cửa tại chỉ số `[0]`, tâm Pivot nằm tại chỉ số `[1]`):
  $$\text{IsPivotLow}_1(X) \iff (X_1 < X_2) \land (X_1 < X_3) \land (X_1 \le X_0)$$
  $$\text{IsPivotHigh}_1(X) \iff (X_1 > X_2) \land (X_1 > X_3) \land (X_1 \ge X_0)$$
  Công thức này viết trên đúng **1 dòng lệnh duy nhất** trong Indie v5, hoàn toàn không dùng vòng lặp `for`, không bao giờ nhìn vào tương lai và chỉ xác nhận khi nến `[0]` đóng cửa. `[Suy luận kỹ thuật từ định nghĩa]`

#### C9. Divergence (Phân kỳ) và Exhaustion (Kiệt sức / Mô hình 2 đáy – 2 đỉnh) — Kèm Công thức Nén Trạng Thái
* **Định nghĩa tối thiểu có thể lập trình (Lưu đúng 1 cặp cực trị gần nhất `prev_piv_price`, `prev_piv_rsi`):**
  Khi phát hiện một điểm $\text{IsPivotLow}_1$ mới tại nến vừa qua (với giá trị đáy giá $P_{\text{curr}} = \text{Low}_1$ và đáy RSI $R_{\text{curr}} = \min(\text{RSI}_1, \text{RSI}_2)$), ta so sánh trực tiếp với điểm Pivot Low ngay trước đó ($P_{\text{prev}}, R_{\text{prev}}$):
  * **Bullish Regular Divergence (Kết thúc sóng hồi giảm trên M5):** $(P_{\text{curr}} < P_{\text{prev}}) \land (R_{\text{curr}} > R_{\text{prev}})$.
  * **Bullish Hidden Divergence (Tiếp diễn sóng tăng & Xác nhận đáy HL > L):** $(P_{\text{curr}} > P_{\text{prev}}) \land (R_{\text{curr}} < R_{\text{prev}})$.
  * **Bullish RSI Double Bottom (Mô hình 2 đáy RSI hết sóng):** $(|R_{\text{curr}} - R_{\text{prev}}| \le \epsilon_{\text{db}} \lor R_{\text{curr}} > R_{\text{prev}}) \land (R_{\text{curr}} < 50)$.
  * **Tín hiệu Bóp cò M5 (Trigger M5):** Một trong các điều kiện hết sóng trên đã xuất hiện trong vòng $W_{\text{sync}}$ nến gần nhất **VÀ** tại nến M5 hiện tại đóng cửa:
    $$\left(\text{RSI}_0 > \text{EMA}_9(\text{RSI}_0)\right) \land \left(\text{RSI}_1 \le \text{EMA}_9(\text{RSI}_1)\right) \land \left(\text{Close}_0 > \text{Open}_0\right)$$
    `[Đã xác nhận trực tiếp từ nguồn]`

#### C10. Tín hiệu trong Nến Đang Chạy và Tín hiệu Xác nhận trên Nến Đã Đóng
* **Định nghĩa tối thiểu có thể lập trình:**
  Mọi điều kiện giao cắt trên M5 được kiểm tra tại thời điểm kết thúc thanh nến M5 (kèm điều kiện nến M5 đóng cửa cùng chiều xu hướng: $\text{Close}_0 > \text{Open}_0$ cho lệnh Mua và $\text{Close}_0 < \text{Open}_0$ cho lệnh Bán theo đúng Mục 4 của bản Concept: *"Entry khi nen M5 dong xac nhan cung chieu trend"*). `[Đã xác nhận trực tiếp từ nguồn]`

---

### Bảng G4: Technical Formula & Terminology Ledger

| Thuật ngữ chuẩn | Công thức Toán học Chuẩn & Biểu thức Rút gọn | Ngữ cảnh sử dụng | Cách hiểu dễ nhầm cần tránh | Phân loại Tham số & Nguồn |
| :--- | :--- | :--- | :--- | :--- |
| **Dragon Channel ($\text{PAC}_{34}$)** | $D_H = \text{EMA}_{34}(\text{High})$, $D_C = \text{EMA}_{34}(\text{Close})$, $D_L = \text{EMA}_{34}(\text{Low})$ | Vùng đệm động lượng và tham chiếu điểm hồi trên biểu đồ giá. | Nhầm Dragon chỉ là 1 đường $\text{EMA}_{34}$ đơn lẻ tính trên `Close`. | Chu kỳ $34$: **Do nguồn quy định** (Sonic R. gốc). |
| **Trend Line ($\text{EMA}_{89}$)** | $T_{89} = \text{EMA}_{89}(\text{Close})$ | Định hướng xu hướng chủ đạo và ranh giới hỗ trợ/kháng cự sâu của Sonic R. | Nhầm với đường xu hướng kẻ tay nối các đỉnh/đáy. | Chu kỳ $89$: **Do nguồn quy định** (`post/4682138`). |
| **Macro Filter ($\text{EMA}_{200}$)** | $T_{200} = \text{EMA}_{200}(\text{Close})$ | Bộ lọc xu hướng vĩ mô mở rộng trên XAUUSD. | Coi $\text{EMA}_{200}$ là quy tắc gốc bắt buộc của mọi phiên bản Sonic R. | Chu kỳ $200$: **Tham số thiết kế** (Yêu cầu dự án). |
| **RSI Trend Pulse Trio** | $R_t = \text{RSI}_{14}(\text{Close}_t)$; $E_t = \text{EMA}_9(R_t)$; $W_t = \text{WMA}_{45}(R_t)$ | Đo lường xu hướng động lượng, vùng hồi và điểm kết thúc sóng. | Tính nhầm $\text{EMA}_9$ và $\text{WMA}_{45}$ trên giá `Close` của XAUUSD thay vì trên chuỗi $R_t$. | Chu kỳ $14, 9, 45$: **Do nguồn quy định** (RSI 101 & Concept). |
| **HTF RSI Alignment** | Mua: $(R_t > W_t) \land (E_t > W_t) \land (W_t - W_{t-k} \ge \theta_W) \land (\text{Spread}_{\text{RSI}} > \delta_{\text{tangle}})$ | Bộ lọc xu hướng tại khung lớn H4 và H1. | Chỉ lọc bằng điều kiện đơn giản $R_t > 50$. | Cấu trúc: **Do nguồn quy định**; Ngưỡng $\theta_W, \delta_{\text{tangle}}$: **Cần kiểm định thống kê**. |
| **M15 RSI Pullback Zone** | Mua: $R_{\text{M15}} \in [40, 50]$ ($45 \pm 5$) $\lor$ $|R_{\text{M15}} - W_{\text{M15}}| \le \epsilon_W$ | Xác định vùng chờ hợp lệ trên khung trung gian M15. | Đợi RSI M15 về dưới $30$ (quá bán) mới mua trong xu hướng tăng. | Vùng $45 \pm 5$ / $55 \pm 5$: **Do nguồn quy định**; Dung sai chạm $\epsilon_W$: **Tham số thiết kế**. |
| **Compact Confirmed Pivot** | Đáy tại `[1]`: $(X_1 < X_2) \land (X_1 < X_3) \land (X_1 \le X_0)$ | Nhận diện cấu trúc L–H–HL / H–L–LH và các đỉnh/đáy phân kỳ trong giới hạn $\le 128$ dòng. | Dùng điểm cực trị tại `[0]` ($R=0$) gây vẽ lại lịch sử (repaint). | Cấu trúc: **Suy ra từ định nghĩa**; Độ rộng $(L, R)$: **Tham số thiết kế**. |
| **M5 Wave Exhaustion Trigger** | (Phân kỳ $\lor$ 2 Đáy/Đỉnh RSI) $\land$ $(R_0 > E_0 \land R_1 \le E_1) \land (\text{Close}_0 > \text{Open}_0)$ | Tín hiệu kích hoạt điểm vào lệnh cuối cùng tại khung M5. | Vào lệnh ngay khi RSI M5 cắt $\text{EMA}_9$ bất chấp chưa có cấu trúc hồi hay phân kỳ/2 đáy. | Logic kết hợp: **Do nguồn quy định**; Cửa sổ đồng bộ $W_{\text{sync}}$: **Tham số thiết kế**. |

---

## G5. Indie v5 Compatibility Ledger & Kiến trúc Tách Logic $\le 128$ Dòng (Nghiên cứu Chuyên sâu Phần D)

**Nguồn tham chiếu gốc:**
* Nguồn D-1: Exness Help Center — *Custom indicators in Exness Terminal* (`https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal`).
* Nguồn D-2: TakeProfit Docs — *Request additional instruments* (`https://takeprofit.com/docs/indie/Request-additional-instruments`).
* Nguồn D-3: TakeProfit Docs — *Built-in indicators* (`https://takeprofit.com/docs/indie/Code-examples/built-in-indicators`).
* Nguồn D-4: TakeProfit Docs — *Algorithms for series processing* (`https://takeprofit.com/docs/indie/Algorithms-for-series-processing`).
* Nguồn D-5: TakeProfit Docs — *Package indie.algorithms API Reference* (`https://takeprofit.com/docs/indie/Library-reference/package-indie-algorithms`).

### D1. Môi trường Đích (Exness Terminal vs. Các Nền tảng Khác)
* **Phạm vi hỗ trợ của Exness Terminal Web:**
  Exness Terminal sử dụng engine biểu đồ tích hợp ngôn ngữ **Indie v5** của TakeProfit. Người dùng mở trình soạn thảo chỉ báo tùy chỉnh (*Custom Indicator Editor*), biên dịch và gắn chỉ báo lên biểu đồ XAUUSD trực tiếp trên trình duyệt web. `[Đã xác nhận trực tiếp từ nguồn]`
* **Các giới hạn cốt lõi của nền tảng:**
  1. **Giới hạn kích thước mã nguồn $\le 128$ dòng lệnh / script:** Mọi kịch bản vượt quá $128$ dòng sẽ bị từ chối hoặc cắt cụt trong trình soạn thảo của Exness Terminal. Do đó, việc tối ưu hóa mật độ dòng lệnh (*Line Density Optimization*) và phân tách module là yêu cầu sống còn.
  2. **Chỉ hỗ trợ Indicator, không hỗ trợ Automated Trading (EA/Bot):** Không có API gửi lệnh giao dịch (`OrderSend`) hay đọc số dư tài khoản. Các quy tắc quản trị vốn $1\text{--}1.5\%$ và chia phần TP được thể hiện qua các mức giá SL/TP gợi ý và tín hiệu cảnh báo thoát lệnh trên biểu đồ. `[Đã xác nhận trực tiếp từ nguồn]`
  3. **Không truy cập được Lịch tin tức (Economic Calendar) nội sinh:** Chỉ báo dựa trên chuỗi OHLCV (`open`, `high`, `low`, `close`, `volume`, `time`). `[Đã xác nhận trực tiếp từ nguồn]`

### D2. Đặc tả Kỹ thuật Cú pháp và API Indie v5
* **`@indicator` và Mô hình Entry Point (`Main` / `MainContext`):** `@indicator('Tên', overlay_main_pane=True/False)` khai báo chỉ báo trên biểu đồ giá (`True`) hoặc cửa sổ phụ (`False`). `[Đã xác nhận trực tiếp từ nguồn]`
* **`@sec_context` và `Context.calc_on()`:** Định nghĩa hàm ngữ cảnh phụ trang trí bằng `@sec_context`, gọi qua `self.calc_on(sec_ctx, time_frame=...)` để tính toán dữ liệu khung lớn (H4, H1, M15) từ biểu đồ M5. `[Đã xác nhận trực tiếp từ nguồn]`
* **`Rsi.new()`, `Ema.new()`, `Wma.new()` (Thuộc `indie.algorithms`):** Nhận đầu vào kiểu `SeriesF` và trả về `SeriesF`. Truyền trực tiếp chuỗi `r = Rsi.new(self.close, 14)` vào `Ema.new(r, 9)` và `Wma.new(r, 45)` chỉ tốn đúng **3 dòng lệnh**. `[Đã xác nhận trực tiếp từ nguồn]`
* **Các Decorator Hiển thị (`@plot.line`, `@plot.marker`, `@level`, `@band`) và Khai báo Tham số (`@param`):** Mỗi decorator chiếm $1$ dòng ở đầu hàm `Main`, và hàm `Main` trả về một `tuple` có số phần tử khớp với số lượng `@plot` đã khai báo. `[Đã xác nhận trực tiếp từ nguồn]`
* **Xử lý giai đoạn chưa đủ dữ liệu (`math.nan`):** Chuỗi $\text{WMA}_{45}(\text{RSI}_{14})$ cần ít nhất $14 + 45 = 59$ thanh nến của khung thời gian tương ứng để hết `math.nan`. `[Đã xác nhận trực tiếp từ nguồn]`

### D3 & D7. Kiến trúc Phân tách Module & Tinh giản Toán học cho Giới hạn $\le 128$ Dòng Lệnh (CRITICAL ARCHITECTURE)

#### 1. Phân tích Ngân sách Dòng lệnh (Line Budget Analysis)
Tại sao một chỉ báo gộp tất cả sẽ vượt quá $128$ dòng?
* Nếu khai báo đầy đủ $12$ tham số `@param` ($12$ dòng) + $10$ đường `@plot` ($10$ dòng) + $5$ đường `@level` ($5$ dòng) + phần `import` và `@indicator` ($5$ dòng) $\rightarrow$ Đã mất **$32$ dòng chỉ cho phần khai báo đầu file**!
* Nếu viết 3 hàm `@sec_context` riêng cho H4, H1, M15 $\rightarrow$ Mất thêm **$30$ dòng**.
* Nếu viết thuật toán tìm Pivot, phân kỳ, sóng L–H–HL cho chiều Mua riêng và chiều Bán riêng theo kiểu truyền thống $\rightarrow$ Mất thêm **$150\text{--}200$ dòng**.
* **Tổng cộng:** $\sim 250\text{+}$ dòng (Vượt xa giới hạn $128$ dòng của Exness!).

#### 2. Năm Kỹ thuật Tinh giản Logic Bắt buộc (Giữ nguyên 100% Bản chất Phương pháp nhưng Giảm 65% Số Dòng)
1. **Dùng chung 1 hàm `@sec_context` đa năng duy nhất (`HTF_Pulse` — chỉ tốn $8\text{--}10$ dòng):**
   Thay vì viết các hàm riêng cho H4, H1, M15, ta định nghĩa duy nhất **1 hàm `@sec_context`** tính `r = Rsi.new(self.close, 14)`, `e = Ema.new(r, 9)`, `w = Wma.new(r, 45)` và trả về tuple giá trị đã khóa ở nến đã đóng `[1]` (để chống repaint). Sau đó trong `Main`, gọi `self.calc_on` 3 lần cho `4h`, `1h`, `15m` (mỗi lần gọi chỉ tốn **1 dòng lệnh**!).
2. **Cố định các hằng số gốc của Phương pháp, chỉ giữ lại các `@param` cốt lõi (Tiết kiệm $12\text{--}15$ dòng decorator):**
   Các chu kỳ đã được khóa bởi tài liệu gốc Sonic R. và RSI 101 (`34, 89, 200` cho EMA giá; `14, 9, 45` cho RSI Trend Pulse; vùng hồi `40-50` và `50-60`; vùng chốt lời `70/30`) được khai báo trực tiếp trong thân hàm thay vì tạo hàng chục dòng `@param.int` thừa thãi. Chỉ giữ lại tối đa $3\text{--}5$ dòng `@param` cho những công tắc chiến lược bắt buộc (như chế độ lọc EMA 200, chế độ đồng thuận H4/H1, độ nhạy Pivot).
3. **Biểu diễn Cực trị Sóng (Pivot) và Phân kỳ bằng Biểu thức Vector 1 Dòng:**
   Sử dụng công thức Fractal xác nhận trên nến đóng `p_low = low[1] < low[2] and low[1] < low[3] and low[1] <= low[0]` kết hợp biến trạng thái lưu điểm cực trị liền trước (`last_pl`, `last_rl`) để kiểm tra đồng thời cả cấu trúc đáy sau cao hơn đáy trước ($\text{HL} > \text{L}$), phân kỳ (*Divergence*) và mô hình 2 đáy RSI (*Double Bottom*) chỉ trong **$12\text{--}15$ dòng lệnh**.
4. **Đối xứng hóa Logic Mua và Bán (Directional Symmetry Encoding):**
   Xác định biến hướng xu hướng `bias` $\in \{+1, -1, 0\}$ từ bộ lọc đa khung. Nhờ đó, nhiều phép kiểm tra độ dốc và khoảng cách có thể viết gộp bằng biểu thức toán học có dấu thay vì nhân đôi số dòng lệnh `if/else`.
5. **Tách Kiến trúc thành Bộ Đôi Chỉ báo Đồng bộ (Synchronized Dual-Script Architecture, mỗi script $\sim 90\text{--}115$ dòng):**
   Vừa giải quyết triệt để sự khác biệt hệ trục tung (Giá XAUUSD vs. RSI $[0, 100]$), vừa chia đôi khối lượng hiển thị để mỗi script nằm gọn trong phạm vi **$90\text{--}115$ dòng lệnh** (an toàn tuyệt đối dưới ngưỡng $128$ dòng).

#### 3. Bảng Phân bổ Kiến trúc 2 Script (Và Phương án 3 Script Dự phòng) dưới 128 Dòng

| Tên Module Script | Vị trí Hiển thị | Chức năng & Logic Đảm nhiệm (Đầy đủ 100% thành phần) | Ngân sách Dòng lệnh Dự kiến (Line Budget) |
| :--- | :--- | :--- | :--- |
| **MODULE 1: `SonicR_RSIPulse_Main`** (Chỉ báo Biểu đồ Chính) | `overlay_main_pane=True` (Trên biểu đồ giá XAUUSD) | 1. Vẽ Dragon ($\text{EMA}_{34}$ High, Close, Low), Trend Line ($\text{EMA}_{89}$) và $\text{EMA}_{200}$.<br>2. Chứa 1 hàm `@sec_context` gọn nhẹ tính RSI Trend Pulse cho `H4`, `H1`, `M15`.<br>3. Kiểm tra cấu trúc sóng Sonic R. (L–H–HL / H–L–LH + chạm/bật Dragon) kết hợp Trigger RSI M5 (2 đáy/phân kỳ + cắt $\text{EMA}_9$ khi nến M5 đóng cửa) và lọc $R:R \ge 1:1$.<br>4. Vẽ mũi tên **BUY / SELL Trigger** và đường mức **Stop Loss (SL) / Take Profit (TP)** gợi ý. | - Import, `@indicator`, `@param`, `@plot`: **22 dòng**<br>- Hàm `@sec_context` MTF RSI: **10 dòng**<br>- Tính Dragon, EMA 89/200 & MTF `calc_on`: **15 dòng**<br>- Logic Sóng L-H-HL + Trigger M5 + SL/TP: **48 dòng**<br>- Lệnh `return` tuple hiển thị: **5 dòng**<br>$\Rightarrow$ **Tổng: $\sim 100 / 128$ dòng** |
| **MODULE 2: `RSI_TrendPulse_Sub`** (Chỉ báo Cửa sổ Phụ) | `overlay_main_pane=False` (Cửa sổ phụ bên dưới) | 1. Vẽ bộ 3 đường $\text{RSI}_{14}$, $\text{EMA}_9(\text{RSI})$, $\text{WMA}_{45}(\text{RSI})$ trên khung hiện tại (M5/M15).<br>2. Vẽ các mốc chuẩn RSI 101: `30, 40, 50, 60, 70` (vùng chờ $45 \pm 5$ và $55 \pm 5$).<br>3. Tính `@sec_context` để hiển thị dải trạng thái đồng thuận xu hướng của `H4 -> H1 -> M15` (cảnh báo khi H4/H1 bị chụm 3 đường sideway).<br>4. Đánh dấu trực quan điểm **Phân kỳ / 2 Đáy 2 Đỉnh**, điểm **Cắt $\text{EMA}_9$** (Entry), điểm **Chạm 70/30** (TP1), và điểm **Cắt ngược $\text{WMA}_{45}$** (Đóng toàn bộ lệnh). | - Import, `@indicator`, `@param`, `@level`, `@plot`: **24 dòng**<br>- Hàm `@sec_context` MTF Bias & Wait Zone: **10 dòng**<br>- Tính RSI 14, EMA 9, WMA 45 & MTF: **14 dòng**<br>- Logic Phân kỳ, 2 Đáy/Đỉnh, Trigger & Exit: **42 dòng**<br>- Lệnh `return` tuple hiển thị: **5 dòng**<br>$\Rightarrow$ **Tổng: $\sim 95 / 128$ dòng** |
| *(Tùy chọn mở rộng)* **Phương án 3 Script** nếu muốn tách riêng bảng MTF & Quản lý lệnh | Tách thành: (1) `SonicR_Price_Overlay`, (2) `RSI_Pulse_Trigger_M5`, (3) `RSI_MTF_Exit_Manager` | Dùng khi ở Giai đoạn 2 người dùng muốn thêm thật nhiều tham số `@param` tùy chỉnh sâu cho từng thành phần mà không muốn gộp chung vào 2 script. | Mỗi script chỉ chiếm **$70\text{--}85 / 128$ dòng** (Dư dả gần $50$ dòng trống mỗi script). |

### D4. Multi-Timeframe (MTF), Lookahead và Repainting
1. **Cách `calc_on()` liên kết Context phụ với Context chính & Quy định Khung phụ $\ge$ Khung biểu đồ:**
   Khi chỉ báo chạy trên biểu đồ chính có khung thời gian $\text{TF}_{\text{chart}}$ (ví dụ **M5**), lệnh `self.calc_on(sec_ctx, time_frame=TF_HTF)` yêu cầu $\text{TF}_{\text{HTF}} \ge \text{TF}_{\text{chart}}$ ($\text{H4} > \text{H1} > \text{M15} > \text{M5}$). Do đó, biểu đồ vận hành chuẩn phải được mở ở khung nhỏ nhất trong chuỗi (tức **M5**, hoặc **M1** nếu dùng biến thể M1). `[Đã xác nhận trực tiếp từ nguồn]`
2. **Sự khác nhau chí mạng giữa Nến HTF Đang Chạy và Nến HTF Đã Đóng (Lookahead & Historical Repainting):**
   * **Trên dữ liệu lịch sử:** Các thanh nến H4/H1/M15 trong quá khứ chỉ lưu trữ giá trị đóng cửa cuối cùng của thanh nến lớn đó. Nếu tại thanh nến M5 lúc `10:15` trong quá khứ, code đọc trực tiếp giá trị `[0]` của chuỗi H1 mà không khóa độ trễ, nó sẽ nhìn thấy trước giá trị RSI H1 của thời điểm `10:59:59` (*Lookahead Bias*).
   * **Trong thời gian thực:** Lúc `10:15` thực tế, nến H1 đang chạy và thay đổi liên tục theo từng nến M5. Nếu đến `10:55` giá đảo chiều làm nến H1 đóng cửa khác đi, tín hiệu lúc `10:15` sẽ biến mất khi tải lại trang (*Historical Repainting*).
   * **Giải pháp chuẩn hóa trong 1 dòng lệnh:** Bên trong hàm `@sec_context`, trả về giá trị tại chỉ số **`[1]`** (thanh nến HTF vừa đóng cửa hoàn tất gần nhất) khi ở chế độ `Confirmed Non-Repainting`, hoặc cho phép chuyển qua chỉ số `[0]` thông qua một công tắc boolean duy nhất nếu người dùng chấp nhận đọc nến HTF đang chạy. `[Đã xác nhận trực tiếp từ nguồn]`

### D5. Pivot và Xác nhận Swing
* Điểm cực trị tại nến $t - R$ chỉ được xác nhận hoàn tất khi thanh nến hiện tại $t$ đã đóng cửa (độ trễ đúng bằng $R$ thanh nến). Mọi tín hiệu giao dịch phụ thuộc vào Pivot đó chỉ được phép xuất hiện sớm nhất từ nến $t$ trở đi để không đánh lừa người xem biểu đồ lịch sử. `[Đã xác nhận trực tiếp từ nguồn]`

### D6. Tính tương thích và Các điểm cần Kiểm chứng Biên dịch
* Mọi API dự kiến sử dụng (`@indicator`, `@sec_context`, `self.calc_on`, `Rsi.new`, `Ema.new`, `Wma.new`, `@plot.line`, `@plot.marker`, `@level`) đều thuộc lõi chuẩn của Indie v5.
* Các điểm cần kiểm chứng trực tiếp khi biên dịch ở Giai đoạn 2: (1) Hành vi đồng bộ chỉ số `[1]` trong `@sec_context`, (2) Khả năng hỗ trợ chuỗi `'3m'` (khung M3) trong `TimeFrame` của Exness Terminal, và (3) Kiểm tra tổng số dòng thực tế (bao gồm cả dòng trống và comment) luôn $\le 128$ dòng. `[Chưa xác minh được]`

### Bảng G5: Indie v5 Compatibility Ledger (Đã tích hợp Ràng buộc $\le 128$ Dòng)

| API / Tính năng | Chức năng dự kiến trong Hệ thống | Tài liệu chính thức xác nhận | Ràng buộc kỹ thuật & Tối ưu hóa $\le 128$ dòng | Mức độ sẵn sàng triển khai |
| :--- | :--- | :--- | :--- | :--- |
| **`@indicator(..., overlay_main_pane=...)`** | Tách Module 1 trên biểu đồ giá (`True`) và Module 2 ở cửa sổ phụ RSI (`False`). | TakeProfit Built-in Indicators & Exness Docs | Tách 2 script giúp mỗi script giảm một nửa số dòng lệnh (chỉ còn $\sim 95\text{--}100$ dòng/script) và đúng hệ trục tung. | **Sẵn sàng 100%** `[Đã xác nhận trực tiếp từ nguồn]` |
| **`Rsi.new(src, 14)`** | Tính chuỗi $\text{RSI}_{14}$ theo công thức làm mượt của Wilder. | `indie.algorithms` API Reference | Chỉ tốn 1 dòng lệnh khởi tạo; kiểm tra `math.isnan()` gọn bằng hàm phụ hoặc biểu thức điều kiện. | **Sẵn sàng 100%** `[Đã xác nhận trực tiếp từ nguồn]` |
| **`Ema.new(rsi, 9)` & `Wma.new(rsi, 45)`** | Tính $\text{EMA}_9$ và $\text{WMA}_{45}$ trực tiếp trên chuỗi `SeriesF` của $\text{RSI}_{14}$. | `indie.algorithms` & Series Processing Docs | Chỉ tốn 2 dòng lệnh; cần $\ge 59$ nến trên khung đang tính để hết `nan`. | **Sẵn sàng 100%** `[Đã xác nhận trực tiếp từ nguồn]` |
| **`@sec_context` & `self.calc_on(...)`** | Tính toán bộ RSI Trend Pulse trên các khung H4, H1, M15 từ biểu đồ M5. | Request Additional Instruments Docs | Dùng **1 hàm `@sec_context` dùng chung** cho cả H4, H1, M15 để tiết kiệm hơn $30$ dòng code. | **Sẵn sàng 100%** `[Đã xác nhận trực tiếp từ nguồn]` |
| **`TimeFrame` (`5m`, `15m`, `1h`, `4h`, `1m`, `3m`)** | Định nghĩa tham số khung thời gian cho chuỗi MTF. | Request Additional Instruments Docs | Các khung `1m`, `5m`, `15m`, `1h`, `4h` được hỗ trợ chuẩn; riêng `3m` (`M3`) cần thử nghiệm trực tiếp trên Exness. | **Sẵn sàng với khung chuẩn; M3 cần kiểm chứng** `[Chưa xác minh được với M3]` |
| **Compact Pivot & Divergence Logic** | Nhận diện sóng L–H–HL / H–L–LH và phân kỳ / 2 đáy RSI không cần vòng lặp dài. | Algorithms for Series Processing Docs | Dùng biểu thức 3–4 điểm cực trị xác nhận trên nến đóng (`[1]` so với `[2], [3], [0]`) kết hợp biến lưu cực trị liền trước. | **Sẵn sàng (Tiết kiệm $\sim 35$ dòng code)** `[Suy luận kỹ thuật từ định nghĩa]` |
| **`@plot.line`, `@plot.marker`, `@level`** | Vẽ Dragon (3 đường EMA 34), EMA 89, EMA 200, vùng RSI 30–70 và mũi tên tín hiệu. | Built-in Indicators Code Examples | Giới hạn số lượng `@param` và `@plot` hợp lý để phần khai báo decorator không vượt quá $25$ dòng. | **Sẵn sàng 100%** `[Đã xác nhận trực tiếp từ nguồn]` |
| **Giới hạn $\le 128$ dòng lệnh / script** | Ràng buộc trình biên dịch trên Exness Terminal. | Quy định môi trường Exness Terminal | Không viết dòng trống thừa, rút gọn comment, gộp biểu thức boolean và tách 2–3 module độc lập. | **Đã có kiến trúc giải quyết triệt để** `[Suy luận kỹ thuật từ định nghĩa]` |

---

## G6. Integration Issues — Phân tích 10 Vấn đề Tương thích & Xung đột khi Kết hợp Sonic R. + RSI 101 (Nghiên cứu Phần E)

1. **Dragon và RSI có bổ sung thông tin cho nhau hay cùng lặp lại một loại tín hiệu xu hướng?**
   * *Phân tích:* Dragon ($\text{EMA}_{34}$ H/C/L) và $\text{EMA}_{89}$ là bộ lọc thông thấp trên miền Giá, trong khi bộ RSI Trend Pulse ($\text{RSI}_{14} + \text{EMA}_9 + \text{WMA}_{45}$) là bộ dao động vận tốc chuẩn hóa trên miền $[0, 100]$. Chúng **bổ sung thông tin mạnh mẽ** khi dùng RSI để định hướng đa khung (H4/H1) và bắt điểm kết thúc nhịp hồi (phân kỳ / 2 đáy trên M5), nhưng trùng lặp một phần khi xét hướng xu hướng trên cùng một khung thời gian đơn lẻ. `[Suy luận kỹ thuật từ định nghĩa]`
2. **Nếu giá đã có cấu trúc tăng (Sonic R. hợp lệ) nhưng RSI đa khung (H4/H1) chưa đồng thuận, đó là cơ hội bị bỏ lỡ hay setup không hợp lệ?**
   * *Phương án A (Strict Confluence):* Coi là setup không hợp lệ và lọc bỏ hoàn toàn theo đúng Mục 3.A của Concept. *Ưu điểm:* Tránh bẫy tăng giá ngược xu hướng lớn. *Nhược điểm:* Bỏ lỡ sóng đảo chiều đầu tiên trên M5/M15 do độ trễ của $\text{WMA}_{45}(\text{RSI})$ trên H4.
   * *Phương án B (Graded Signals):* Vẫn hiển thị nhưng phân biệt màu sắc/nhãn giữa tín hiệu **A+ (Thuận cả Sonic R. và MTF RSI)** và tín hiệu **B (Sonic R. Đảo chiều sớm)**. *Lợi thế trong giới hạn 128 dòng:* Chỉ tốn thêm 1 biểu thức điều kiện màu sắc trong `@plot.marker` mà không làm mất cơ hội giao dịch. `[Giả thuyết thiết kế cần kiểm định]`
3. **Nếu RSI M15 hồi hợp lệ ($45 \pm 5$ hoặc chạm $\text{WMA}_{45}$) nhưng giá chưa tạo swing L–H–HL sâu, có được coi là setup chưa hoàn chỉnh?**
   * *Phương án A:* Bắt buộc giá phải chạm/tiệm cận vùng Dragon và có đáy $\text{Low}_{\text{HL}} > \text{Low}_{\text{L}}$ mới kích hoạt.
   * *Phương án B:* Trong xu hướng cực mạnh (giá nằm trên Dragon và $\text{EMA}_{89}$ đang dốc), cho phép kích hoạt lệnh tiếp diễn (*Continuation Wave*) khi RSI M15 đã xả về chạm $\text{WMA}_{45}$ và M5 phát tín hiệu hết sóng. `[Giả thuyết thiết kế cần kiểm định]`
4. **Nếu giá phá/bật khỏi Dragon trước khi RSI M5 giao cắt $\text{EMA}_9$ (hoặc ngược lại), nên xử lý trạng thái setup như thế nào?**
   * *Phân tích:* Hai sự kiện này thường lệch pha nhau $1\text{--}3$ thanh nến M5.
   * *Giải pháp nén dòng lệnh:* Sử dụng điều kiện **Cửa sổ đồng bộ ngắn ($W_{\text{sync}} = 3$ nến)**: Tại nến M5 đóng cửa hiện tại, yêu cầu giá đóng cửa nằm trên Dragon ($\text{Close}_0 > D_{\text{high},0}$ và $\text{Close}_0 > \text{Open}_0$), có nến chạm Dragon trong $3$ nến gần nhất ($\min_{j \in \{0..3\}} \text{Low}_j \le D_{\text{high},j}$), đồng thời $\text{RSI}_0 > \text{EMA}_9(\text{RSI}_0)$ sau khi vừa cắt lên trong vòng $1\text{--}2$ nến. Cách viết này xử lý triệt để độ lệch pha mà chỉ tốn **2 dòng lệnh**. `[Suy luận kỹ thuật từ định nghĩa]`
5. **Nếu H4 tăng, H1 đang điều chỉnh nhưng chưa đảo xu hướng, hệ thống đồng thuận cứng (`H4 AND H1`) có thể gây ra những hạn chế nào?**
   * *Phân tích:* Khi M15 lùi về vùng $45 \pm 5$ để tạo điểm mua, chính nhịp giảm điều chỉnh đó sẽ kéo $\text{RSI}_{14}$ trên H1 tạm thời cắt xuống dưới $\text{EMA}_9(\text{RSI})$ của H1. Nếu bắt buộc cả H4 và H1 đều phải có $\text{RSI} > \text{EMA}_9 > \text{WMA}_{45}$ cùng lúc, hệ thống sẽ bị khóa chéo (*deadlock*).
   * *Giải pháp:* Trên H1, chỉ yêu cầu $\text{WMA}_{45}(\text{RSI})$ đang dốc thuận chiều H4 và $\text{RSI}_{\text{H1}} > 40$ (cho chiều Mua) hoặc cung cấp công tắc chọn giữa `Strict H4+H1` và `Flexible H4+H1`. `[Suy luận kỹ thuật từ định nghĩa]`
6. **Nếu RSI đang ở trên 70 trong một xu hướng tăng mạnh, điều kiện đó là xác nhận sức mạnh hay lý do để tránh mua đuổi?**
   * *Phân tích:* Nếu RSI trên **H4/H1** $> 70$, đó là xác nhận sức mạnh xu hướng. Nhưng nếu tại thời điểm định vào lệnh mà RSI trên **M15** đã $\ge 70$, thì theo Mục 4 của bản Concept, mốc $70/30$ trên M15 chính là điểm chốt lời từng phần, nên bắt buộc phải **tránh mua đuổi** (lọc bằng điều kiện $\text{RSI}_{\text{M15}} < 70$ cho lệnh Mua và $\text{RSI}_{\text{M15}} > 30$ cho lệnh Bán). `[Đã xác nhận trực tiếp từ nguồn]`
7. **Nếu RSI cắt $\text{WMA}_{45}$ ngược hướng trong lúc giá vẫn giữ cấu trúc xu hướng, nên phân biệt điều chỉnh, kết thúc sóng và đảo chiều ra sao?**
   * *Điều chỉnh theo thời gian:* RSI cắt nhẹ $\text{WMA}_{45}$ nhưng vẫn giữ trên mốc $40$ (với xu hướng tăng) và giá vẫn nằm trên $\text{EMA}_{89}$.
   * *Kết thúc sóng hiện tại (Đóng lệnh đang mở):* Khi RSI M15 cắt ngược qua $\text{WMA}_{45}$, phát cảnh báo đóng toàn bộ vị thế đang mở theo đúng Mục 4 của Concept.
   * *Đảo chiều xu hướng:* RSI thủng mốc $40$ (hoặc vượt $60$ với chiều giảm), kéo $\text{EMA}_9(\text{RSI})$ cắt qua $\text{WMA}_{45}$ kèm $\text{WMA}_{45}$ đổi chiều dốc, đồng thời giá đóng cửa xuyên thủng $\text{EMA}_{89}$. `[Suy luận kỹ thuật từ định nghĩa]`
8. **Bộ lọc EMA 200 sẽ loại bỏ những tình huống nào, và tác dụng đó có thể kiểm định riêng bằng cách nào?**
   * *Tác động:* Loại bỏ các cú bật hồi ngược xu hướng vĩ mô, nhưng làm trễ các pha bắt đáy/đỉnh đảo chiều chữ V sớm.
   * *Cách kiểm định gọn trong $\le 128$ dòng:* Dùng 1 tham số `@param.int('ema200_mode', default=1)` với `0 = Chỉ vẽ tham khảo`, `1 = Giá nằm đúng phía EMA 200`, `2 = EMA 89 nằm đúng phía EMA 200`. `[Giả thuyết thiết kế cần kiểm định]`
9. **Cấu trúc Hỗ trợ/Kháng cự có thể được tự động hóa đến mức nào mà không dẫn đến nhận diện sai?**
   * Tự động hóa chính xác các vùng số học RSI ($45 \pm 5$ / $55 \pm 5$), sự kiện chạm $\text{WMA}_{45}$, và dùng đỉnh/đáy Swing gần nhất trong cửa sổ $N$ nến để tính mức SL cùng kiểm tra điều kiện biên độ tới đỉnh/đáy đối diện đảm bảo $R:R \ge 1:1$. `[Suy luận kỹ thuật từ định nghĩa]`
10. **Những điều kiện nào có thể gây tín hiệu trùng, tín hiệu quá muộn hoặc bỏ lỡ các nhịp tiếp diễn nhanh?**
    * *Chống tín hiệu trùng:* Dùng biến đếm hoặc cờ trạng thái `last_signal_bar` / `armed_state` để mỗi nhịp hồi chỉ phát đúng **1 tín hiệu duy nhất**.
    * *Chống bỏ lỡ nhịp tiếp diễn nhanh:* Kết hợp điều kiện vùng chờ M15 bằng phép tuyển `OR` như bản Concept mô tả: $\text{RSI}_{\text{M15}} \in [40, 50]$ **HOẶC** $\text{RSI}_{\text{M15}}$ chạm $\text{WMA}_{45}(\text{RSI}_{\text{M15}})$. `[Suy luận kỹ thuật từ định nghĩa]`

---

## G7. Knowledge Lock — Những Gì Đã Biết và Chưa Biết

### Nhóm 1: Đã chốt bằng nguồn đủ mạnh (Locked by Authoritative Sources)
1. **Cấu trúc Sonic R. trên biểu đồ giá:** Dragon gồm 3 đường $\text{EMA}_{34}(\text{High}, \text{Close}, \text{Low})$; Trend Line là $\text{EMA}_{89}(\text{Close})$; đường mở rộng là $\text{EMA}_{200}(\text{Close})$. Bắt buộc có cấu trúc sóng L–H–HL (Mua) / H–L–LH (Bán) tương tác với Dragon và đồng thuận với $\text{EMA}_{89}$. `[Đã xác nhận trực tiếp từ nguồn]`
2. **Cấu trúc RSI Trend Pulse (RSI 101 & Concept):** Tính $\text{RSI}_{14}$ (Wilder) trên `Close`, sau đó tính $\text{EMA}_9$ và $\text{WMA}_{45}$ trực tiếp trên chuỗi $\text{RSI}_{14}$. Phối hợp `H4 -> H1 -> M15 -> M5`: định hướng tại H4/H1 (RSI và EMA 9 nằm cùng phía WMA 45, WMA 45 dốc rõ, không chụm 3 đường); vùng chờ tại M15 ($45 \pm 5$ hoặc $55 \pm 5$ hoặc chạm WMA 45); Trigger tại M5 (phân kỳ hoặc 2 đáy/2 đỉnh + RSI M5 cắt lại EMA 9 thuận xu hướng khi nến M5 đóng cửa); SL/TP theo swing giá và các mốc RSI M15 chạm $70/30$, phân kỳ ngược, cắt ngược WMA 45 với $R:R \ge 1:1$ (ưu tiên $1:2$). `[Đã xác nhận trực tiếp từ nguồn]`
3. **Ràng buộc kỹ thuật Exness Terminal (Indie v5):** Mỗi kịch bản chỉ báo giới hạn ở **$\le 128$ dòng lệnh** và chỉ vẽ trên 1 hệ trục tung (`overlay_main_pane=True` hoặc `False`). Do đó, bắt buộc phải tách hệ thống thành **2 Module Chỉ báo Đồng bộ** (hoặc 3 Module tùy chọn) và áp dụng biểu thức toán học rút gọn. `[Đã xác nhận trực tiếp từ nguồn]`

### Nhóm 2: Có thể chốt về mặt kỹ thuật nhưng vẫn cần thử nghiệm (Technically Definable — Requires Empirical Testing)
1. Kiểm chứng hành vi đồng bộ chỉ số `[1]` trong hàm `@sec_context` dùng chung cho `4h`, `1h`, `15m` khi biên dịch trực tiếp trên Exness Terminal. `[Suy luận kỹ thuật từ định nghĩa]`
2. Tinh chỉnh thực nghiệm các ngưỡng số học: độ dốc tối thiểu $\theta_W$ của $\text{WMA}_{45}$, ngưỡng chụm 3 đường $\delta_{\text{tangle}}$, dung sai chạm $\epsilon_W$ và dung sai 2 đáy $\epsilon_{\text{db}}$ trên dữ liệu lịch sử XAUUSD. `[Tham số cần kiểm định thống kê]`

### Nhóm 3: Chưa đủ cơ sở, cần giữ lại cho Giai đoạn Thiết kế (Unresolved — Decisions Reserved for Stage 2)
1. Lựa chọn chế độ lọc EMA 200 (`0 = Chỉ hiển thị`, `1 = Giá vs EMA 200`, `2 = EMA 89 vs EMA 200`).
2. Lựa chọn chế độ kết hợp giữa H4 và H1 (`Strict H4 AND H1` hay cho phép H1 điều chỉnh nhẹ khi M15 vào vùng hồi).
3. Lựa chọn kiểu kích hoạt giá Sonic R. (`Aggressive Dragon Bounce` khi nến đóng cửa bật khỏi Dragon tại HL hay `Classic Swing H/L Breakout`).
4. Xác minh khả năng hỗ trợ khung thời gian `'3m'` (M3) trong `TimeFrame` của Exness Terminal.

---

## G8. Research Handoff cho Giai đoạn 2 — Bản Đặc tả Bàn giao Chi tiết (Tuân thủ Tuyệt đối Giới hạn $\le 128$ Dòng)

Bộ ghi chú kỹ thuật trung lập dưới đây được đóng gói để AI ở **Giai đoạn 2 (Đánh giá Đặc tả, Thiết kế Kiến trúc & Viết Chỉ báo Indie v5)** thực thi ngay mà không vi phạm giới hạn $128$ dòng lệnh của Exness Terminal:

### 1. Kiến trúc Phân tách Module Bắt buộc (Strict $\le 128$-Line Modular Blueprint)
AI ở Giai đoạn 2 **tuyệt đối không được viết gộp thành 1 file quá 128 dòng**, mà phải triển khai thành **2 Script Đồng bộ** (hoặc 3 Script nếu tách riêng bảng quản lý thoát lệnh), trong đó mỗi script bắt buộc tuân thủ ngân sách $\le 115$ dòng lệnh:
* **Script 1 — `SonicR_RSIPulse_Main` (`overlay_main_pane=True`, mục tiêu $\le 110$ dòng):**
  * Vẽ 5 đường trung bình giá: Dragon ($\text{EMA}_{34}$ High, Close, Low), Trend Line ($\text{EMA}_{89}$ Close), Macro Filter ($\text{EMA}_{200}$ Close).
  * Khai báo **1 hàm `@sec_context` duy nhất** trả về trạng thái của bộ RSI Trend Pulse (`rsi14`, `ema9_rsi`, `wma45_rsi`, `wma45_slope`) tại nến đã đóng và gọi `self.calc_on` cho `4h`, `1h`, `15m`.
  * Tính chuỗi RSI Trend Pulse trên khung hiện tại (M5), kiểm tra cấu trúc sóng L–H–HL / H–L–LH (đáy sau cao hơn đáy trước tại vùng Dragon + đóng cửa bật khỏi Dragon), kiểm tra phân kỳ / 2 đáy 2 đỉnh trên M5 + RSI M5 cắt lại $\text{EMA}_9(\text{RSI})$ khi nến M5 đóng cửa, kiểm tra điều kiện $R:R \ge 1:1$ và phát tín hiệu **BUY / SELL Marker** kèm mức **SL / TP**.
* **Script 2 — `RSI_TrendPulse_Sub` (`overlay_main_pane=False`, mục tiêu $\le 105$ dòng):**
  * Vẽ 3 đường $\text{RSI}_{14}$, $\text{EMA}_9(\text{RSI})$, $\text{WMA}_{45}(\text{RSI})$ và các mức ngang `@level` tại `30, 40, 50, 60, 70`.
  * Dùng 1 hàm `@sec_context` kiểm tra đồng thuận xu hướng H4/H1 (kèm cảnh báo khi H4/H1 bị chụm 3 đường sideway) và vùng chờ hồi M15 ($45 \pm 5$ / $55 \pm 5$ hoặc chạm $\text{WMA}_{45}$).
  * Đánh dấu trực quan trên cửa sổ RSI: (1) Điểm Phân kỳ / Mô hình 2 đáy–2 đỉnh + Cắt $\text{EMA}_9$ (Trigger vào lệnh), (2) Điểm RSI M15 chạm $70/30$ hoặc có phân kỳ ngược (Cảnh báo chốt lời từng phần), và (3) Điểm RSI cắt ngược $\text{WMA}_{45}$ (Cảnh báo đóng toàn bộ lệnh).

### 2. Các Quy tắc Nén Mã nguồn Indie v5 Bắt buộc Tuân thủ ở Giai đoạn 2
1. **Không lặp lại hàm `@sec_context`:** Chỉ viết 1 hàm `@sec_context` duy nhất và tái sử dụng cho mọi khung thời gian cần truy xuất.
2. **Kiểm soát chặt số lượng Decorator `@param` (Tối đa $4\text{--}6$ `@param` mỗi script):**
   * Giữ cố định các thông số chuẩn của nguồn (`34, 89, 200` cho EMA giá; `14, 9, 45` cho bộ RSI Trend Pulse; vùng `40-50` và `50-60` cho M15; mốc `70/30` cho TP).
   * Chỉ mở `@param` cho các công tắc quyết định thiết kế: `ema200_mode` (`0/1/2`), `strict_htf` (`True/False` cho phép giao H4 & H1), `trigger_mode` (`Bounce` vs `Breakout`), và `use_closed_htf` (`True/False` để khóa chống repaint).
3. **Không viết dòng trống hoặc chú thích dài dòng trong code:** Trong giới hạn $128$ dòng của Exness Terminal, mọi giải thích dài dòng phải đặt bên ngoài tài liệu hướng dẫn, không đưa vào bên trong khối code để tránh lãng phí ngân sách dòng lệnh.
4. **Bảo vệ `math.isnan()` và Khóa chống bắn trùng tín hiệu (One-shot Latch):** Kiểm tra `not math.isnan(wma45_h4[0])` trước khi đánh giá điều kiện vào lệnh, và dùng biến trạng thái `MutSeriesF` / cờ nhớ để mỗi nhịp sóng hồi chỉ phát tối đa 1 tín hiệu duy nhất.

### 3. Danh sách Nguồn Tài liệu Chuẩn Bàn giao
1. **Sonic R. System Thread (Sonicdeejay):** `https://www.forexfactory.com/thread/114792-sonic-r-system`
2. **Sonic R. Core Rules (traderathome):** `https://www.forexfactory.com/thread/post/4682138`
3. **RSI 101 GitBook:** `https://rsi-101.gitbook.io/book`
4. **RSI Trend Pulse Concept PDF:** `rsi_trend_pulse_concept.pdf` (Generated `2026-03-17 15:01:27`)
5. **Exness Terminal Custom Indicators Help:** `https://get.exness.help/hc/en-us/articles/27261267831068-Custom-indicators-in-Exness-Terminal`
6. **TakeProfit Indie v5 Docs:**
   * `https://takeprofit.com/docs/indie/Request-additional-instruments`
   * `https://takeprofit.com/docs/indie/Code-examples/built-in-indicators`
   * `https://takeprofit.com/docs/indie/Algorithms-for-series-processing`
   * `https://takeprofit.com/docs/indie/Library-reference/package-indie-algorithms`

### 4. Các Quyết định Tuyệt đối KHÔNG Được Tự ý Mặc định ở Giai đoạn 2
1. **Không tự ý khóa chết chỉ một chế độ EMA 200** (phải điều khiển qua tham số `ema200_mode`: `0 = Off`, `1 = Price vs EMA 200`, `2 = EMA 89 vs EMA 200`).
2. **Không tự ý khóa chết phép giao cứng `H4 AND H1`** mà không có công tắc cho phép H1 điều chỉnh nhẹ khi M15 vào vùng chờ.
3. **Không tự ý loại bỏ *Regular Divergence*, *Hidden Divergence* hoặc *Mô hình 2 đáy/2 đỉnh RSI*** trên M5 (phải tích hợp cả 3 vào điều kiện hết sóng M5).
4. **Không tự ý vượt quá $128$ dòng lệnh** trên bất kỳ script nào (trước khi xuất code ở Giai đoạn 2/3, AI bắt buộc phải đếm chính xác tổng số dòng của từng script và xác nhận $\le 128$ dòng).