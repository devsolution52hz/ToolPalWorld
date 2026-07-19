# 🎮 ToolPalWorld — Palworld Loot Tool

Tool có giao diện giúp **tùy chỉnh vật phẩm rơi ra khi giết Pal** trong Palworld — chọn item, nhập số lượng, bấm Lưu là xong, khỏi phải sửa file config bằng tay.

Hoạt động dựa trên mod **CustomizableLootDrops** (UE4SS). Tool chỉ ghi file `config.jsonc` cho mod, không can thiệp gì khác.

---

## ✅ Yêu cầu (cần tải & cài trước)

Cài theo thứ tự sau:

### 1️⃣ UE4SS (bản Okaetsu cho Palworld) — bộ nạp mod
🔗 **Tải:** https://github.com/Okaetsu/RE-UE4SS/releases/tag/experimental-palworld
- Tải file **`UE4SS-Palworld.zip`**
- Giải nén → copy `dwmapi.dll` **và** thư mục `ue4ss` vào:
  ```
  ...\Palworld\Pal\Binaries\Win64\
  ```
- ⚠️ Phải dùng đúng **bản Okaetsu này** — bản UE4SS chung sẽ gây crash.

### 2️⃣ CustomizableLootDrops — mod xử lý rơi đồ
🔗 **Tải:** https://www.nexusmods.com/palworld/mods/3836
- Giải nén → copy thư mục `CustomizableLootDrops` vào:
  ```
  ...\Palworld\Pal\Binaries\Win64\ue4ss\Mods\
  ```

### 3️⃣ Tool này (ToolPalWorld)
🔗 **Tải:** https://github.com/devsolution52hz/ToolPalWorld
- Tải file **`PalworldLootTool.exe`** về là chạy được.

> Nếu đập Pal chưa ra đồ custom → kiểm tra bước 1 & 2 đã cài đúng vị trí chưa.

---

## 🚀 Cách dùng

1. Tải và chạy **`PalworldLootTool.exe`**.
   > Windows có thể hiện *"Windows protected your PC"* (vì exe chưa ký) → bấm **More info → Run anyway**. Không phải virus.

2. **Đường dẫn game** (dòng trên cùng):
   - Mặc định là `D:\Steam\steamapps\common\Palworld`.
   - Nếu game ở ổ/thư mục khác → dán đường dẫn **thư mục gốc Palworld** (chứa `Palworld.exe`) vào, hoặc bấm **`...`** để duyệt → bấm **Áp dụng**.
   - Dòng trạng thái **xanh** = nhận diện mod OK. **Đỏ** = sai đường dẫn.
   - Đường dẫn được **tự lưu**, lần sau mở khỏi nhập lại.

3. **Bật/Tắt mod** (ô tích `BẬT MOD (ON)`):
   - ✅ **ON**: cho chọn item + nhập số lượng.
   - ⬜ **OFF**: khóa chọn item. Bấm Lưu → mod tắt, **game farm bình thường**.

4. **Chọn item** (khi ON):
   - Gõ tên hoặc mã item vào ô **Tìm item**.
   - Chọn trong danh sách → bấm **Thêm →** (hoặc double-click).
   - Tối đa **7 item** (game giới hạn số ô drop mỗi Pal).

5. **Số lượng**: click vào cột **Số lượng** trong bảng bên phải, gõ số (tối đa 99999).

6. Bấm **LƯU & ÁP DỤNG** (nút xanh).

7. **RESTART Palworld** (thoát hẳn ra desktop + mở lại) → đập Pal là ra đồ.

---

## ✨ Tính năng

- Chỉ hiện **item hợp lệ** → không lo lỗi ID.
- Tìm được bằng **tên** hoặc **mã nội bộ** (VD `[StainlessSteel]`).
- **Toggle ON/OFF** — tắt mod về farm bình thường không cần gỡ.
- **Nhập đường dẫn game** — dời game qua ổ khác chỉ cần dán lại.
- Mở tool là **tự hiện config hiện tại** đang set.

---

## ⚠️ Lưu ý

- **Mỗi lần Lưu đều phải RESTART game** mới ăn (mod chỉ nạp config lúc khởi động).
- Chỉ dùng cho **single-player / offline**. Đừng đem save modded lên server chính thức.
- Vài item tên hiển thị là "Unknown" (do mod thiếu tên) — tìm bằng mã vẫn ra.
- Tool chỉ ghi item **có thật trong game** nên save vẫn an toàn khi mang qua máy khác.

---

## 📂 File trong repo

| File | Mô tả |
|---|---|
| `PalworldLootTool.exe` | Chạy tool (double-click) |
| `LootTool.ps1` | Mã nguồn PowerShell |
| `README.md` | File này |

---

*Tool tạo với sự hỗ trợ của Claude.*
