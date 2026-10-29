# 17 — INDIE V5 COMPILER ERROR LEDGER & ARCHITECTURAL RULES (EXNESS WEB TERMINAL)

## 1. Bối cảnh & Mục đích
Tài liệu này ghi lại toàn bộ hồ sơ lỗi biên dịch thực tế trên trình biên dịch TakeProfit Indie v5 của Exness Terminal Web trong quá trình chuyển giao mã nguồn (Phase 3). 
Mục tiêu: Đóng băng các quy chuẩn cú pháp, không thử nghiệm lặp lại các cấu trúc AST bị cấm, đảm bảo mã nguồn vượt qua khâu kiểm tra cú pháp ngay trong lần biên dịch đầu tiên.

---

## 2. Bảng đối chiếu lỗi (Error Ledger & Rule Matrix)

| STT | Thông báo lỗi trên Exness | Cú pháp gốc gây lỗi (Python tiêu chuẩn) | Bản chất kỹ thuật trong AST Parser của Indie | Giải pháp kiến trúc bắt buộc (Indie v5 Standard) |
|:---:|---|---|---|---|
| **E1** | `Line XX: Unknown member` | `color.rgb(r, g, b)` | Thư viện `indie.color` chỉ xuất khẩu `color.rgba(r, g, b, a)` và bảng hằng số màu. Không có hàm `color.rgb()`. | Bắt buộc dùng `color.rgba(r, g, b, 1.0)`. |
| **E2** | `cannot process multiple operands in comparison like 'x < y < z'` | `40.0 <= r <= 50.0`<br>`3 <= diff <= max` | AST visitor của Indie không hạ giải (lower) toán tử so sánh chuỗi (chained comparison). | Phân tích tường minh thành các phép so sánh nhị phân kết hợp `and`:<br>`(40.0 <= r and r <= 50.0)` |
| **E3** | `tuple unpacking operation is not supported` | `ph, kh = self.high[k], k`<br>`v_lo, v_hi = c1, c2`<br>`rl2, pl2, kl2 = ...` | Indie cấm unpacking tuple từ các biểu thức không phải hàm (tuple literal, variable expression). Unpacking tuple **CHỈ** được hỗ trợ khi vế phải là lời gọi hàm trực tiếp. | Tách toàn bộ việc gán trong vòng lặp/logic thành các câu lệnh gán đơn lẻ:<br>`ph = self.high[k]; kh = k` |
| **E4** | `Line XX: Undefined symbol` (hàng loạt) | `k_rph = k_rpl = kh = 0` | Indie không hỗ trợ gán chuỗi (chained assignment). Trình biên dịch chỉ đăng ký định danh đầu tiên, bỏ qua toàn bộ định danh phía sau. | Khai báo từng biến độc lập trên từng phép gán (ngăn cách bằng `;` hoặc xuống dòng):<br>`kh = 0; kl = 0; ...` |
| **E5** | `unsupported assignment` | 1. `self.r4 = self.p4[0]` trong `__init__`<br>2. `self.lock_ph = val` trong `calc()` | 1. Không thể gán chỉ mục của proxy tuple vào thuộc tính lớp.<br>2. `self` trong `calc()` là execution context bất biến (immutable) để hỗ trợ cơ chế intrabar rollback khi có tick mới. Trình biên dịch cấm gán trực tiếp `self.attr = ...` trong `calc()`. | 1. Unpack trực tiếp từ hàm ở `__init__`:<br>`self.r4, self.e4, self.w4, self.s4 = self.calc_on(...)`<br>2. Cập nhật state container qua `.set()` và đọc qua `.get()`. |
| **E6** | `indie.Var[T].new is a syntactic sugar function in Indie and can only be called from a function decorated with @indie.algorithm, @indie.sec_context or @indie.indicator or from non-__init__ method of a class inherited from indie.MainContext, indie.SecContext or indie.Algorithm` | `self.lock_u_bar = Var[int].new(-1)` bên trong hàm `__init__()` | `Var[T].new` là cú pháp đặc biệt (syntactic sugar) liên kết trực tiếp với bar context tại callsite của từng nến. Phương thức `__init__` chỉ là constructor tĩnh khi khởi tạo đồ thị, không có bar evaluation context nên Indie cấm gọi `Var[T].new` trong `__init__`. | Gọi `Var[T].new(...)` ở đầu hàm `calc(self)` (là non-`__init__` method của class kế thừa từ `MainContext`). Các biến này tự động duy trì giá trị qua các nến nhờ cơ chế quản lý vòng đời của Indie. |
| **E7** | `all statements must be in indented blocks` | Viết câu lệnh trên cùng 1 dòng sau dấu `:`, ví dụ:<br>`if cond: stmt`<br>`elif cond: stmt`<br>`else: stmt` | Ngữ pháp của trình biên dịch TakeProfit Indie không chấp nhận câu lệnh đơn cùng dòng (`stmt_list`). Tất cả các khối lệnh điều khiển bắt buộc phải là một khối thụt đầu dòng (indented block) nằm ở các dòng tiếp theo. | Xuống dòng và thụt 4 khoảng trắng cho mọi câu lệnh bên trong `if`, `elif`, `else`, `for`. Tuyệt đối không viết câu lệnh cùng hàng với dấu hai chấm `:`. |
| **E8** | `cannot convert float NaN to integer` | `math.floor(self.close[1] / self.rnd_step)` | Ở cây nến đầu tiên (`bar_index == 0`) hoặc các nến warmup, `self.close[1]` mang giá trị `math.nan`. Trong Python, `math.floor(float('nan'))` ném ngoại lệ `ValueError: cannot convert float NaN to integer`. | Sử dụng guard điều kiện ngắn mạch (short-circuit guard) trước khi gọi hàm toán học số nguyên:<br>`has_c1 = not math.isnan(self.close[1])`<br>`same_step = has_c1 and (c_lo == math.floor(self.close[1] / rnd_step) * rnd_step)` |

