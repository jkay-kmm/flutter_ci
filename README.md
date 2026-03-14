# Flutter CI/CD với GitHub Actions 

Dự án này sử dụng GitHub Actions để tự động hóa quá trình Test, Build và Release file APK mỗi khi có phiên bản mới được đẩy lên.

Dưới đây là các bước thiết lập chi tiết để cấu hình CI/CD.

---

## Bước 1: Tạo file cấu hình Workflow
Trong thư mục gốc của project, bạn cần tạo các thư mục và file với đường dẫn chính xác như sau:
`.github/workflows/main.yaml`

*(File `main.yaml` là nơi chứa kịch bản tự động hóa. Đảm bảo bạn đã dán chuẩn code cấu hình cho Flutter phiên bản mới nhất vào đây).*

## Bước 2: Tạo GitHub Personal Access Token (Mã thông báo cá nhân)
Mã này đóng vai trò như một chiếc "chìa khóa" để GitHub Actions có quyền tạo bản Release mới trên kho lưu trữ của bạn.

1. Đăng nhập vào GitHub, bấm vào **ảnh đại diện** ở góc trên cùng bên phải > Chọn **Settings** (Cài đặt).
2. Cuộn thanh menu bên trái xuống dưới cùng > Chọn **Developer settings**.
3. Ở menu bên trái, chọn **Personal access tokens** > Click vào **Tokens (classic)**.
4. Bấm nút **Generate new token** ở góc phải > Chọn **Generate new token (classic)**.
5. Điền các thông tin cần thiết:
    * **Note:** Đặt tên gợi nhớ, ví dụ: `Flutter CI/CD Token`.
    * **Expiration:** Chọn thời hạn sống cho token (VD: `30 days`, `90 days`, hoặc `No expiration`).
    * **Select scopes:** ⚠️ Quan trọng: Hãy **tích vào ô `repo`** để cấp quyền kiểm soát kho lưu trữ.
6. Cuộn xuống cuối trang và bấm nút xanh **Generate token**.
7. **LƯU Ý:** Màn hình sẽ hiện ra một đoạn mã dài (bắt đầu bằng `ghp_...`). Hãy **copy và lưu lại ngay lập tức** vì GitHub chỉ hiển thị nó một lần duy nhất.

## Bước 3: Thêm Token vào Repository Secrets
Bây giờ, bạn cần mang "chìa khóa" vừa tạo cất vào két sắt của dự án để file `main.yaml` có thể lấy ra sử dụng.

1. Vào trang chính của kho lưu trữ (repository) dự án trên GitHub.
2. Bấm vào tab **Settings** (Cài đặt).
3. Ở thanh menu bên trái, tìm mục **Security** > Mở rộng mục **Secrets and variables** > Chọn **Actions**.
4. Bấm vào nút màu xanh **New repository secret**.
5. Điền thông tin như sau:
    * **Name:** Nhập chính xác là `TOKEN` (Viết hoa toàn bộ).
    * **Secret:** Dán (Paste) đoạn mã `ghp_...` vừa copy ở Bước 2 vào đây.
6. Bấm **Add secret**.

## Bước 4: Đẩy code và kích hoạt Workflow
Khi đã tạo xong cấu hình và gắn Token thành công, bạn chỉ cần commit code và đẩy lên kèm theo một thẻ phiên bản (tag).

Mở terminal tại thư mục dự án và chạy lần lượt các lệnh sau:

```bash
# 1. Thêm và lưu lại toàn bộ code (bao gồm cả thư mục .github)
git add .
git commit -m "Thêm cấu hình Github Actions CI/CD"

# 2. Đẩy code lên nhánh chính (thay main bằng nhánh của bạn nếu cần)
git push origin main

# 3. Tạo một tag phiên bản mới
git tag v1.0

# 4. Đẩy tag lên GitHub để kích hoạt Github Actions
git push origin v1.0