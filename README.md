# Fedora KDE setup: SDDM + Kitty

Bộ cấu hình mình dùng trên Fedora 44 KDE Plasma. Script cài SDDM, Kitty và các gói Qt cần cho theme đăng nhập; chép màu SDDM và Kitty; chuyển display manager sang SDDM cho lần khởi động tiếp theo.

## Cài đặt

Trên Fedora, mở terminal bằng tài khoản thường:

```bash
git clone https://github.com/USERNAME/fedora-setup.git
cd fedora-setup
bash install.sh
```

Script sẽ hỏi mật khẩu `sudo`, cài gói bằng `dnf`, tải [Simple SDDM Theme 2](https://github.com/JaKooLit/simple-sddm-2), lưu bản sao các cấu hình hiện có với đuôi `.bak.YYYYMMDD-HHMMSS`, rồi bật SDDM. Khởi động lại sau khi script hoàn tất. Nếu đang dùng một display manager khác, màn hình đăng nhập sẽ đổi ở lần khởi động sau.

Để font Kitty giống máy gốc, cài **JetBrainsMono Nerd Font** từ [Nerd Fonts](https://www.nerdfonts.com/font-downloads) vào `~/.local/share/fonts` rồi chạy `fc-cache -f`. Kitty vẫn chạy nếu chưa cài font, nhưng sẽ dùng font thay thế.

## Ảnh nền SDDM

Ảnh nền đang dùng trên máy gốc không được đưa vào repo. Cấu hình chia sẻ dùng ảnh mặc định của theme. Nếu muốn dùng ảnh riêng:

1. Chép ảnh của bạn vào `/usr/share/sddm/themes/simple_sddm_2/Backgrounds/` với `sudo`.
2. Đổi dòng `Background=Backgrounds/default` trong `/usr/share/sddm/themes/simple_sddm_2/theme.conf.user` thành tên ảnh mới, ví dụ `Background=Backgrounds/my-photo.jpg`.

## Tệp trong repo

- `config/sddm.conf`: chọn SDDM theme và bàn phím ảo.
- `config/theme.conf.user`: màu và độ tối nền của màn hình đăng nhập.
- `config/kitty.conf`: font, cửa sổ và bảng màu Tokyo Night Dark.
- `install.sh`: cài đặt và sao lưu trước khi ghi đè.

Script cần mạng để cài gói và tải theme. Cấu hình dành cho Fedora; trên máy KDE Plasma, SDDM thường đã có sẵn, nhưng script cũng dùng được để chuyển từ display manager khác. Muốn quay lại, khôi phục các tệp `.bak.*` và bật lại dịch vụ display manager trước đó bằng `sudo systemctl enable --force TEN-DICH-VU.service`.

Theme SDDM thuộc dự án [JaKooLit/simple-sddm-2](https://github.com/JaKooLit/simple-sddm-2); repo này chỉ lưu phần tùy chỉnh của mình, không sao chép mã theme hay font.