---

## 3. Kiến trúc State Management chuẩn mực trong Indie v5

### 3.1. Phân định rõ ràng giữa `__init__` và `calc()`
- Trong `__init__(self, ...)`:
  - Chỉ lưu các tham số cấu hình: `self.param = param`.
  - Khởi tạo Secondary Context bằng cách unpack trực tiếp:
    `self.r4, self.e4, self.w4, self.s4 = self.calc_on(HtfPulse, time_frame=TimeFrame.from_str('4h'))`
  - **TUYỆT ĐỐI KHÔNG** khởi tạo `Var[T].new(...)` trong `__init__`.
  - **TUYỆT ĐỐI KHÔNG** subscript proxy context (`self.p4[0]`).

- Trong `calc(self)`:
  - Khởi tạo các State Container ở đầu hàm:
    ```python
    lock_u_bar = Var[int].new(-1); lock_d_bar = Var[int].new(-1)
    lock_ph = Var[float].new(math.nan); lock_pl = Var[float].new(math.nan)
    ```
  - Đọc giá trị qua `.get()`:
    ```python
    cyc_u = (self.bar_index - kh > lock_u_bar.get()) and (math.isnan(lock_ph.get()) or ph >= lock_ph.get())
    ```
  - Cập nhật giá trị qua `.set()`:
    ```python
    if dc[1] < e89[1]: 
        lock_ph.set(math.nan)
    if fire_up:
        lock_u_bar.set(self.bar_index)
        lock_ph.set(ph)
    ```
  - **TUYỆT ĐỐI KHÔNG** gán vào thuộc tính của `self` (`self.xyz = ...`).

---

## 4. Danh sách kiểm tra nghiệm thu tĩnh (Static Pre-Flight Checklist)
Trước khi bàn giao bất kỳ script Indie nào cho người dùng dán vào Exness Terminal:
1. [x] Không còn `color.rgb(...)` (100% `color.rgba(..., 1.0)`).
2. [x] Không còn toán tử so sánh chuỗi `x < y < z`.
3. [x] Không còn tuple unpacking trong `calc()`.
4. [x] Không còn gán chuỗi `a = b = 0`.
5. [x] Không có bất kỳ phép gán `self.something = ...` nào bên trong hàm `calc()`.
6. [x] Không gọi `Var[T].new(...)` bên trong `__init__`; 100% `Var[T].new` nằm ở đầu `calc()`.
7. [x] 100% khối lệnh điều khiển (`if`, `elif`, `else`, `for`) được xuống dòng và thụt đầu dòng (indented blocks).
8. [x] 100% hàm toán học (`math.floor`, `math.ceil`, `int()`) được bọc bảo vệ kiểm tra `math.isnan()` để tránh lỗi `cannot convert float NaN to integer`.
9. [x] Tổng số dòng vật lý $\le 128$ dòng (đáp ứng ràng buộc thiết kế của Exness).
